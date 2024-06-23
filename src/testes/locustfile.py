from locust import HttpUser, task, between, TaskSet
from entidades.pyxi import Pyxi
from entidades.medicine import Medicine
from entidades.ticket import Ticket
import random


pyxi_istance = Pyxi(pyxis=[
    {
        "description": "Emergência",
        "medicines": []
    },
    {
        "description": "UTI (Unidade de Terapia Intensiva)",
        "medicines": []
    },
    {
        "description": "Centro Cirúrgico",
        "medicines": []
    },
    {
        "description": "Pediatria",
        "medicines": []
    },
    {
        "description": "Maternidade",
        "medicines": []
    },
    {
        "description": "Oncologia",
        "medicines": []
    },
    {
        "description": "Cardiologia",
        "medicines": []
    },
    {
        "description": "Neurologia",
        "medicines": []
    },
    {
        "description": "Ortopedia",
        "medicines": []
    },
    {
        "description": "Nefrologia",
        "medicines": []
    },
    {
        "description": "Hematologia",
        "medicines": []
    },
    {
        "description": "Reumatologia",
        "medicines": []
    },
    {
        "description": "Infectologia",
        "medicines": []
    },
    {
        "description": "Imunologia",
        "medicines": []
    },
    {
        "description": "Pneumologia",
        "medicines": []
    },
    {
        "description": "Anestesiologia",
        "medicines": []
    },
    {
        "description": "Hepatologia",
        "medicines": []
    },
    {
        "description": "Nutrição Clínica",
        "medicines": []
    },
    {
        "description": "Endoscopia",
        "medicines": []
    },
    {
        "description": "Osteopatia",
        "medicines": []
    },
    {
        "description": "Fonoaudiologia",
        "medicines": []
    },
    {
        "description": "Paliativos",
        "medicines": []
    },
    {
        "description": "Transplantes",
        "medicines": []
    },
    {
        "description": "Genética Médica",
        "medicines": []
    },
    {
        "description": "Alergologia",
        "medicines": []
    },
    {
        "description": "Cuidados Intermediários",
        "medicines": []
    },
    {
        "description": "Serviço Social",
        "medicines": []
    },
    {
        "description": "Psicologia",
        "medicines": []
    },
    {
        "description": "Banco de Sangue",
        "medicines": []
    },
    {
        "description": "Fisiatria",
        "medicines": []
    },
    {
        "description": "Hospital-Dia",
        "medicines": []
    },
    {
        "description": "Dermatologia",
        "medicines": []
    },
    {
        "description": "Oftalmologia",
        "medicines": []
    },
    {
        "description": "Otorrinolaringologia",
        "medicines": []
    },
    {
        "description": "Urologia",
        "medicines": []
    },
    {
        "description": "Endocrinologia",
        "medicines": []
    },
    {
        "description": "Audiometria",
        "medicines": []
    },
    {
        "description": "Quiropraxia",
        "medicines": []
    },
    {
        "description": "Angiologia",
        "medicines": []
    },
    {
        "description": "Proctologia",
        "medicines": []
    },
    {
        "description": "Andrologia",
        "medicines": []
    },
    {
        "description": "Bariátrica",
        "medicines": []
    },
    {
        "description": "Nutrologia",
        "medicines": []
    },
    {
        "description": "Homeopatia",
        "medicines": []
    },
    {
        "description": "Ergometria",
        "medicines": []
    }
]
)
medicine_istance = Medicine(medicines=[
{ "description": "Analgésico para alívio da dor", "name": "Paracetamol" },
{ "description": "Antibiótico para infecções bacterianas", "name": "Amoxicilina" },
{ "description": "Anti-inflamatório não esteroidal", "name": "Ibuprofeno" },
{ "description": "Antidepressivo para tratamento da depressão", "name": "Fluoxetina" },
{ "description": "Antipirético para redução da febre", "name": "Dipirona" },
{ "description": "Anti-histamínico para alergias", "name": "Loratadina" },
{ "description": "Broncodilatador para asma", "name": "Salbutamol" },
{ "description": "Anticonvulsivante para epilepsia", "name": "Carbamazepina" },
{ "description": "Anticoagulante para prevenção de tromboses", "name": "Varfarina" },
{ "description": "Anti-hipertensivo para controle da pressão arterial", "name": "Losartana" },
{ "description": "Antidiabético para controle da glicemia", "name": "Metformina" },
{ "description": "Antiviral para tratamento da gripe", "name": "Oseltamivir" },
{ "description": "Antifúngico para infecções fúngicas", "name": "Fluconazol" },
{ "description": "Antiácido para alívio de azia e refluxo", "name": "Omeprazol" },
{ "description": "Antipsicótico para esquizofrenia", "name": "Risperidona" },
{ "description": "Corticosteroide para inflamações", "name": "Prednisona" },
{ "description": "Antimalárico para prevenção e tratamento da malária", "name": "Cloroquina" },
{ "description": "Antiparasitário para infecções por vermes", "name": "Albendazol" },
{ "description": "Diurético para redução de edema", "name": "Furosemida" },
{ "description": "Anticolinérgico para doenças respiratórias", "name": "Ipratrópio" },
{ "description": "Ansiolítico para ansiedade", "name": "Diazepam" },
{ "description": "Antiepiléptico para crises epilépticas", "name": "Fenitoína" },
{ "description": "Estatinas para controle de colesterol", "name": "Atorvastatina" },
{ "description": "Supressor de apetite para obesidade", "name": "Sibutramina" },
{ "description": "Hormônio para hipotireoidismo", "name": "Levotiroxina" },
{ "description": "Inibidor de bomba de prótons para úlcera", "name": "Esomeprazol" },
{ "description": "Anticoncepcional para prevenção de gravidez", "name": "Etinilestradiol" },
{ "description": "Estimulante para TDAH", "name": "Metilfenidato" },
{ "description": "Antiemético para náuseas e vômitos", "name": "Ondansetrona" },
{ "description": "Beta-bloqueador para controle de arritmias", "name": "Propranolol" },
{ "description": "Inibidor da ECA para hipertensão", "name": "Enalapril" },
{ "description": "Suplemento de vitamina D", "name": "Colecalciferol" },
{ "description": "Inibidor da COX-2 para inflamação", "name": "Celecoxib" },
{ "description": "Imunossupressor para transplantes", "name": "Ciclosporina" },
{ "description": "Antipsicótico para transtorno bipolar", "name": "Quetiapina" },
{ "description": "Antidiarreico para controle de diarreia", "name": "Loperamida" },
{ "description": "Expectorante para tosse produtiva", "name": "Guaifenesina" },
{ "description": "Descongestionante nasal", "name": "Pseudoefedrina" },
{ "description": "Antiprotozoário para infecções por protozoários", "name": "Metronidazol" },
{ "description": "Antitussígeno para tosse seca", "name": "Dextrometorfano" },
{ "description": "Estimulante respiratório para apneia", "name": "Cafeína" },
{ "description": "Antiglaucomatoso para redução da pressão ocular", "name": "Timolol" },
{ "description": "Antiviral para herpes", "name": "Aciclovir" },
{ "description": "Antagonista do receptor de angiotensina II para hipertensão", "name": "Valsartana" },
{ "description": "Estabilizador de humor para transtorno bipolar", "name": "Lítio" },
{ "description": "Progestágeno para distúrbios menstruais", "name": "Medroxiprogesterona" },
{ "description": "Anticonvulsivante para prevenção de enxaqueca", "name": "Topiramato" },
{ "description": "Anestésico local", "name": "Lidocaína" },
{ "description": "Relaxante muscular para espasmos musculares", "name": "Ciclobenzaprina" },
{ "description": "Antifibrinolítico para sangramento excessivo", "name": "Ácido Tranexâmico" }
])
ticket_istance = Ticket()


