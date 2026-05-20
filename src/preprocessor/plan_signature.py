from collections import defaultdict
from pathlib import Path

from preprocessor.node import Node
from request_models import PlanInfo

IMDB_TABLE_ALIASES = {
    "aka_name": "an",
    "aka_title": "at",
    "cast_info": "ci",
    "char_name": "chn",
    "comp_cast_type": "cct",
    "company_name": "cn",
    "company_type": "ct",
    "complete_cast": "cc",
    "info_type": "it",
    "keyword": "k",
    "kind_type": "kt",
    "link_type": "lt",
    "movie_companies": "mc",
    "movie_info": "mi",
    "movie_info_idx": "mii",
    "movie_keyword": "mk",
    "movie_link": "ml",
    "name": "n",
    "person_info": "pi",
    "role_type": "rt",
    "title": "t",
}

DSB_TABLE_ALIASES = {
    "call_center": "cc",
    "catalog_page": "cp",
    "catalog_returns": "cr",
    "catalog_sales": "cs",
    "customer": "c",
    "customer_address": "ca",
    "customer_demographics": "cd",
    "date_dim": "dd",
    "dbgen_version": "dv",
    "household_demographics": "hd",
    "income_band": "ib",
    "inventory": "inv",
    "item": "i",
    "promotion": "p",
    "reason": "r",
    "ship_mode": "sm",
    "store": "s",
    "store_returns": "sr",
    "store_sales": "ss",
    "time_dim": "td",
    "warehouse": "w",
    "web_page": "wp",
    "web_returns": "wr",
    "web_sales": "ws",
    "web_site": "wsite",
}

TABLE_ALIASES = {
    "JOB": IMDB_TABLE_ALIASES,
    "ExtJOB": IMDB_TABLE_ALIASES,
    "TPC-H": {
        "customer": "c",
        "lineitem": "l",
        "nation": "n",
        "orders": "o",
        "part": "p",
        "partsupp": "ps",
        "region": "r",
        "supplier": "s",
    },
    "DSB": DSB_TABLE_ALIASES,
}


def is_join_operator(operator):
    return "Join" in operator or operator == "CartesianProduct"


def table_alias(table_name, benchmark):
    benchmark_aliases = TABLE_ALIASES.get(benchmark, {})
    if table_name in benchmark_aliases:
        return benchmark_aliases[table_name]
    return table_name[:1] if table_name else "?"


def leaf_table(node):
    if node.tables and node.tables[0] is not None:
        return node.tables[0]
    columns = node.data.get("columns", [])
    for column in columns:
        if column and "." in column:
            return column.split(".", 1)[0]
    for predicate in node.data.get("predicates", []):
        column = predicate[0]
        if column and "." in column:
            return column.split(".", 1)[0]
    return None


def canonical_leaf_identities(tree, idx):
    identities = {}

    def collect(node_idx):
        node = tree[node_idx]
        if node.operator == "Scan":
            table = leaf_table(node)
            if table is None:
                return False
            identities[node_idx] = (table,)
            return True
        if node.lc is not None and not collect(node.lc):
            return False
        if node.rc is not None and not collect(node.rc):
            return False
        return True

    if not collect(idx) or not identities:
        return None
    return identities


def node_signature(tree, idx, leaf_identities):
    node = tree[idx]
    if node.operator == "Scan":
        return "scan", leaf_identities[idx]
    child_signatures = []
    if node.lc is not None:
        child_signatures.append(node_signature(tree, node.lc, leaf_identities))
    if node.rc is not None:
        child_signatures.append(node_signature(tree, node.rc, leaf_identities))
    child_signatures = tuple(sorted(child_signatures, key=repr))
    if is_join_operator(node.operator):
        return "join", child_signatures
    if len(child_signatures) == 1:
        return child_signatures[0]
    return node.operator, child_signatures


def subset_key_for_subtree(tree, idx, leaf_identities):
    identities = []

    def collect(node_idx):
        node = tree[node_idx]
        if node.operator == "Scan":
            identities.append(leaf_identities[node_idx])
            return
        if node.lc is not None:
            collect(node.lc)
        if node.rc is not None:
            collect(node.rc)

    collect(idx)
    return tuple(sorted(identities))


