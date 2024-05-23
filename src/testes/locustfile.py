import time
from locust import HttpUser, task, between

class ApiUser(HttpUser):
    wait_time = between(1, 5)

    @task(2)
    def get_pyxis(self):
        self.client.get("/pyxis/")

    @task(1)
    def create_pyxi(self):
        self.client.post("/pyxis/", json={
            "descrition": "Sample description",
            "medicines": {}
        })

    @task(2)
    def get_pyxi_by_id(self):
        pyxi_id = "some-pyxi-id"  # replace with a valid pyxi_id or generate dynamically
        self.client.get(f"/pyxis/{pyxi_id}")

    @task(1)
    def update_pyxi(self):
        pyxi_id = "some-pyxi-id"  # replace with a valid pyxi_id or generate dynamically
        self.client.put(f"/pyxis/{pyxi_id}", json={
            "descrition": "Updated description",
            "medicines": {}
        })

    @task(1)
    def delete_pyxi(self):
        pyxi_id = "some-pyxi-id"  # replace with a valid pyxi_id or generate dynamically
        self.client.delete(f"/pyxis/{pyxi_id}")

    @task(2)
    def get_medicines(self):
        self.client.get("/medicines/")

    @task(1)
    def create_medicine(self):
        self.client.post("/medicines/", json={
            "name": "Sample Medicine",
            "descrition": "Sample description"
        })

    @task(2)
    def get_medicine_by_id(self):
        medicine_id = "some-medicine-id"  # replace with a valid medicine_id or generate dynamically
        self.client.get(f"/medicines/{medicine_id}")

    @task(1)
    def update_medicine(self):
        medicine_id = "some-medicine-id"  # replace with a valid medicine_id or generate dynamically
        self.client.put(f"/medicines/{medicine_id}", json={
            "name": "Updated Medicine",
            "descrition": "Updated description"
        })

    @task(1)
    def delete_medicine(self):
        medicine_id = "some-medicine-id"  # replace with a valid medicine_id or generate dynamically
        self.client.delete(f"/medicines/{medicine_id}")

    @task(2)
    def get_tickets(self):
        self.client.get("/tickets/")

    @task(1)
    def create_ticket(self):
        self.client.post("/tickets/", json={
            "idPyxis": "sample-pyxis-id",
            "descrition": "Sample ticket description",
            "body": []
        })

    @task(2)
    def get_ticket_by_id(self):
        ticket_id = "some-ticket-id"  # replace with a valid ticket_id or generate dynamically
        self.client.get(f"/tickets/{ticket_id}")

    @task(1)
    def update_ticket(self):
        ticket_id = "some-ticket-id"  # replace with a valid ticket_id or generate dynamically
        self.client.put(f"/tickets/{ticket_id}", json={
            "idPyxis": "sample-pyxis-id",
            "descrition": "Updated ticket description",
            "body": []
        })

    @task(1)
    def delete_ticket(self):
        ticket_id = "some-ticket-id"  # replace with a valid ticket_id or generate dynamically
        self.client.delete(f"/tickets/{ticket_id}")

    @task
    def read_root(self):
        self.client.get("/")

    def on_start(self):
        # If the API requires login, add login logic here
        pass
