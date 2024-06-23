from bson.objectid import ObjectId
from datetime import datetime
from pymongo.collection import Collection
from utils.publisher import Publisher
import json


producer = Publisher("bridge",5672)

producer.exchangeDeclare("ticket")

producer.queueDeclare("ticket_queue")

def ticket_created(db, raw_ticket):
    ticket = {
            "idPyxis": raw_ticket.idPyxis,
            "description": raw_ticket.description,
            "body":  raw_ticket.body,
            "created_at": datetime.now(),
            "fixed_at":'None',
            "operator_id":'None',
            "status": "open",
            "owner_id":raw_ticket.owner_id
            }

    # val = producer.produce("ticket", json.dumps(ticket, indent = 4, sort_keys=True, default=str) )
    # producer.flush()
    producer.send(json.dumps(ticket, indent = 4, sort_keys=True, default=str), "ticket", "ticket_queue")
    #db.insert_one(ticket)
    return {"msg":f"ticket sent to queue: {ticket}"}
    

def all_tickets(db:Collection):
    tickets = []
    for document in db.find():
        #print(document)
        tickets.append({
            "id":str(document["_id"]),
            "idPyxis": str(document["idPyxis"]),
            "description": document["description"],
            "body": document["body"],
            "fixed_at": document["fixed_at"],
            "created_at": document["created_at"],
            "status": document["status"],
            "owner_id": document["owner_id"],
            "operator_id": document["operator_id"]
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
            "description": raw_tickets["description"],
            "body": raw_tickets["body"],
            "fixed_at": raw_tickets["fixed_at"],
            "created_at": raw_tickets["created_at"],
            "status": raw_tickets["status"],
            "owner_id": raw_tickets["owner_id"],
            "operator_id": raw_tickets["operator_id"]
    }
    return tickets

def delete_response(db:Collection, ticket_id):
    db.delete_one({"_id": ObjectId(ticket_id)})
    return {
        "msg": str(ticket_id)
    }



def update_response(db:Collection, ticket_id, ticket_update):
    db.update_one(
        {"_id": ObjectId(ticket_id)},
        {'$set':{
            "idPyxis": ticket_update.idPyxis,
            "description": ticket_update.description,
            "body": ticket_update.body
            }
        }
        )
    return { 
        "msg": str(ticket_id)
    }

def update_status(db:Collection, ticket_id, status, operator_id):
    if status == "closed":
        db.update_one(
            {"_id": ObjectId(ticket_id)},
            {'$set':{
                "fixed_at": str(datetime.now()),
                "operator_id": operator_id,
                "status": status
                }
            }
            )
    db.update_one(
        {"_id": ObjectId(ticket_id)},
        {'$set':{
            "operator_id": operator_id,
            "status": status
            }
        }
        )
    return { 
        "id": str(ticket_id),
        "status": status
    }