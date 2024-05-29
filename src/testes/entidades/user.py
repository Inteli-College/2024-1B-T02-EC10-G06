import random
_users = [
    {"username": "ana.silva@mail.com", "password": "Senha123!"},
    {"username": "bruno.santos@mail.com", "password": "Senha123!"},
    {"username": "carlos.oliveira@mail.com", "password": "Senha123!"},
    {"username": "daniela.souza@mail.com", "password": "Senha123!"},
    {"username": "eduardo.rodrigues@mail.com", "password": "Senha123!"},
    {"username": "fernanda.ferreira@mail.com", "password": "Senha123!"},
    {"username": "gabriel.alves@mail.com", "password": "Senha123!"},
    {"username": "helena.pereira@mail.com", "password": "Senha123!"},
    {"username": "igor.lima@mail.com", "password": "Senha123!"},
    {"username": "juliana.gomes@mail.com", "password": "Senha123!"},
    {"username": "lucas.costa@mail.com", "password": "Senha123!"},
    {"username": "mariana.ribeiro@mail.com", "password": "Senha123!"},
    {"username": "nicolas.martins@mail.com", "password": "Senha123!"},
    {"username": "olivia.carvalho@mail.com", "password": "Senha123!"},
    {"username": "pedro.almeida@mail.com", "password": "Senha123!"},
    {"username": "quintino.nascimento@mail.com", "password": "Senha123!"},
    {"username": "renata.mendes@mail.com", "password": "Senha123!"},
    {"username": "sofia.barros@mail.com", "password": "Senha123!"},
    {"username": "thiago.freitas@mail.com", "password": "Senha123!"},
    {"username": "ursula.cardoso@mail.com", "password": "Senha123!"},
    {"username": "vinicius.silva@mail.com", "password": "Senha123!"},
    {"username": "wesley.santos@mail.com", "password": "Senha123!"},
    {"username": "ximena.oliveira@mail.com", "password": "Senha123!"},
    {"username": "yuri.souza@mail.com", "password": "Senha123!"},
    {"username": "zara.rodrigues@mail.com", "password": "Senha123!"},
    {"username": "ana.ferreira@mail.com", "password": "Senha123!"},
    {"username": "bruno.alves@mail.com", "password": "Senha123!"},
    {"username": "carlos.pereira@mail.com", "password": "Senha123!"},
    {"username": "daniela.lima@mail.com", "password": "Senha123!"},
    {"username": "eduardo.gomes@mail.com", "password": "Senha123!"},
    {"username": "fernanda.costa@mail.com", "password": "Senha123!"},
    {"username": "gabriel.ribeiro@mail.com", "password": "Senha123!"},
    {"username": "helena.martins@mail.com", "password": "Senha123!"},
    {"username": "igor.carvalho@mail.com", "password": "Senha123!"},
    {"username": "juliana.almeida@mail.com", "password": "Senha123!"},
    {"username": "lucas.nascimento@mail.com", "password": "Senha123!"},
    {"username": "mariana.mendes@mail.com", "password": "Senha123!"},
    {"username": "nicolas.barros@mail.com", "password": "Senha123!"},
    {"username": "olivia.freitas@mail.com", "password": "Senha123!"},
    {"username": "pedro.cardoso@mail.com", "password": "Senha123!"},
    {"username": "quintino.silva@mail.com", "password": "Senha123!"},
    {"username": "renata.santos@mail.com", "password": "Senha123!"},
    {"username": "sofia.oliveira@mail.com", "password": "Senha123!"},
    {"username": "thiago.souza@mail.com", "password": "Senha123!"},
    {"username": "ursula.rodrigues@mail.com", "password": "Senha123!"},
    {"username": "vinicius.ferreira@mail.com", "password": "Senha123!"},
    {"username": "wesley.alves@mail.com", "password": "Senha123!"},
    {"username": "ximena.pereira@mail.com", "password": "Senha123!"},
    {"username": "yuri.lima@mail.com", "password": "Senha123!"},
    {"username": "zara.gomes@mail.com", "password": "Senha123!"}
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