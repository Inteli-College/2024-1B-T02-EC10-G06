from pydantic import BaseModel
#from bson.objectid import ObjectId 

class MedicinesBase(BaseModel):
    id: str
    nome: str
    descrition: str

class MedicinesCreate(BaseModel):
    descrition: str
    nome: str


class MedicinesUpdate(MedicinesBase):
    pass

