from locust import HttpUser, TaskSet, task, between

class NurseUser(TaskSet):

    @task
    def createTicket(self):
        self.client.get("/")

    @task
    def loadPyxis(self):
        self.client.get("/about")

class TechnicianUser(TaskSet):

    @task
    def index(self):
        self.client.get("/")

    @task
    def about(self):
        self.client.get("/about")

class AdmUser(TaskSet):
    @task
    def get_ticket(self):
        self.client.get("/tickets/66412b3d06abdc490d181c39")

    @task
    def update_ticket(self):
        self.client.put("/tickets/66412b3d06abdc490d181c39", json={
            "idPyxis": "str",
            "descrition": "Teste para ver se da fila foi para o banco de dados",
            "body": []
        })

    @task
    def delete_ticket(self):
        self.client.delete("/tickets/66412b3d06abdc490d181c39")

    @task
    def create_ticket(self):
        self.client.post("/tickets/", json={
            "idPyxis": "66412b3d06abdc490d181c39",
            "descrition": "Teste para ver se da fila foi para o banco de dados",
            "body": [
                {
                    "id": "6640fd1acdf84fa31ebf3ede",
                    "name": "oi",
                    "descrition": "Vamos ver se foi mesmo"
                },
                {
                    "id": "6640fd21cdf84fa31ebf3ee0",
                    "name": "oi",
                    "descrition": "Vamos ver se foi mesmo"
                }
            ]
        })

    @task
    def get_tickets(self):
        self.client.get("/tickets/")

    @task
    def get_medicines(self):
        self.client.get("/medicines/")

    @task
    def get_pyxis(self):
        self.client.get("/pyxis/")

    @task
    def create_medicine(self):
        self.client.post("/medicines/", json={
            "descrition": "str",
            "name": "str"
        })

    @task
    def create_pyxis(self):
        self.client.post("/pyxis/", json={
            "descrition": "str",
            "medicines": []
        })

    @task
    def get_medicine(self):
        self.client.get("/medicines/6655caaff4239b3812f9145b")

    @task
    def get_specific_pyxi(self):
        self.client.get("/pyxis/6655caf6f4239b3812f9145c")

    @task
    def update_medicine(self):
        self.client.put("/medicines/6655caaff4239b3812f9145b", json={
            "descrition": "str",
            "name": "Será?"
        })

    @task
    def delete_medicine(self):
        self.client.delete("/medicines/6655ca95f4239b3812f9145a")

    @task
    def update_pyxi(self):
        self.client.put("/pyxis/6655cbc1f4239b3812f9145d", json={
            "descrition": "str",
            "medicines": []
        })

    @task
    def delete_pyxi(self):
        self.client.delete("/pyxis/6655caf6f4239b3812f9145c")




class WebsiteUser(HttpUser):
    tasks = [NurseUser, AdmUser, TechnicianUser]
    wait_time = between(1, 5)
