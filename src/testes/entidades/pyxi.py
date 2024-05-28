import random

class Pyxi():
    def __init__(self):
        self.pyxis = [
            
        ]
    
    def add_pyxi(self, pyxi):
        self.pyxis.append(pyxi) # Lista de IDs dos Pyxis

    def delete_pyxi(self, pyxi):
        self.pyxis.remove(pyxi) # Lista de IDs dos Pyxis

    def get_random_id(self) -> str:
        end = len(self.pyxis) -1
        if end > 0:
            sort = random.randint(0, end)
        else:
            return "Empty"
        return self.pyxis[sort]