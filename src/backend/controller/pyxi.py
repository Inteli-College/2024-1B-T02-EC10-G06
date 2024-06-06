from bson.objectid import ObjectId
import datetime
from pymongo.collection import Collection


def pyxi_created(producer, raw_pyxi):
    pyxi = {
            "descrition": raw_pyxi.descrition,
            "medicines": raw_pyxi.medicines
            }
    post_id = producer.insert_one(pyxi).inserted_id
    pyxi["id"] = str(post_id)
    return pyxi
    

def all_pyxis(db:Collection):
    pyxis = []
    for document in db.find():
        
        pyxis.append({
            "id":str(document["_id"]),
            "descrition": document["descrition"],
            "medicines": document["medicines"]
        })
    
    return pyxis
    

def one_pyxi(db:Collection, pyxi_id):
    if not ObjectId.is_valid(pyxi_id): # Verifica se o id é válido
        return None
    raw_pyxis = db.find_one( {"_id": ObjectId(pyxi_id)} )
    if raw_pyxis is None :
        return None
    pyxis = {
        "id":str(raw_pyxis["_id"]),
        "descrition": raw_pyxis["descrition"],
        "medicines": raw_pyxis["medicines"]
    }
    return pyxis

def delete_response(db:Collection, pyxi_id):
    db.delete_one({"_id": ObjectId(pyxi_id)})
    return {
        "id":pyxi_id,
        "status":"Deletado com sucesso"
    }



def update_response(db:Collection, pyxi_id, pyxi_update):
    db.update_one(
        {"_id": ObjectId(pyxi_id)},
        {'$set':{
            "descrition": pyxi_update.descrition,
            "medicines": pyxi_update.medicines
            }
        }
        )
    return {
        "id":str(pyxi_id),
        "descrition": pyxi_update.descrition,
        "medicines": pyxi_update.medicines,
        "status":"Atualizado com sucesso",
    }
