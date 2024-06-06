from pydantic import BaseModel
from datetime import datetime



class TicketBase(BaseModel): 
    id: str
    idPyxis: str
    descrition: str
    body: list
    created_at: datetime
    fixed_at: datetime
    status: str
    owner_id: str
    operator_id: str
    

class TicketCreate(BaseModel): 
    idPyxis: str
    descrition: str
    owner_id: str
    body: list

# class TicketCreateResponse(TicketBase): 
#     update: str
    

class TicketResponse(BaseModel): 
    msg: str