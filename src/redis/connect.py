import redis
import time
import redis.commands.search.aggregation as aggregations
import redis.commands.search.reducers as reducers
from redis.commands.json.path import Path
from redis.commands.search.field import NumericField, TagField, TextField
from redis.commands.search.indexDefinition import IndexDefinition, IndexType
from redis.commands.search.query import Query


class Redis_interface():
    def __init__(self, urls_host="localhost") -> None:
        self.engnie = redis.Redis(
        host=urls_host, 
        port=6379, 
        db=0, 
        decode_responses=True,
        )

        # Reponsável por amarzenar o indexador
        self.index = None
    
    def index_create(self, tag_name, schema):
        if  self.index == None:
            self.index = self.engnie.ft(f"idx:{tag_name}")
            print("Gerou o indexador: ",tag_name)

            # Essa operação depênde da conexão com o server, ela deve ser executada apenas uma vez.
            self.index.create_index(
                schema,
                definition=IndexDefinition(prefix=[f"{tag_name}:"], index_type=IndexType.JSON),
                )
        print("Index já criado")
    
    def set_value(self,key,value):
        self.engnie.json().set(f"{key}", Path.root_path(), value)

    def set_values(self, tag_name, values):
        for bid, value in enumerate(values):
            self.engnie.json().set(f"{tag_name}:{bid}", Path.root_path(), value)
    
    def get_value(self, tag_name, query="*") -> dict:
        if self.index == None:
            raise {"Erro":f"{tag_name} indexador não encontrado."}
        res = self.index.search(Query(f"{query}"))
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
    }
]

# schema redis 
schema = {
    "brand": TextField(),
    "model": TextField(),
    "description": TextField(),
    "urgencia": TextField(),
}


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


