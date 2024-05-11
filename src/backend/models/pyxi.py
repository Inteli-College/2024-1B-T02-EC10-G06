from pydantic import BaseModel


class PyxiBase(BaseModel):
    id: str
    descrition: str
    medicines: dict




class PyxiUpdate(PyxiBase):
    descrition: str
    medicines: dict

class PyxiDelete(PyxiBase):
    id: str

