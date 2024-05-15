from pydantic import BaseModel
#from bson.objectid import ObjectId 


class PyxiBase(BaseModel):
    id: str
    descrition: str
    medicines: dict




class PyxiCreate(BaseModel):
    descrition: str
    medicines: dict

class PyxiUpdate(BaseModel):
    status:str


class PyxiDelete(BaseModel):
    id: str
    status: str

