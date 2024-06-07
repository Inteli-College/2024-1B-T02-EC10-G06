from pydantic import BaseModel
#from bson.objectid import ObjectId 


class PyxiBase(BaseModel):
    id: str
    description: str
    medicines: list




class PyxiCreate(BaseModel):
    description: str
    medicines: list

class PyxiUpdate(PyxiBase):
    status:str


class PyxiDelete(BaseModel):
    id: str
    status: str

