from fastapi import APIRouter, HTTPException
from models.medicines import MedicinesBase, MedicinesCreate, MedicinesDelete
from controller.medicines import medicines_created, all_medicines, one_medicine, delete_response, update_response, check_medicines_pyxis
#from utils.redis import redis_interface

from pymongo import MongoClient
from dotenv import load_dotenv
import os

load_dotenv()


# r = redis_interface(urls_host="redis")

# schema = (
#     TextField("$.brand", as_name="brand"),
#     TextField("$.model", as_name="model"),
#     TextField("$.description", as_name="description"),
#     NumericField("$.price", as_name="price"),
#     TagField("$.condition", as_name="condition"),
# )


# r.index_create("bicycle",schema)
# r.index_create("remedios",(
#     TextField("$.brand", as_name="brand"),
#     TextField("$.model", as_name="model"),
#     TextField("$.description", as_name="description"),
#     TextField("$.urgencia", as_name="urgencia"),
# ))

# r.set_values(tag_name="bicycle", values=bicycles)
# r.set_values(tag_name="remedios", values=remedios)

# print("Meus remidios: ",r.get_value( tag_name="",query="@urgencia:media"))


uri = os.getenv("MONGO_LOCAL_URI")
client = MongoClient(uri)

pyxis_db = client["Hermes"]
collection = pyxis_db["Medicines"]

print(f"Conexão estabelecida {client} \n banco criado {pyxis_db} \n collaction criada {collection}")

router = APIRouter(
    prefix="/medicines",
    tags=["medicines"]
)


@router.post("/", response_model=MedicinesBase)
async def create_medicines(medicines: MedicinesCreate):
    medicines = await medicines_created(collection, medicines) # Producer change collection
    return medicines


@router.get("/", response_model=list[MedicinesBase])
async def get_mediciness():

    mediciness = await all_medicines(collection)
    return mediciness

@router.get("/{medicine_id}", response_model=MedicinesBase)
async def get_medicines(medicine_id: str):
    medicines = await one_medicine(collection, medicine_id)
    if medicines is None:
        raise HTTPException(status_code=404, detail="medicines not found")
    return medicines



@router.delete("/{medicine_id}", response_model=MedicinesDelete)
async def delete_medicines(medicine_id: str):
    medicines = await one_medicine(collection, medicine_id=medicine_id)
    if medicines is None:
        raise HTTPException(status_code=404, detail="medicines not found")
    await check_medicines_pyxis(medicine_id=medicine_id, db=pyxis_db)
    return await delete_response(db=collection, medicine_id=medicine_id)



@router.put("/{medicine_id}", response_model=MedicinesBase)
async def update_medicines(medicine_id: str, medicine_update: MedicinesCreate):
    medicines = await one_medicine(collection, medicine_id=medicine_id)
    if medicines is None:
        raise HTTPException(status_code=404, detail="medicines not found")
    return await update_response(db=collection, medicine_id=medicine_id, medicine_update=medicine_update)
