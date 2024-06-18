import pika
import json
import os
from dotenv import load_dotenv
from pymongo import MongoClient
load_dotenv()

uri = os.getenv("MONGO_LOCAL_URI")
client = MongoClient(uri)
client_id = "python-producer"



tickets_db = client.get_database("Hermes")
collection = tickets_db.get_collection("Tickets")

class Consumer:
    def __init__(self):
        self.connection = pika.BlockingConnection(
            pika.ConnectionParameters(host='bridge',port=5672))
        self.channel = self.connection.channel()

    def consume(self):
        self.channel.basic_consume(
            queue='ticket_queue', on_message_callback=self.callback)
        print(' [*] Waiting for messages. To exit press CTRL+C')
        self.channel.start_consuming()

    def callback(self, ch, method, properties, body):
        print(f" [x] Received {body}")

        ticket = json.loads(body)
        ticket_id = collection.insert_one(ticket).inserted_id

        ticket['id'] = str(ticket_id)
        print(f" [x] Inserted {ticket}")

        ch.basic_ack(delivery_tag=method.delivery_tag)

    def receiveExchange(self, exchangeName:str,queueName:str):
        self.channel.queue_bind(exchange=exchangeName, queue=queueName)



consumer = Consumer()

consumer.receiveExchange("ticket","ticket_queue")

consumer.consume()

