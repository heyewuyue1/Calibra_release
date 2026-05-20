from functools import lru_cache

import numpy as np
import torch

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")


def _flatten_tree_batch(trees):
    x_list = []
    idx_list = []

    def recur(node, x, idx):
        curr_idx = len(x)
        value = node[0]
        x.append(value)
        idx.append((None, None))

        left_idx, right_idx = None, None
        if len(node) > 1:
            left_idx = recur(node[1], x, idx)
        if len(node) > 2:
            right_idx = recur(node[2], x, idx)

        idx[curr_idx] = (left_idx, right_idx)
        return curr_idx

    for tree in trees:
        x, idx = [], []
        recur(tree, x, idx)
        x_list.append(np.stack(x))
        idx_list.append(idx)

    max_nodes = max(arr.shape[0] for arr in x_list)
    feat_dim = x_list[0].shape[1]

    x_padded = np.zeros((len(x_list), max_nodes, feat_dim), dtype=np.float32)
    for i, arr in enumerate(x_list):
        x_padded[i, :arr.shape[0], :] = arr

    return torch.from_numpy(x_padded).to(device), idx_list


def _tree_lru_cache_key(idx_list):
    return tuple(tuple(tree_idx) for tree_idx in idx_list)


@lru_cache(maxsize=512)
def _build_tree_lru_schedule(cache_key):
    idx_list = cache_key
    metadata_cache = {}

    def tree_metadata(idx):
        key = tuple(idx)
        cached = metadata_cache.get(key)
        if cached is not None:
            return cached

        reachable = []
        stack = [0]
        seen = set()
        while stack:
            node_idx = stack.pop()
            if node_idx is None or node_idx in seen:
                continue
            seen.add(node_idx)
            reachable.append(node_idx)
            left_idx, right_idx = idx[node_idx]
            if right_idx is not None:
                stack.append(right_idx)
            if left_idx is not None:
                stack.append(left_idx)

        actual_count = max(reachable) + 1 if reachable else 0
        left = [-1] * actual_count
        right = [-1] * actual_count
        heights = [-1] * actual_count

        for node_idx in range(actual_count):
            left_idx, right_idx = idx[node_idx]
            if left_idx is not None:
                left[node_idx] = left_idx
            if right_idx is not None:
                right[node_idx] = right_idx

        def height(node_idx):
            cached_height = heights[node_idx]
            if cached_height != -1:
                return cached_height
            left_idx = left[node_idx]
            right_idx = right[node_idx]
            if left_idx == -1 and right_idx == -1:
                heights[node_idx] = 0
            else:
                left_height = height(left_idx) if left_idx != -1 else -1
                right_height = height(right_idx) if right_idx != -1 else -1
                heights[node_idx] = max(left_height, right_height) + 1
            return heights[node_idx]

        max_height = height(0) if actual_count else -1
        levels = [[] for _ in range(max_height + 1)]
        for node_idx in range(actual_count):
            levels[heights[node_idx]].append(node_idx)

        cached = {
            "levels": tuple(tuple(level) for level in levels),
            "left": tuple(left),
            "right": tuple(right),
        }
        metadata_cache[key] = cached
        return cached

    metadata = [tree_metadata(idx) for idx in idx_list]
    max_level = max((len(item["levels"]) for item in metadata), default=0)
    level_schedule = []
    for level in range(max_level):
        batch_indices = []
        node_indices = []
        left_indices = []
        right_indices = []
        for batch_idx, item in enumerate(metadata):
            if level >= len(item["levels"]):
                continue
            for node_idx in item["levels"][level]:
                batch_indices.append(batch_idx)
                node_indices.append(node_idx)
                left_indices.append(item["left"][node_idx])
                right_indices.append(item["right"][node_idx])
        level_schedule.append(
            {
                "batch": torch.tensor(batch_indices, dtype=torch.long),
                "node": torch.tensor(node_indices, dtype=torch.long),
                "left": torch.tensor(left_indices, dtype=torch.long),
                "right": torch.tensor(right_indices, dtype=torch.long),
            }
        )
    return {
        "cache_key": cache_key,
        "levels": level_schedule,
    }


def flatten_tree_batch_for_tree_lru(trees):
    x_batch, idx_list = _flatten_tree_batch(trees)
    schedule = _build_tree_lru_schedule(_tree_lru_cache_key(idx_list))
    return x_batch, idx_list, schedule
