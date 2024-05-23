from controller.producer import ProducerController
from pymongo import MongoClient
from  middleware.auth import get_password_hash

uri = "mongodb://localhost:27017/"
client = MongoClient(uri)
server = "localhost:29092"
client_id = "python-producer"
producer = ProducerController(server,client_id)

def getUser(username):
    database = client.get_database("Hermers")
    users = database.get_collection("Users")
    query = {"username": username}
    user = users.find(query)
    if user.count() == 0:
        raise Exception("User not found")
    user = user[0]
    return user

def addUserToQueue(user):
    producer.produce("user", user.json())
    producer.flush()
    return {"message": "User creation is being processed"}

