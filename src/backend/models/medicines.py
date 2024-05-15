from pydantic import BaseModel
#from bson.objectid import ObjectId 

class MedicinesBase(BaseModel):
    id: str
    name: str
    descrition: str

class MedicinesCreate(BaseModel):
    descrition: str
    name: str

class MedicinesDelete(BaseModel):
    id: str
    status: str




