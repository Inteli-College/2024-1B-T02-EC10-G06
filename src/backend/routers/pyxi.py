from fastapi import APIRouter, HTTPException
from models.pyxi import PyxiBase, PyxiUpdate, PyxiDelete, PyxiCreate
from controller.pyxi import pyxi_created, all_pyxis, one_pyxi, delete_response, update_response
from pymongo import MongoClient
from dotenv import load_dotenv
import os
import logging

load_dotenv()

uri = os.getenv("MONGO_LOCAL_URI")
client = MongoClient(uri)
pyxis_db = client["Hermes"]
collection = pyxis_db["Pyxis"]

router = APIRouter(
    prefix="/pyxis",
    tags=["pyxis"]
)

# Configurar o logger
logging.basicConfig(level=logging.ERROR)
logger = logging.getLogger(__name__)

@router.post("/", response_model=PyxiBase)
async def create_pyxi(pyxi: PyxiCreate):
    try:
        pyxi = await pyxi_created(collection, pyxi)
        if pyxi is None:
            raise HTTPException(status_code=404, detail="Pyxis not found")
        return pyxi
    except HTTPException as http_exc:
        raise http_exc
    except Exception as e:
        logger.error(f"Failed to create pyxi: {e}")
        raise HTTPException(status_code=500, detail="Failed to create pyxi")

@router.get("/", response_model=list[PyxiBase])
async def get_pyxis():
    try:
        pyxis = await all_pyxis(collection)
        return pyxis
    except Exception as e:
        logger.error(f"Failed to get pyxis: {e}")
        raise HTTPException(status_code=500, detail="Failed to get pyxis")

@router.get("/{pyxi_id}", response_model=PyxiBase)
async def get_pyxi(pyxi_id: str):
    try:
        pyxi = await one_pyxi(collection, pyxi_id)
        if pyxi is None:
            raise HTTPException(status_code=404, detail="Pyxis not found")
        return pyxi
    except HTTPException as http_exc:
        raise http_exc
    except Exception as e:
        logger.error(f"Failed to get pyxi {pyxi_id}: {e}")
        raise HTTPException(status_code=500, detail="Failed to get pyxi")

@router.delete("/{pyxi_id}", response_model=PyxiDelete)
async def delete_pyxi(pyxi_id: str):
    try:
        pyxi = await one_pyxi(collection, pyxi_id=pyxi_id)
        if pyxi is None:
            raise HTTPException(status_code=404, detail="Pyxis not found")
        return await delete_response(db=collection, pyxi_id=pyxi_id)
    except HTTPException as http_exc:
        raise http_exc
    except Exception as e:
        logger.error(f"Failed to delete pyxi {pyxi_id}: {e}")
        raise HTTPException(status_code=500, detail="Internal Server Error")

@router.put("/{pyxi_id}", response_model=PyxiUpdate)
async def update_pyxi(pyxi_id: str, pyxi_update: PyxiCreate):
    try:
        pyxi = await one_pyxi(collection, pyxi_id=pyxi_id)
        if pyxi is None:
            raise HTTPException(status_code=404, detail="Pyxis not found")
        return await update_response(db=collection, pyxi_id=pyxi_id, pyxi_update=pyxi_update)
    except HTTPException as http_exc:
        raise http_exc
    except Exception as e:
        logger.error(f"Failed to update pyxi {pyxi_id}: {e}")
        raise HTTPException(status_code=500, detail="Internal Server Error")
