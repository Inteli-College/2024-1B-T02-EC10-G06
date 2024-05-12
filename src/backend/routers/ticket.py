from fastapi import APIRouter, HTTPException
from models.ticket import TicketBase, TicketCreate, TicketCreateResponse
from controller.tickets import ticket_created #, all_tickets, one_ticket, delete_response, update_response


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
tickets_db = client["Hermes"]
collection = tickets_db["Tickets"]

router = APIRouter(
    prefix="/tickets",
    tags=["tickets"]
)


@router.post("/", response_model=TicketCreateResponse)
def create_ticket(ticket: TicketCreate):
    ticket = ticket_created(producer,collection, ticket) # Producer change Collection
    return ticket


# @router.get("/", response_model=list[ticketBase])
# def get_tickets():
#     tickets = all_tickets(collection)
#     return tickets

# @router.get("/{ticket_id}", response_model=TicketBase)
# def get_ticket(ticket_id: str):
#     ticket = one_ticket(collection, ticket_id)
#     if ticket is None:
#         raise HTTPException(status_code=404, detail="tickets not found")
#     return ticket



# @router.delete("/{ticket_id}", response_model=ticketDelete)
# def delete_ticket(ticket_id: str):
#     ticket = one_ticket(collection, ticket_id=ticket_id)
#     if ticket is None:
#         raise HTTPException(status_code=404, detail="tickets not found")
#     return delete_response(db=collection, ticket_id=ticket_id)



# @router.put("/{ticket_id}", response_model=ticketUpdate)
# def update_ticket(ticket_id: str, ticket_update: ticketCreate):
#     ticket = one_ticket(collection, ticket_id=ticket_id)
#     if ticket is None:
#         raise HTTPException(status_code=404, detail="tickets not found")
#     return update_response(db=collection, ticket_id=ticket_id, ticket_update=ticket_update)
