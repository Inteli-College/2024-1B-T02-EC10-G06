import random
problems = [
    {"description": "Falha na conexão com o servidor, impedindo o acesso ao Paracetamol"},
    {"description": "Erro no software de dispensação ao tentar acessar a Amoxicilina"},
    {"description": "Problemas de calibração do dispositivo, causando dosagem incorreta de Ibuprofeno"},
    {"description": "Amoxicilina fora de estoque não sinalizada, levando a atrasos no tratamento de infecções"},
    {"description": "Acesso não autorizado detectado ao compartimento de Fluoxetina"},
    {"description": "Porta do compartimento de Dipirona travada, impedindo a administração de antipirético"},
    {"description": "Tempo de resposta lento do sistema ao tentar dispensar Loratadina"},
    {"description": "Falha na impressão de etiquetas para Salbutamol"},
    {"description": "Erro na leitura de códigos de barras de Carbamazepina"},
    {"description": "Falha na integração com o sistema de prontuário eletrônico, resultando em administração incorreta de Varfarina"},
    {"description": "Atualizações de software pendentes, afetando a dispensação de Losartana"},
    {"description": "Problemas de alimentação elétrica interrompendo o acesso à Metformina"},
    {"description": "Dados de inventário incorretos, mostrando estoque falso de Oseltamivir"},
    {"description": "Falha na abertura do compartimento de Fluconazol"},
    {"description": "Problemas de login do usuário ao tentar acessar Omeprazol"},
    {"description": "Falha no backup de dados, resultando na perda de registros de Risperidona"},
    {"description": "Perda de comunicação entre módulos, impedindo a dispensação de Prednisona"},
    {"description": "Erro de configuração de permissões, permitindo acesso inadequado à Cloroquina"},
    {"description": "Falha na sincronização de horários, resultando em registros errados de Albendazol"},
    {"description": "Alerta de manutenção pendente, afetando a operação da Furosemida"},
    {"description": "Problemas de conectividade ao acessar Ipratrópio"},
    {"description": "Erro no sistema ao dispensar Diazepam"},
    {"description": "Falha na atualização dos dados de Fenitoína"},
    {"description": "Estoque incorreto de Atorvastatina devido a falha no sistema"},
    {"description": "Problemas de acesso ao compartimento de Sibutramina"},
    {"description": "Erro ao tentar registrar a dispensação de Levotiroxina"},
    {"description": "Falha na comunicação entre sistemas, afetando a dispensação de Esomeprazol"},
    {"description": "Problemas no módulo de controle de acesso ao Etinilestradiol"},
    {"description": "Falha no sistema ao tentar dispensar Metilfenidato"},
    {"description": "Erro ao atualizar o inventário de Ondansetrona"},
    {"description": "Falha na impressão de etiquetas para Propranolol"},
    {"description": "Erro na dispensação de Enalapril devido a falha no software"},
    {"description": "Problemas de inventário incorreto de Colecalciferol"},
    {"description": "Erro no sistema ao tentar dispensar Celecoxib"},
    {"description": "Falha na sincronização de horários ao acessar Ciclosporina"},
    {"description": "Problemas no módulo de controle de acesso à Quetiapina"},
    {"description": "Erro no sistema ao tentar dispensar Loperamida"},
    {"description": "Falha na atualização dos dados de Guaifenesina"},
    {"description": "Problemas de conectividade ao acessar Pseudoefedrina"},
    {"description": "Erro ao tentar registrar a dispensação de Metronidazol"},
    {"description": "Falha no sistema ao tentar dispensar Dextrometorfano"},
    {"description": "Problemas no módulo de controle de acesso à Cafeína"},
    {"description": "Erro ao tentar registrar a dispensação de Timolol"},
    {"description": "Falha na sincronização de horários ao acessar Aciclovir"},
    {"description": "Problemas no módulo de controle de acesso à Valsartana"},
    {"description": "Erro no sistema ao tentar dispensar Lítio"},
    {"description": "Falha na atualização dos dados de Medroxiprogesterona"},
    {"description": "Problemas de conectividade ao acessar Topiramato"},
    {"description": "Erro ao tentar registrar a dispensação de Lidocaína"},
    {"description": "Falha no sistema ao tentar dispensar Ciclobenzaprina"},
    {"description": "Problemas no módulo de controle de acesso ao Ácido Tranexâmico"}
]


class Ticket():
    def __init__(self):
        self.tickets_id = []

    def add_ticket(self, id):
        if len(self.tickets_id) < len(self.tickets):
            self.tickets_id.append(id) # Lista de IDs dos tickets_id

    def add_to_create(self, ticket):
        self.to_create.append(ticket)

    def delete_ticket(self, id):
        self.tickets_id.remove(id) # Lista de IDs dos tickets_id

    def get_random_id(self) -> str:
        end = len(self.tickets_id) -1
        if end <= 0:
            return None
        sort = random.randint(0, end)
        return self.tickets_id[sort]
    
    def get_random_to_create(self) -> dict | None:
        end = len(self.to_create) -1
        if end > 0:
            sort = random.randint(0, end)
            ticket = self.to_create[sort]
            self.to_create.remove(ticket)
            return ticket
        return None
    
    def get_random_ticket(self) -> dict | None:
        end = len(self.tickets) -1
        if end > 0:
            sort = random.randint(0, end)
            ticket = self.tickets[sort]
            return ticket
        return None