class AdmUser(HttpUser):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.ticket_istance = ticket_istance
        self.medicine_istance = medicine_istance
        self.pyxi_istance = pyxi_istance
        


    # @task
    # def get_ticket(self):
    #     self.client.get(f"/tickets/{ticket_istance.get_random_id()}")

    # @task
    # def update_ticket(self):
    #     self.client.put(f"/tickets/{ticket_istance.get_random_id()}", json={
    #         "idPyxis": "str",
    #         "description": "Teste para ver se da fila foi para o banco de dados",
    #         "body": []
    #     })

    # @task
    # def delete_ticket(self):
    #     self.client.delete(f"/tickets/{ticket_istance.get_random_id()}")

    # @task
    # def create_ticket(self):
    #     self.client.post("/tickets/", json={
    #         "idPyxis": f"{pyxi_istance.get_random_id()}",
    #         "description": "Teste para ver se da fila foi para o banco de dados",
    #         "body": [
    #             {
    #                 "id": "6640fd1acdf84fa31ebf3ede",
    #                 "name": "oi",
    #                 "description": "Vamos ver se foi mesmo"
    #             },
    #             {
    #                 "id": "6640fd21cdf84fa31ebf3ee0",
    #                 "name": "oi",
    #                 "description": "Vamos ver se foi mesmo"
    #             }
    #         ]
    #     })

    # @task
    # def get_tickets(self):
    #     self.client.get("/tickets/")

    @task(100)
    def get_medicines(self):
        self.client.get("medicines/")
        
        

    @task(100)
    def get_pyxis(self):
        self.client.get("pyxis/")
                

    @task(70)
    def create_medicine(self):
        medicine = self.medicine_istance.get_random_to_create() # Adicionar o Pegar a resposta da operação para salvar o ID
        if medicine == None:
            return
        response = self.client.post("medicines/", json=medicine)
        if response.status_code == 200:
            rawData = response.json()
            self.medicine_istance.add_medicine(id=rawData["id"])

    @task(70)
    def create_pyxis(self):
        pyxi = self.pyxi_istance.get_random_pyxi() # Adicionar o Pegar a resposta da operação para salvar o ID
        if pyxi == None:
            return
        response = self.client.post("pyxis/", json=pyxi)
        if response.status_code == 200:
            rawData = response.json()
            self.pyxi_istance.add_pyxi(id=rawData["id"])
        
        

    @task(90)
    def get_medicine(self):
        end = len(medicine_istance.medicines_id) -1
        if end > 0:
            sort = random.randint(1, end)
            self.client.get(f"medicines/{medicine_istance.get_random_id(interator=0,index=sort)}")

    @task(100)
    def get_specific_pyxi(self):
        self.client.get(f"pyxis/{pyxi_istance.get_random_id()}")

    # @task(30)
    # def update_medicine(self):
    #     self.client.put(f"medicines/{medicine_istance.get_random_id()}", json=medicine_istance.get_random_medicine())

    @task(10)
    def delete_medicine(self):
        end = len(medicine_istance.medicines_id) -1
        if end <= 0:
            return
        sort = random.randint(1, end)
        id = medicine_istance.get_random_id()
        medicine_id = medicine_istance.get_random_id(interator=0,index=sort)
        if medicine_id != None:
            response = self.client.get(f"medicines/{medicine_id}")
            if response.status_code == 200:
                rawData = response.json()
                recycling_medicine = {
                    "description": rawData["description"],
                    "name": rawData["name"]
                }
                medicine_istance.add_to_create(recycling_medicine)
                self.client.delete(f"medicines/{id}")
                medicine_istance.delete_medicine(id)
        
        


    @task(10)
    def update_pyxi(self):
        sort = random.randint(1, 10)
        id = pyxi_istance.get_random_id()
        pyxi_response = self.client.get(f"pyxis/{id}")
        if pyxi_response:
            medicines = []
            rawData = {}
            if id != None:
                for interador in range(10):
                    medicine_response = self.client.get(f"medicines/{medicine_istance.get_random_id(interador, sort)}")
                    if medicine_response:
                        rawData = medicine_response.json()
                        medicines.append(rawData)
            pyxi = pyxi_response.json()
            pyxi['medicines'] = medicines
            
            self.client.put(f"pyxis/{id}", json=pyxi)

    # @task
    # def delete_pyxi(self):
    #     self.client.delete(f"pyxis/{pyxi_istance.get_random_id()}")