def shape_for_subtree(tree, idx, benchmark):
    node = tree[idx]
    if node.operator == "Scan":
        return table_alias(leaf_table(node), benchmark)

    left_shape = shape_for_subtree(tree, node.lc, benchmark) if node.lc is not None else None
    right_shape = shape_for_subtree(tree, node.rc, benchmark) if node.rc is not None else None

    if is_join_operator(node.operator):
        if left_shape and right_shape:
            return f"({left_shape} {right_shape})"
        return left_shape or right_shape or "?"

    if right_shape:
        return f"({left_shape or '?'} {right_shape})"
    return left_shape or "?"


def logical_plan_descriptor(plan_info, preprocessor, benchmark, include_subset_label=False):
    plan = plan_info if isinstance(plan_info, PlanInfo) else PlanInfo(**plan_info)
    tree = preprocessor.plan2tree(plan)
    leaf_identities = canonical_leaf_identities(tree, 1)
    if leaf_identities is None:
        raise ValueError("Unable to derive canonical leaf identities")
    subset_key = subset_key_for_subtree(tree, 1, leaf_identities)
    descriptor = {
        "subset_key": subset_key,
        "signature": node_signature(tree, 1, leaf_identities),
        "shape": shape_for_subtree(tree, 1, benchmark),
    }
    if include_subset_label:
        descriptor["subset_label"] = " ".join(
            table_alias(identity[0], benchmark) for identity in subset_key
        )
    return descriptor


def extract_stage_plan_body(stage_plan):
    body = (
        stage_plan.split("\n", 1)[1]
        if stage_plan.startswith("== Physical Plan ==") and "\n" in stage_plan
        else stage_plan
    )
    lines = []
    for line in body.splitlines():
        stripped = line.strip()
        if not stripped:
            if lines:
                break
            continue
        if stripped.startswith("(") and len(stripped) > 1 and stripped[1].isdigit():
            break
        lines.append(line)
    return "\n".join(lines)


def normalize_stage_plan_text(stage_plan):
    lines = []
    for line in stage_plan.splitlines():
        stripped = line.lstrip()
        prefix = line[: len(line) - len(stripped)]
        if "Scan parquet " in stripped and "FileScan parquet " not in stripped:
            before, after = stripped.split("Scan parquet ", 1)
            lines.append(prefix + before + "FileScan parquet " + after)
        else:
            lines.append(line)
    return "\n".join(lines)


def build_stage_plan_tree(stage_plan, preprocessor):
    tree = [Node("Root", 0, [], -1, -1, {})]
    body = normalize_stage_plan_text(extract_stage_plan_body(stage_plan))
    preprocessor._parse_stage_plan_into_tree(tree, 1, body)
    preprocessor._fill_join_tables_bottom_up(tree, 0)
    return tree


def stage_plan_signatures(stage_plan, preprocessor):
    tree = build_stage_plan_tree(stage_plan, preprocessor)
    signatures = defaultdict(set)
    for idx in range(1, len(tree)):
        node = tree[idx]
        if not is_join_operator(node.operator):
            continue
        leaf_identities = canonical_leaf_identities(tree, idx)
        if leaf_identities is None:
            continue
        subset_key = subset_key_for_subtree(tree, idx, leaf_identities)
        if subset_key:
            signatures[subset_key].add(node_signature(tree, idx, leaf_identities))
    return dict(signatures)


def load_plan_signatures_by_query(benchmark, root_path, preprocessor):
    plan_dir = Path(root_path) / benchmark
    signatures_by_query = {}
    if not plan_dir.exists():
        return signatures_by_query

    for plan_path in sorted(plan_dir.iterdir()):
        if plan_path.is_file():
            signatures_by_query[plan_path.name] = stage_plan_signatures(
                plan_path.read_text(encoding="utf-8"), preprocessor
            )
    return signatures_by_query


def build_candidate_descriptors(
    candidates,
    preprocessor,
    benchmark,
    include_subset_label=False,
):
    descriptors = [
        logical_plan_descriptor(candidate, preprocessor, benchmark, include_subset_label)
        for candidate in candidates
    ]
    same_subset = len({info["subset_key"] for info in descriptors}) == 1
    dp_level = max((len(info["subset_key"]) for info in descriptors), default=0)
    return descriptors, same_subset, dp_level
