from redis.commands.search.field import  TextField
from connect import RedisInterface
import json

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
        {
            "id": "66623fa9ca00d05b910da09d765",
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
    redis_interface.set_values(data)

    # Fazer uma busca
    results = redis_interface.get_value("66623fa9ca00d05b910da09d765")
    print(f'{results} \n {type(results)}')
    if results.docs.__len__() > 0:
        json_str = results.docs[0].json
        json_obj = json.loads(json_str)
        print(json_obj)

pyxi = {
        "id":'66623fa9ca00d05b910da09d765',
        "descrition": 'pyxi_update.descrition',
        "medicines": [
            {
                "id": "d",
                "name": "d",
                "descrition": "d de descrição"
            },
            {
                "id": "d",
                "name": "d",
                "descrition": "teste de d 2"
            }
        ],
    }

redis_interface.set_value("66623fa9ca00d05b910da09d765", pyxi)

print(f'{results} \n {type(results)}')
if results.docs.__len__() > 0:
    json_str = results.docs[0].json
    json_obj = json.loads(json_str)
    print(f' Primeiro  {json_obj}')

pyxi2 = {
        "id":'66623fa9ca00d05b910da09d765',
        "descrition": 'pyxi2_update.descrition',
        "medicines": [
            {
                "id": "Segundo",
                "name": "Segundo",
                "descrition": "Segundo"
            },
            {
                "id": "d",
                "name": "d",
                "descrition": "Segundo"
            }
        ],
    }

redis_interface.set_value("66623fa9ca00d05b910da09d765", pyxi2)
results = redis_interface.get_value("66623fa9ca00d05b910da09d765")
print(f'{results} \n {type(results)}')
if results.docs.__len__() > 0:
    json_str = results.docs[0].json
    json_obj = json.loads(json_str)
    print(f' Segundo  {json_obj}')