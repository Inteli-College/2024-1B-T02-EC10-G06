from locust import HttpUser, task, between
from entidades.pyxi import Pyxi
from entidades.medicine import Medicine
from entidades.ticket import Ticket

pyxi_istance = Pyxi(pyxis=[
    {
        "descrition": "Emergência",
        "medicines": []
    },
    {
        "descrition": "UTI (Unidade de Terapia Intensiva)",
        "medicines": []
    },
    {
        "descrition": "Centro Cirúrgico",
        "medicines": []
    },
    {
        "descrition": "Pediatria",
        "medicines": []
    },
    {
        "descrition": "Maternidade",
        "medicines": []
    },
    {
        "descrition": "Oncologia",
        "medicines": []
    },
    {
        "descrition": "Cardiologia",
        "medicines": []
    },
    {
        "descrition": "Neurologia",
        "medicines": []
    },
    {
        "descrition": "Ortopedia",
        "medicines": []
    },
    {
        "descrition": "Nefrologia",
        "medicines": []
    },
    {
        "descrition": "Hematologia",
        "medicines": []
    },
    {
        "descrition": "Reumatologia",
        "medicines": []
    },
    {
        "descrition": "Infectologia",
        "medicines": []
    },
    {
        "descrition": "Imunologia",
        "medicines": []
    },
    {
        "descrition": "Pneumologia",
        "medicines": []
    },
    {
        "descrition": "Anestesiologia",
        "medicines": []
    },
    {
        "descrition": "Hepatologia",
        "medicines": []
    },
    {
        "descrition": "Nutrição Clínica",
        "medicines": []
    },
    {
        "descrition": "Endoscopia",
        "medicines": []
    },
    {
        "descrition": "Osteopatia",
        "medicines": []
    },
    {
        "descrition": "Fonoaudiologia",
        "medicines": []
    },
    {
        "descrition": "Paliativos",
        "medicines": []
    },
    {
        "descrition": "Transplantes",
        "medicines": []
    },
    {
        "descrition": "Genética Médica",
        "medicines": []
    },
    {
        "descrition": "Alergologia",
        "medicines": []
    },
    {
        "descrition": "Cuidados Intermediários",
        "medicines": []
    },
    {
        "descrition": "Serviço Social",
        "medicines": []
    },
    {
        "descrition": "Psicologia",
        "medicines": []
    },
    {
        "descrition": "Banco de Sangue",
        "medicines": []
    },
    {
        "descrition": "Fisiatria",
        "medicines": []
    },
    {
        "descrition": "Hospital-Dia",
        "medicines": []
    },
    {
        "descrition": "Dermatologia",
        "medicines": []
    },
    {
        "descrition": "Oftalmologia",
        "medicines": []
    },
    {
        "descrition": "Otorrinolaringologia",
        "medicines": []
    },
    {
        "descrition": "Urologia",
        "medicines": []
    },
    {
        "descrition": "Endocrinologia",
        "medicines": []
    },
    {
        "descrition": "Audiometria",
        "medicines": []
    },
    {
        "descrition": "Quiropraxia",
        "medicines": []
    },
    {
        "descrition": "Angiologia",
        "medicines": []
    },
    {
        "descrition": "Proctologia",
        "medicines": []
    },
    {
        "descrition": "Andrologia",
        "medicines": []
    },
    {
        "descrition": "Bariátrica",
        "medicines": []
    },
    {
        "descrition": "Nutrologia",
        "medicines": []
    },
    {
        "descrition": "Homeopatia",
        "medicines": []
    },
    {
        "descrition": "Ergometria",
        "medicines": []
    }
]
)
medicine_istance = Medicine(medicines=[
{ "descrition": "Analgésico para alívio da dor", "name": "Paracetamol" },
{ "descrition": "Antibiótico para infecções bacterianas", "name": "Amoxicilina" },
{ "descrition": "Anti-inflamatório não esteroidal", "name": "Ibuprofeno" },
{ "descrition": "Antidepressivo para tratamento da depressão", "name": "Fluoxetina" },
{ "descrition": "Antipirético para redução da febre", "name": "Dipirona" },
{ "descrition": "Anti-histamínico para alergias", "name": "Loratadina" },
{ "descrition": "Broncodilatador para asma", "name": "Salbutamol" },
{ "descrition": "Anticonvulsivante para epilepsia", "name": "Carbamazepina" },
{ "descrition": "Anticoagulante para prevenção de tromboses", "name": "Varfarina" },
{ "descrition": "Anti-hipertensivo para controle da pressão arterial", "name": "Losartana" },
{ "descrition": "Antidiabético para controle da glicemia", "name": "Metformina" },
{ "descrition": "Antiviral para tratamento da gripe", "name": "Oseltamivir" },
{ "descrition": "Antifúngico para infecções fúngicas", "name": "Fluconazol" },
{ "descrition": "Antiácido para alívio de azia e refluxo", "name": "Omeprazol" },
{ "descrition": "Antipsicótico para esquizofrenia", "name": "Risperidona" },
{ "descrition": "Corticosteroide para inflamações", "name": "Prednisona" },
{ "descrition": "Antimalárico para prevenção e tratamento da malária", "name": "Cloroquina" },
{ "descrition": "Antiparasitário para infecções por vermes", "name": "Albendazol" },
{ "descrition": "Diurético para redução de edema", "name": "Furosemida" },
{ "descrition": "Anticolinérgico para doenças respiratórias", "name": "Ipratrópio" },
{ "descrition": "Ansiolítico para ansiedade", "name": "Diazepam" },
{ "descrition": "Antiepiléptico para crises epilépticas", "name": "Fenitoína" },
{ "descrition": "Estatinas para controle de colesterol", "name": "Atorvastatina" },
{ "descrition": "Supressor de apetite para obesidade", "name": "Sibutramina" },
{ "descrition": "Hormônio para hipotireoidismo", "name": "Levotiroxina" },
{ "descrition": "Inibidor de bomba de prótons para úlcera", "name": "Esomeprazol" },
{ "descrition": "Anticoncepcional para prevenção de gravidez", "name": "Etinilestradiol" },
{ "descrition": "Estimulante para TDAH", "name": "Metilfenidato" },
{ "descrition": "Antiemético para náuseas e vômitos", "name": "Ondansetrona" },
{ "descrition": "Beta-bloqueador para controle de arritmias", "name": "Propranolol" },
{ "descrition": "Inibidor da ECA para hipertensão", "name": "Enalapril" },
{ "descrition": "Suplemento de vitamina D", "name": "Colecalciferol" },
{ "descrition": "Inibidor da COX-2 para inflamação", "name": "Celecoxib" },
{ "descrition": "Imunossupressor para transplantes", "name": "Ciclosporina" },
{ "descrition": "Antipsicótico para transtorno bipolar", "name": "Quetiapina" },
{ "descrition": "Antidiarreico para controle de diarreia", "name": "Loperamida" },
{ "descrition": "Expectorante para tosse produtiva", "name": "Guaifenesina" },
{ "descrition": "Descongestionante nasal", "name": "Pseudoefedrina" },
{ "descrition": "Antiprotozoário para infecções por protozoários", "name": "Metronidazol" },
{ "descrition": "Antitussígeno para tosse seca", "name": "Dextrometorfano" },
{ "descrition": "Estimulante respiratório para apneia", "name": "Cafeína" },
{ "descrition": "Antiglaucomatoso para redução da pressão ocular", "name": "Timolol" },
{ "descrition": "Antiviral para herpes", "name": "Aciclovir" },
{ "descrition": "Antagonista do receptor de angiotensina II para hipertensão", "name": "Valsartana" },
{ "descrition": "Estabilizador de humor para transtorno bipolar", "name": "Lítio" },
{ "descrition": "Progestágeno para distúrbios menstruais", "name": "Medroxiprogesterona" },
{ "descrition": "Anticonvulsivante para prevenção de enxaqueca", "name": "Topiramato" },
{ "descrition": "Anestésico local", "name": "Lidocaína" },
{ "descrition": "Relaxante muscular para espasmos musculares", "name": "Ciclobenzaprina" },
{ "descrition": "Antifibrinolítico para sangramento excessivo", "name": "Ácido Tranexâmico" }
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
    #         "descrition": "Teste para ver se da fila foi para o banco de dados",
    #         "body": []
    #     })

    # @task
    # def delete_ticket(self):
    #     self.client.delete(f"/tickets/{ticket_istance.get_random_id()}")

    # @task
    # def create_ticket(self):
    #     self.client.post("/tickets/", json={
    #         "idPyxis": f"{pyxi_istance.get_random_id()}",
    #         "descrition": "Teste para ver se da fila foi para o banco de dados",
    #         "body": [
    #             {
    #                 "id": "6640fd1acdf84fa31ebf3ede",
    #                 "name": "oi",
    #                 "descrition": "Vamos ver se foi mesmo"
    #             },
    #             {
    #                 "id": "6640fd21cdf84fa31ebf3ee0",
    #                 "name": "oi",
    #                 "descrition": "Vamos ver se foi mesmo"
    #             }
    #         ]
    #     })

    # @task
    # def get_tickets(self):
    #     self.client.get("/tickets/")

    @task
    def get_medicines(self):
        self.client.get("medicines/")
        
        

    @task
    def get_pyxis(self):
        self.client.get("pyxis/")
                

    @task
    def create_medicine(self):
        medicine = self.medicine_istance.get_random_to_create() # Adicionar o Pegar a resposta da operação para salvar o ID
        if medicine == None:
            return
        response = self.client.post("medicines/", json=medicine)
        rawData = response.json()
        self.medicine_istance.add_medicine(id=rawData["id"])

    @task
    def create_pyxis(self):
        pyxi = self.pyxi_istance.get_random_pyxi() # Adicionar o Pegar a resposta da operação para salvar o ID
        if pyxi == None:
            return
        response = self.client.post("pyxis/", json=pyxi)
        rawData = response.json()
        self.pyxi_istance.add_pyxi(id=rawData["id"])
        
        

    @task
    def get_medicine(self):
        self.client.get(f"medicines/{medicine_istance.get_random_id()}")

    @task
    def get_specific_pyxi(self):
        self.client.get(f"pyxis/{pyxi_istance.get_random_id()}")

    @task
    def update_medicine(self):
        self.client.put(f"medicines/{medicine_istance.get_random_id()}", json=medicine_istance.get_random_medicine())

    # @task
    # def delete_medicine(self):
    #     self.client.delete(f"medicines/{medicine_istance.get_random_id()}")

    @task
    def update_pyxi(self):
        id = pyxi_istance.get_random_id()
        response = self.client.get(f"pyxis/{id}")
        medicines = []
        rawData = {}
        if id != None:
            for _ in range(10):
                response = self.client.get(f"medicines/{medicine_istance.get_random_id()}")
                rawData = response.json()
                medicines.append(rawData)
            rawData = response.json()
        pyxi = rawData
        pyxi['medicines'] = medicines
        
        self.client.put(f"pyxis/{id}", json=pyxi)

    # @task
    # def delete_pyxi(self):
    #     self.client.delete(f"pyxis/{pyxi_istance.get_random_id()}")


# Henry Ford | Steve Jobs sobre perguntar o que o usuário quer.