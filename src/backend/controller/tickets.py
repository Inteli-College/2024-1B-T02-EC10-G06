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
            "created_at": datetime.utcnow(),
            "status": "on progress",
            }

    producer.produce("ticket", json.dumps(ticket, indent = 4, sort_keys=True, default=str) )
    producer.flush()
    ticket["update"] = "Adicinado a fila"
    return ticket
    

# def all_tickets(db:Collection):
#     tickets = []
#     for document in db.find():
#         #print(document)
#         tickets.append({
#             "id":str(document["_id"]),
#             "descrition": document["descrition"],
#             "medicines": document["medicines"]
#         })
#     #print("Toma ae os tickets: ", tickets)
#     return tickets
    

# def one_ticket(db:Collection, ticket_id):
#     raw_tickets = db.find_one( {"_id": ObjectId(ticket_id)} )
#     if raw_tickets is None :
#         return None
#     tickets = {
#         "id":str(raw_tickets["_id"]),
#         "descrition": raw_tickets["descrition"],
#         "medicines": raw_tickets["medicines"]
#     }
#     return tickets

# def delete_response(db:Collection, ticket_id):
#     db.delete_one({"_id": ObjectId(ticket_id)})
#     return {
#         "id":ticket_id,
#         "status":"Deletado com sucesso"
#     }



# def update_response(db:Collection, ticket_id, ticket_update):
#     db.update_one(
#         {"_id": ObjectId(ticket_id)},
#         {'$set':{
#             "descrition": ticket_update.descrition,
#             "medicines": ticket_update.medicines
#             }
#         }
#         )
#     return {
#         "status":"Atualizado com sucesso",
#     }
