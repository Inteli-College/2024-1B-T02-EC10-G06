import random
_users = [
    {"username": "ana.silva", "password": "Senha123!"},
    {"username": "bruno.santos", "password": "Senha123!"},
    {"username": "carlos.oliveira", "password": "Senha123!"},
    {"username": "daniela.souza", "password": "Senha123!"},
    {"username": "eduardo.rodrigues", "password": "Senha123!"},
    {"username": "fernanda.ferreira", "password": "Senha123!"},
    {"username": "gabriel.alves", "password": "Senha123!"},
    {"username": "helena.pereira", "password": "Senha123!"},
    {"username": "igor.lima", "password": "Senha123!"},
    {"username": "juliana.gomes", "password": "Senha123!"},
    {"username": "lucas.costa", "password": "Senha123!"},
    {"username": "mariana.ribeiro", "password": "Senha123!"},
    {"username": "nicolas.martins", "password": "Senha123!"},
    {"username": "olivia.carvalho", "password": "Senha123!"},
    {"username": "pedro.almeida", "password": "Senha123!"},
    {"username": "quintino.nascimento", "password": "Senha123!"},
    {"username": "renata.mendes", "password": "Senha123!"},
    {"username": "sofia.barros", "password": "Senha123!"},
    {"username": "thiago.freitas", "password": "Senha123!"},
    {"username": "ursula.cardoso", "password": "Senha123!"},
    {"username": "vinicius.silva", "password": "Senha123!"},
    {"username": "wesley.santos", "password": "Senha123!"},
    {"username": "ximena.oliveira", "password": "Senha123!"},
    {"username": "yuri.souza", "password": "Senha123!"},
    {"username": "zara.rodrigues", "password": "Senha123!"},
    {"username": "ana.ferreira", "password": "Senha123!"},
    {"username": "bruno.alves", "password": "Senha123!"},
    {"username": "carlos.pereira", "password": "Senha123!"},
    {"username": "daniela.lima", "password": "Senha123!"},
    {"username": "eduardo.gomes", "password": "Senha123!"},
    {"username": "fernanda.costa", "password": "Senha123!"},
    {"username": "gabriel.ribeiro", "password": "Senha123!"},
    {"username": "helena.martins", "password": "Senha123!"},
    {"username": "igor.carvalho", "password": "Senha123!"},
    {"username": "juliana.almeida", "password": "Senha123!"},
    {"username": "lucas.nascimento", "password": "Senha123!"},
    {"username": "mariana.mendes", "password": "Senha123!"},
    {"username": "nicolas.barros", "password": "Senha123!"},
    {"username": "olivia.freitas", "password": "Senha123!"},
    {"username": "pedro.cardoso", "password": "Senha123!"},
    {"username": "quintino.silva", "password": "Senha123!"},
    {"username": "renata.santos", "password": "Senha123!"},
    {"username": "sofia.oliveira", "password": "Senha123!"},
    {"username": "thiago.souza", "password": "Senha123!"},
    {"username": "ursula.rodrigues", "password": "Senha123!"},
    {"username": "vinicius.ferreira", "password": "Senha123!"},
    {"username": "wesley.alves", "password": "Senha123!"},
    {"username": "ximena.pereira", "password": "Senha123!"},
    {"username": "yuri.lima", "password": "Senha123!"},
    {"username": "zara.gomes", "password": "Senha123!"}
]



class UserInterface():
    def __init__(self, users:list):
        self.users =  _users | users
        self.users_id = []

    def add_user(self, id):
        if len(self.users_id) < len(self.users):
            self.users_id.append(id) # Lista de IDs dos users_id

    def delete_user(self, id):
        self.users_id.remove(id) # Lista de IDs dos users_id

    def get_random_id(self) -> str:
        end = len(self.users_id) -1
        if end <= 0:
            return None
        sort = random.randint(0, end)
        return self.users_id[sort]
    
    def get_random_user(self) -> dict | None:
        end = len(self.users) -1
        if end > 0:
            sort = random.randint(0, end)
            user = self.users[sort]
            self.users.remove(user)
            return user
        return None