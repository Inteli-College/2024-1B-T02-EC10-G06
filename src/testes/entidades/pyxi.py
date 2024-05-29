import random

class Pyxi():
    def __init__(self, pyxis):
        self.pyxis = pyxis
        self.pyxis_id = []

    def add_pyxi(self, id):
        if len(self.pyxis_id) < len(self.pyxis):
            self.pyxis_id.append(id) # Lista de IDs dos pyxis_id

    def delete_pyxi(self, id):
        self.pyxis_id.remove(id) # Lista de IDs dos pyxis_id

    def get_random_id(self) -> str:
        end = len(self.pyxis_id) -1
        sort = random.randint(0, end)
        return self.pyxis_id[sort]
    
    def get_random_pyxi(self) -> dict | None:
        end = len(self.pyxis) -1
        if end > 0:
            sort = random.randint(0, end)
            pyxi = self.pyxis[sort]
            self.pyxis.remove(pyxi)
            return pyxi
        return None