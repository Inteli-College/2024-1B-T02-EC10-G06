from pydantic import BaseModel
from datetime import datetime
#from bson.objectid import ObjectId 

class Ticket(BaseModel):
    id: str
    idPyxis: str
    descrition: str
    body: dict
    created_at: datetime
    status: str

