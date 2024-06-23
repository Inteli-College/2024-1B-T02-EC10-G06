from pydantic import BaseModel
from datetime import datetime



class TicketBase(BaseModel): 
    id: str
    idPyxis: str
    description: str
    body: list
    created_at: datetime
    fixed_at: str # Trocar por um datetime 
    status: str
    owner_id: str
    operator_id: str 
    

class TicketCreate(BaseModel): 
    idPyxis: str
    description: str
    owner_id: str
    body: list

class TicketUpdateStatus(BaseModel): 
    status: str
    operator_id: str

# class TicketCreateResponse(TicketBase): 
#     update: str
    


class UpdateResposnse(BaseModel): 
    id: str
    status: str


class TicketResponse(BaseModel): 
    msg: str