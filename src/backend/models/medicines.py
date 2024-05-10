from pydantic import BaseModel


class MedicinesBase(BaseModel):
    id: str
    nome: str
    descrition: str

class MedicinesCreate(BaseModel):
    descrition: str
    nome: str


class MedicinesUpdate(MedicinesBase):
    pass

