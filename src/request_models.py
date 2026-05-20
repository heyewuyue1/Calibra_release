from pydantic import BaseModel
from typing import List, Dict, Optional

class QueryStageInfo(BaseModel):
    materialized: bool  # materialized or not
    card: int           # true/estimated cardinality
    size: int           # true/estimated size in bytes
    stagePlan: str      # physical plan

class PlanInfo(BaseModel):
    plan: str                               
    queryStages: Dict[str, QueryStageInfo]  # key=stage name
    card: int                               # estimated cardinality
    size: int                               # estimated size in bytes

class CostRequest(BaseModel):
    type: int                   # 0-logical plan, 1-physical plan, 2-partially executed plan
    candidates: List[PlanInfo]  # list of candidate
    advisoryChoose: int         # index of Spark SQL's choose
    decisionKind: Optional[str] = None  # pairwise, listwise, or scalar
    selectK: Optional[int] = None       # number of candidates selected by listwise decisions

class RegisterRequest(BaseModel):
    sessionName: str
    finalPlan: str      # physical
    executionTime: int  # in nano seconds

class CostResponse(BaseModel):
    costs: List[float]  # list of the costs of the candidates


def plan_info_to_dict(plan_info):
    if hasattr(plan_info, "model_dump"):
        plan_info_dict = plan_info.model_dump()
    else:
        plan_info_dict = dict(plan_info)

    query_stages = plan_info_dict.get("queryStages") or {}
    plan_info_dict["queryStages"] = {
        key: value.model_dump() if hasattr(value, "model_dump") else value
        for key, value in query_stages.items()
    }
    return plan_info_dict
