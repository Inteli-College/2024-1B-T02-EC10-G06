from controller.producer import ProducerController
from pymongo import MongoClient
from dotenv import load_dotenv
import os
from middleware.auth import get_password_hash

load_dotenv()

uri = os.getenv("MONGO_URI")
client = MongoClient(uri)
server = os.getenv("KAFKA_BROKER")
client_id = "python-producer"
apikey = os.getenv("KAFKA_APIKEY")
password = os.getenv("KAFKA_PASSWORD")
producer = ProducerController(server,client_id,apikey,password)

def getUser(username):
    database = client.get_database("Hermes")
    users = database.get_collection("User")
    query = {"username": username}
    if users.count_documents(query) == 0:
        raise Exception("User not found")
    user = users.find(query)
    user = user[0]
    return user

def addUserToQueue(user):
    user.password = get_password_hash(user.password)
    database = client.get_database("Hermes")
    users = database.get_collection("User")
    users.insert_one(user)
    return {"message": "User creation is being processed"}

