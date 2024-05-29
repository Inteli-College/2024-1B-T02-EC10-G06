import random


class Ticket():
    def __init__(self):
        self.tickets = [

        ]

    def add_ticket(self, ticket):
        self.tickets.append(ticket) # Lista de IDs dos tickets

    def delete_ticket(self, ticket):
        self.tickets.remove(ticket) # Lista de IDs dos tickets

    def get_random_id(self) -> str:
        end = len(self.tickets) -1
        sort = random.randint(0, end)
        return self.tickets[sort]
    
