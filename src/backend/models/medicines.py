from pydantic import BaseModel
#from bson.objectid import ObjectId 

class MedicinesBase(BaseModel):
    id: str
    name: str
    description: str

class MedicinesCreate(BaseModel):
    description: str
    name: str

class MedicinesDelete(BaseModel):
    id: str
    status: str




