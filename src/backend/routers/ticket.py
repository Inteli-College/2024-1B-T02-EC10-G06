from fastapi import APIRouter, HTTPException
from models.ticket import TicketBase, TicketCreate, TicketResponse, TicketUpdateStatus, UpdateResposnse
from controller.tickets import ticket_created , all_tickets, one_ticket, delete_response, update_response, update_status
from pymongo import MongoClient
from dotenv import load_dotenv
import os

load_dotenv()

uri = os.getenv("MONGO_LOCAL_URI")
client = MongoClient(uri)
client_id = "python-producer"



tickets_db = client["Hermes"]
collection = tickets_db["Tickets"]

router = APIRouter(
    prefix="/tickets",
    tags=["tickets"]
)


@router.post("/", response_model=TicketResponse)
def create_ticket(ticket: TicketCreate):
    ticket = ticket_created(collection, ticket) # Producer change Collection
    return ticket


@router.get("/", response_model=list[TicketBase])
def get_tickets():
    tickets = all_tickets(collection)
    return tickets

@router.get("/{ticket_id}", response_model=TicketBase)
def get_ticket(ticket_id: str):
    ticket = one_ticket(collection, ticket_id)
    if ticket is None:
        raise HTTPException(status_code=404, detail="tickets not found")
    return ticket



@router.delete("/{ticket_id}", response_model=TicketResponse)
def delete_ticket(ticket_id: str):
    ticket = one_ticket(collection, ticket_id=ticket_id)
    if ticket is None:
        raise HTTPException(status_code=404, detail="tickets not found")
    return delete_response(db=collection, ticket_id=ticket_id)


@router.put("/{ticket_id}/status", response_model=UpdateResposnse)
def update_ticket(ticket_id: str, ticket_update: TicketUpdateStatus):
    ticket = one_ticket(collection, ticket_id=ticket_id)
    if ticket is None:
        raise HTTPException(status_code=404, detail="tickets not found")
    return update_status(db=collection, ticket_id=ticket_id, status=ticket_update.status, operator_id=ticket_update.operator_id)
