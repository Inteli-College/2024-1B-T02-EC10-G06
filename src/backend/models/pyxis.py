from pydantic import BaseModel
from bson.objectid import ObjectId

class Pyxis(BaseModel):
    id: ObjectId
    description: str



class PyxisCreate(Pyxis):
    permission: str
