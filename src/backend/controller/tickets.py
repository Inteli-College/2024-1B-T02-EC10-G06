from bson.objectid import ObjectId
from datetime import datetime
from pymongo.collection import Collection
import json 
from utils.kafka import ProducerController



def ticket_created(producer:ProducerController, db, raw_ticket):
    ticket = {
            "idPyxis": raw_ticket.idPyxis,
            "descrition": raw_ticket.descrition,
            "body":  raw_ticket.body,
<<<<<<< HEAD
            "created_at": datetime.utcnow(),
            "status": "on progress",
            }

    producer.produce("ticket", json.dumps(ticket, indent = 4, sort_keys=True, default=str) )
=======
            "created_at": datetime.now(),
            "status": "on progress",
            }

    producer.produceWithoutAuth("ticket", json.dumps(ticket, indent = 4, sort_keys=True, default=str) )
>>>>>>> backend
    producer.flush()
    ticket["update"] = "Adicinado a fila"
    return ticket
    

def all_tickets(db:Collection):
    tickets = []
    for document in db.find():
        #print(document)
        tickets.append({
            "id":str(document["_id"]),
            "idPyxis": str(document["idPyxis"]),
            "descrition": document["descrition"],
            "body": document["body"],
            "created_at": document["created_at"],
            "status": document["status"],
        })
   # print("Toma ae os tickets: ", tickets)
    return tickets
    

def one_ticket(db:Collection, ticket_id):
    raw_tickets = db.find_one( {"_id": ObjectId(ticket_id)} )
    if raw_tickets is None :
        return None
    tickets = {
            "id":str(raw_tickets["_id"]),
            "idPyxis": str(raw_tickets["idPyxis"]),
            "descrition": raw_tickets["descrition"],
            "body": raw_tickets["body"],
            "created_at": raw_tickets["created_at"],
            "status": raw_tickets["status"],
    }
    return tickets

def delete_response(db:Collection, ticket_id):
    db.delete_one({"_id": ObjectId(ticket_id)})
    return {"msg":{
        "id":ticket_id,
        "status":"Deletado com sucesso"
    }}



def update_response(db:Collection, ticket_id, ticket_update):
    db.update_one(
        {"_id": ObjectId(ticket_id)},
        {'$set':{
            "idPyxis": ticket_update.idPyxis,
            "descrition": ticket_update.descrition,
            "body": ticket_update.body
            }
        }
        )
    return { "msg": {
            "id":ticket_id,
            "idPyxis": ticket_update.idPyxis,
            "descrition": ticket_update.descrition,
            "body": ticket_update.body,
            "status":"Atualizado com sucesso"
    }}