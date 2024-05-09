from pydantic import BaseModel
from bson.objectid import ObjectId

class Medicines(BaseModel):
    id : ObjectId
    name: str
    password: str


class MedicinesCreate(Medicines):
    permission: str
