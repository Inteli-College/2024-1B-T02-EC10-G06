from pydantic import BaseModel
from .medicines import Medicines
from typing import List
import datetime
from bson.objectid import ObjectId

class Tickts(BaseModel):
    idPyxis: ObjectId
    body: List[Medicines] = []
    description: str
    status: str
    created_at: datetime.datetime

class TicktsCreate(Tickts):
    permission: str
