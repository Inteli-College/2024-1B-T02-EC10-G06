from fastapi import APIRouter, Depends, HTTPException
from models.pyxi import PyxiBase, PyxiUpdate  
from datetime import datetime

from utils.kafka import ProducerController
from pymongo import MongoClient
from dotenv import load_dotenv
import os

load_dotenv()

uri = os.getenv("MONGO_URI")
client = MongoClient(uri)
server = os.getenv("KAFKA_BROKER")
client_id = "python-producer"
apikey = os.getenv("KAFKA_APIKEY")
password = os.getenv("KAFKA_PASSWORD")
producer = ProducerController(server,client_id,apikey,password)


router = APIRouter(
    prefix="/pyxis",
    tags=["pyxis"]
)


@router.post("/", response_model=PyxiBase)
def create_pyxi(skip: int = 0, limit: int = 100, producer: ProducerController = Depends(producer)):
    pyxi = pyxi_created(producer, skip=skip, limit=limit)
    return pyxi


@router.get("/", response_model=PyxiBase)
def get_pyxis(skip: int = 0, limit: int = 100, db: MongoClient = Depends(client)):
    pyxis = all_pyxis(db, skip=skip, limit=limit)
    return pyxis

@router.get("/{pyxi_id}", response_model=PyxiBase)
def get_pyxi(skip: int = 0, limit: int = 100, db: MongoClient = Depends(client)):
    pyxi = one_pyxi(db, skip=skip, limit=limit)
    return pyxi



@router.delete("/{pyxi_id}")
def delete_pyxi(pyxi_id: str, db: MongoClient = Depends(client)):
    pyxi = get_pyxi(db, pyxi_id=pyxi_id)
    if pyxi is None:
        raise HTTPException(status_code=404, detail="Pyxis not found")
    return delete_pyxi(db=db, pyxi_id=pyxi_id)



@router.put("/{pyxi_id}", response_model=PyxiUpdate)
def update_pyxi(pyxi_id: str, pyxi_update: PyxiUpdate, db: MongoClient = Depends(client)):
    pyxi = get_pyxi(db, pyxi_id=pyxi_id)
    if pyxi is None:
        raise HTTPException(status_code=404, detail="Pyxis not found")
    return update_pyxi(db=db, pyxi_id=pyxi_id, pyxi_update=pyxi_update)
