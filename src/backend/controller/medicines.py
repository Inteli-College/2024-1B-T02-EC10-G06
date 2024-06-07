from bson.objectid import ObjectId
from pymongo.collection import Collection


async def medicines_created(producer, raw_medicine):
    medicine = {
            "description": raw_medicine.description,
            "name": raw_medicine.name
            }
    post_id = producer.insert_one(medicine).inserted_id
    medicine["id"] = str(post_id)
    return medicine
    

async def all_medicines(db:Collection):
    medicines = []
    for document in db.find():
        #print(document)
        medicines.append({
            "id":str(document["_id"]),
            "description": document["description"],
            "name": document["name"]
        })
    return medicines
    

async def one_medicine(db:Collection, medicine_id):
    raw_medicines = db.find_one( {"_id": ObjectId(medicine_id)} )
    if raw_medicines is None :
        return None
    medicines = {
        "id":str(raw_medicines["_id"]),
        "description": raw_medicines["description"],
        "name": raw_medicines["name"]
    }
    return medicines

async def delete_response(db:Collection, medicine_id):

    db.delete_one({"_id": ObjectId(medicine_id)})
    return {
        "id":medicine_id,
        "status":"Deletado com sucesso"
    }

async def check_medicines_pyxis(medicine_id, db):
    collection = db["Pyxis"]
    raw_pyxis = collection.find_one({"medicines.id": medicine_id})
    
    if raw_pyxis:
        # Operação de atualização para remover o medicamento
        update = {"$pull": {"medicines": {"id": medicine_id}}}
        
        # Executa a atualização
        result = collection.update_one({"_id": raw_pyxis["_id"]}, update)
        
        if result.modified_count > 0:
            print("Medicamento removido com sucesso.")
        else:
            print("Nenhum documento atualizado. Verifique se o ID do medicamento está correto.")
    
    #print("Pyxis: ", raw_pyxis)
    return True
    


async def update_response(db:Collection, medicine_id, medicine_update):
    db.update_one(
        {"_id": ObjectId(medicine_id)},
        {'$set':{
            "description": medicine_update.description,
            "name": medicine_update.name
            }
        }
        )
    return {
            "id":str(ObjectId(medicine_id)),
            "description": medicine_update.description,
            "name": medicine_update.name
            }
