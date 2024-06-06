import random


class Medicine():
    def __init__(self, medicines):
        self.medicines = medicines
        self.to_create = medicines
        self.medicines_id = []

    def add_medicine(self, id):
        if len(self.medicines_id) < len(self.medicines):
            self.medicines_id.append(id) # Lista de IDs dos medicines_id

    def add_to_create(self, medicine):
        self.to_create.append(medicine)

    def delete_medicine(self, id):
        self.medicines_id.remove(id) # Lista de IDs dos medicines_id

    def get_random_id(self) -> str:
        end = len(self.medicines_id) -1
        sort = random.randint(0, end)
        return self.medicines_id[sort]
    
    def get_random_to_create(self) -> dict | None:
        end = len(self.to_create) -1
        if end > 0:
            sort = random.randint(0, end)
            medicine = self.to_create[sort]
            self.to_create.remove(medicine)
            return medicine
        return None
    
    def get_random_medicine(self) -> dict | None:
        end = len(self.medicines) -1
        if end > 0:
            sort = random.randint(0, end)
            medicine = self.medicines[sort]
            return medicine
        return None