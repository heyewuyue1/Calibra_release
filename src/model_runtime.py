import torch

from models.TreeLRUNet import TreeLRUNet
from utils.util import flatten_tree_batch_for_tree_lru


def create_model(in_features):
    return TreeLRUNet(in_features=in_features)


def prepare_model_batch(encoded_plans):
    return flatten_tree_batch_for_tree_lru(encoded_plans)


def load_model_state(model, model_path, device):
    state = torch.load(model_path, map_location=device)
    model.load_state_dict(state)
    return model
