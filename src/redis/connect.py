import redis
import time
import redis.commands.search.aggregation as aggregations
import redis.commands.search.reducers as reducers
from redis.commands.json.path import Path
from redis.commands.search.field import NumericField, TagField, TextField
from redis.commands.search.indexDefinition import IndexDefinition, IndexType
from redis.commands.search.query import Query


class redis_interface():
    def __init__(self, urls_host="localhost") -> None:
        self.engnie = redis.Redis(
        host=urls_host, 
        port=6379, 
        db=0, 
        decode_responses=True,
        )

        self.index = {}
    
    def index_create(self, tag_name, schema):
        if  tag_name in self.index:
            self.index[tag_name] = self.engnie.ft(f"idx:{tag_name}")
            print("Gerou o indexador: ",tag_name)

            # Essa operação depênde da conexão com o server, ela deve ser executada apenas uma vez.
            self.index[tag_name].create_index(
                schema,
                definition=IndexDefinition(prefix=[f"{tag_name}:"], index_type=IndexType.JSON),
                )
        print("Index já criado")
    
    def set_value(self,value, key):
        self.engnie.json().set(f"{key}", Path.root_path(), value)

    def set_values(self, tag_name, values):
        for bid, value in enumerate(values):
            self.engnie.json().set(f"{tag_name}:{bid}", Path.root_path(), value)
    
    def get_value(self, tag_name, query="*") -> dict:
        if tag_name not in self.index:
            return {"Erro":f"{tag_name} indexador não encontrado."}
        res = self.index[tag_name].search(Query(f"{query}"))
        return res


    
# r = redis.Redis(
# host="redis", 
# port=6379, 
# db=0, 
# decode_responses=True,
# )



remedios = [
    {
    "brand": "Velorim",
    "model": "Dipirona 30 unidades",
    "description": "Não há mais nem um",
    "urgencia":"media"
    },
    {
        "brand": "Velorim",
        "model": "Dipirona 30 unidades",
        "description": "Não há mais nem um",
         "urgencia":"alta"
    },
    {
        "brand": "Velorim",
        "model": "Dipirona 30 unidades",
        "description": "Não há mais nem um",
         "urgencia":"media"
    }
]

bicycles = [
    {
        "brand": "Bicyk",
        "model": "Hillcraft",
        "price": 1200,
        "description": (
            "Kids want to ride with as little weight as possible."
            " Especially on an incline! They may be at the age "
            'when a 27.5" wheel bike is just too clumsy coming '
            'off a 24" bike. The Hillcraft 26 is just the solution'
            " they need!"
        ),
        "condition": "used",
    },
    {
        "brand": "Nord",
        "model": "Chook air 5",
        "price": 815,
        "description": (
            "The Chook Air 5  gives kids aged six years and older "
            "a durable and uberlight mountain bike for their first"
            " experience on tracks and easy cruising through forests"
            " and fields. The lower  top tube makes it easy to mount"
            " and dismount in any situation, giving your kids greater"
            " safety on the trails."
        ),
        "condition": "used",
    },
    {
        "brand": "Eva",
        "model": "Eva 291",
        "price": 3400,
        "description": (
            "The sister company to Nord, Eva launched in 2005 as the"
            " first and only women-dedicated bicycle brand. Designed"
            " by women for women, allEva bikes are optimized for the"
            " feminine physique using analytics from a body metrics"
            " database. If you like 29ers, try the Eva 291. It's a "
            "brand new bike for 2022.. This full-suspension, "
            "cross-country ride has been designed for velocity. The"
            " 291 has 100mm of front and rear travel, a superlight "
            "aluminum frame and fast-rolling 29-inch wheels. Yippee!"
        ),
        "condition": "used",
    },
]

schema = (
    TextField("$.brand", as_name="brand"),
    TextField("$.model", as_name="model"),
    TextField("$.description", as_name="description"),
    NumericField("$.price", as_name="price"),
    TagField("$.condition", as_name="condition"),
)


r = redis_interface(urls_host="redis")

r.index_create("bicycle",schema)
r.index_create("remedios",(
    TextField("$.brand", as_name="brand"),
    TextField("$.model", as_name="model"),
    TextField("$.description", as_name="description"),
    TextField("$.urgencia", as_name="urgencia"),
))

r.set_values(tag_name="bicycle", values=bicycles)
r.set_values(tag_name="remedios", values=remedios)

print("Meus remidios: ",r.get_value( tag_name="",query="@urgencia:media"))

# # Essa operação depênde da conexão com o server, ela deve ser executada apenas uma vez
# index.create_index(
#     schema,
#     definition=IndexDefinition(prefix=["bicycle:"], index_type=IndexType.JSON),
# )


# for bid, bicycle in enumerate(bicycles):
#     r.json().set(f"bicycle:{bid}", Path.root_path(), bicycle)


# res = index.search(Query("*"))
# #print("Documents found:", res.total)


# res = index.search(Query("@model:Jigger"))
# #print(res)

# res = index.search(
#     Query("@model:Jigger").return_field("$.price", as_field="price")
# )
# #print(res)

# # Há como se fazer quarys por qual quer palavra do texto, usando operador [] há como criar um range,
# #E o decorador @ indica uma chave
# res = index.search(Query("@price:[0 1000]"))
# #print(res)

# res = index.search(
#     Query(
#         "@description:%analitics%"
#     ).dialect(  # Note the typo in the word "analytics"
#         2
#     )
# )
# #print(res)


# # res = index.search(Query("mountain").with_scores())
# # for sr in res.docs:
# #     print(f"{sr.id}: score={sr.score}")


# req = aggregations.AggregateRequest("*").group_by(
#     "@condition", reducers.count().alias("count")
# )
# res = index.aggregate(req).rows
# print(res)


