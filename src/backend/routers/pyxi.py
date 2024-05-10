from fastapi import APIRouter, Depends, HTTPException
from models.pyxi import PyxiBase, PyxiUpdate
from controller.pyxi import pyxi_created, all_pyxis, one_pyxi, delete_response, update_response, check_pyxi
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
pyxis_db = client["Hermes"]
collection = pyxis_db["Pyxis"]

router = APIRouter(
    prefix="/pyxis",
    tags=["pyxis"]
)


@router.post("/", response_model=PyxiBase)
def create_pyxi(pyxi: PyxiBase):
    pyxi = pyxi_created(producer, pyxi)
    return pyxi


@router.get("/", response_model=PyxiBase)
def get_pyxis(skip: int = 0, limit: int = 100):
    pyxis = all_pyxis(collection, skip=skip, limit=limit)
    return pyxis

@router.get("/{pyxi_id}", response_model=PyxiBase)
def get_pyxi(skip: int = 0, limit: int = 100):
    pyxi = one_pyxi(collection, skip=skip, limit=limit)
    return pyxi



@router.delete("/{pyxi_id}")
def delete_pyxi(pyxi_id: str):
    pyxi = check_pyxi(collection, pyxi_id=pyxi_id)
    if pyxi is None:
        raise HTTPException(status_code=404, detail="Pyxis not found")
    return delete_response(db=collection, pyxi_id=pyxi_id)



@router.put("/{pyxi_id}", response_model=PyxiUpdate)
def update_pyxi(pyxi_id: str, pyxi_update: PyxiUpdate):
    pyxi = check_pyxi(collection, pyxi_id=pyxi_id)
    if pyxi is None:
        raise HTTPException(status_code=404, detail="Pyxis not found")
    return update_response(db=collection, pyxi_id=pyxi_id, pyxi_update=pyxi_update)
