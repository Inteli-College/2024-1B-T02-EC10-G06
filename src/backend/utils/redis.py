import redis
from redis.commands.json.path import Path
from redis.commands.search.indexDefinition import IndexDefinition, IndexType
from redis.commands.search.query import Query


class redis_interface(redis.commands.search.field):
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


