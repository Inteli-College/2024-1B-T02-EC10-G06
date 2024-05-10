from pydantic import BaseModel
from datetime import datetime

class Ticket(BaseModel):
    idLote: str
    idPyxis: str
    descrition: str
    body: dict
    created_at: datetime
    status: str

