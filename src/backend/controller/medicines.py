from bson.objectid import ObjectId
from pymongo.collection import Collection


def medicines_created(producer, raw_medicine):
    medicine = {
            "descrition": raw_medicine.descrition,
            "name": raw_medicine.name
            }
    post_id = producer.insert_one(medicine).inserted_id
    medicine["id"] = str(post_id)
    return medicine
    

def all_medicines(db:Collection):
    medicines = []
    for document in db.find():
        #print(document)
        medicines.append({
            "id":str(document["_id"]),
            "descrition": document["descrition"],
            "name": document["name"]
        })
    #print("Toma ae os medicines: ", medicines)
    return medicines
    

def one_medicine(db:Collection, medicine_id):
    raw_medicines = db.find_one( {"_id": ObjectId(medicine_id)} )
    if raw_medicines is None :
        return None
    medicines = {
        "id":str(raw_medicines["_id"]),
        "descrition": raw_medicines["descrition"],
        "name": raw_medicines["name"]
    }
    return medicines

def delete_response(db:Collection, medicine_id):
    db.delete_one({"_id": ObjectId(medicine_id)})
    return {
        "id":medicine_id,
        "status":"Deletado com sucesso"
    }



def update_response(db:Collection, medicine_id, medicine_update):
    db.update_one(
        {"_id": ObjectId(medicine_id)},
        {'$set':{
            "descrition": medicine_update.descrition,
            "name": medicine_update.name
            }
        }
        )
    return {
        "status":"Atualizado com sucesso",
    }
