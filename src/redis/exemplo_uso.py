from redis.commands.search.field import  TextField
from connect import RedisInterface

if __name__ == "__main__":
    # Inicialização
    redis_interface = RedisInterface(urls_host="localhost")

    # Estrutura de dados
    data = [
        {
  "id": "666707c155e2dad91f1d9fa2",
  "description": "Quiropraxia",
  "medicines": [
    {
      "id": "666707c255e2dad91f1d9fce",
      "name": "Diazepam",
      "description": "Ansiolítico para ansiedade"
    },
    {
      "id": "666707c255e2dad91f1d9fd3",
      "name": "Furosemida",
      "description": "Diurético para redução de edema"
    },
    {
      "id": "666707c255e2dad91f1d9fd4",
      "name": "Metronidazol",
      "description": "Antiprotozoário para infecções por protozoários"
    }
  ]
},
        {
            "id": "66623fa9ca00d05b910da09d",
            "descrition": "Antipsicótico para transtorno bipolar",
            "medicines": [
                {
                    "id": "66623faaca00d05b910da0b6",
                    "name": "Timolol",
                    "descrition": "Antiglaucomatoso para redução da pressão ocular"
                },
                {
                    "id": "66623faaca00d05b910da0c5",
                    "name": "Metilfenidato",
                    "descrition": "Estimulante para TDAH"
                }
            ]
        },
        # Adicione os outros itens...
    ]

    # Definir o esquema do índice
    schema = (
        TextField("$.id", as_name="id"),
        TextField("$.descrition", as_name="descrition"),
        TextField("$.medicines[*].id", as_name="medicines_id"),
        TextField("$.medicines[*].name", as_name="medicines_name"),
        TextField("$.medicines[*].descrition", as_name="medicines_descrition"),
        TextField("$.medicines[*].detail", as_name="medicines_detail")
    )

    # Criar o índice
    redis_interface.index_create("pyxis", schema)

    # Indexar dados
    redis_interface.set_values("pyxis", data)

    # Fazer uma busca
    results = redis_interface.get_value("id", "666707c155e2dad91f1d9fa2")
    for doc in results.docs:
        print(doc)

