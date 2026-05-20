def same_subset(signatures):
    return len({info["subset_key"] for info in signatures}) == 1


def slate_selection_kind(signatures):
    return "intra" if same_subset(signatures) else "inter"


def _matching_candidates(teacher_by_subset, signatures):
    return [
        idx
        for idx, info in enumerate(signatures)
        if info["signature"] in teacher_by_subset.get(info["subset_key"], set())
    ]


def resolve_pairwise_teacher_choice(teacher_by_subset, signatures):
    if len(signatures) != 2:
        return None, "insufficient_candidates"
    if not same_subset(signatures):
        return None, "mismatched_pair_subset"

    subset_key = signatures[0]["subset_key"]
    teacher_subset_signatures = teacher_by_subset.get(subset_key)
    if not teacher_subset_signatures:
        return None, "missing_pair_teacher_candidate"

    matches = [
        idx
        for idx, info in enumerate(signatures)
        if info["signature"] in teacher_subset_signatures
    ]
    if len(matches) == 1:
        return matches, None
    if not matches:
        return None, "missing_pair_teacher_candidate"
    return None, "ambiguous_teacher_choice"


def label_intra_slate_with_teacher(teacher_by_subset, signatures):
    subset_key = signatures[0]["subset_key"]
    teacher_subset_signatures = teacher_by_subset.get(subset_key)
    if not teacher_subset_signatures:
        return None, "missing_teacher_subset"

    matches = [
        idx
        for idx, info in enumerate(signatures)
        if info["signature"] in teacher_subset_signatures
    ]
    if len(matches) == 1:
        return matches, None
    if not matches:
        return None, "missing_teacher_candidate"
    return None, "ambiguous_teacher_choice"


def label_inter_slate_with_teacher(teacher_by_subset, signatures):
    matches = _matching_candidates(teacher_by_subset, signatures)
    if matches:
        return matches, None
    else:
        return None, "missing_inter_teacher_candidate"


def label_slate_with_teacher(teacher_by_subset, signatures):
    if same_subset(signatures) and len(signatures) == 2:
        return resolve_pairwise_teacher_choice(teacher_by_subset, signatures)
    if same_subset(signatures):
        return label_intra_slate_with_teacher(teacher_by_subset, signatures)
    return label_inter_slate_with_teacher(teacher_by_subset, signatures)
