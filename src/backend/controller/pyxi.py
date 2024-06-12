from bson.objectid import ObjectId
import datetime
import json
from pymongo.collection import Collection
from utils.redis import RedisInterface
from redis.commands.search.field import  TextField

redis_interface = RedisInterface(urls_host="redis_server")
schema = (
    TextField("$.id", as_name="id"),
    TextField("$.descrition", as_name="descrition"),
    TextField("$.medicines[*].id", as_name="medicines_id"),
    TextField("$.medicines[*].name", as_name="medicines_name"),
    TextField("$.medicines[*].descrition", as_name="medicines_descrition"),
    TextField("$.medicines[*].detail", as_name="medicines_detail")
)

redis_interface.index_create("pyxis", schema)


def pyxi_created(producer, raw_pyxi):
    pyxi = {
            "descrition": raw_pyxi.descrition,
            "medicines": raw_pyxi.medicines
            }
    post_id = producer.insert_one(pyxi).inserted_id
    pyxi["id"] = str(post_id)
    data = pyxi
    redis_interface.set_value(f"{str(post_id)}", data)
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
    results = redis_interface.get_value(query=pyxi_id)
    if results.docs.__len__() > 0:
        json_str = results.docs[0].json
        json_obj = json.loads(json_str)
        return json_obj

    if not ObjectId.is_valid(pyxi_id):
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
    
    pyxi = {
        "id":str(pyxi_id),
        "descrition": pyxi_update.descrition,
        "medicines": pyxi_update.medicines,
    }

    data = pyxi
    redis_interface.set_value(f"{str(pyxi_id)}", data)
    pyxi["status"] = "Atualizado com sucesso"
    return pyxi
