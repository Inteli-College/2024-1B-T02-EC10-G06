from confluent_kafka import Producer
import requests
import json

class ProducerController:
    def __init__(self,servers = 'kafka:9002', client_id = 'python-producer', username = "apikey", password = "yourpassword"):
        # self.producer = Producer({
        #     'bootstrap.servers': servers,
        #     'client.id': client_id,
        #     "sasl.mechanism" : "PLAIN",
        #     "security.protocol" : "SASL_SSL",
        #     "sasl.username" : username,
        #     "sasl.password" : password,
        # })
        self.bridge_url = f"http://{servers}/topics/"

    def delivery_callback(self, err, msg):
        if err:
            print(f'Message delivery failed: {err}')
        else:
            print(f'Message delivered to {msg.topic()} [{msg.partition()}]')

    def produce(self, topic, message):
        self.producer.produce(topic, message.encode('utf-8'), callback=self.delivery_callback)

    def produceWithoutAuth(self, topic,message):
        url = self.bridge_url + topic
        headers = {"Content-Type": "application/json"}
        data = {
            "records": [
                {"value": message}
            ]
        }   
        response = requests.post(url, headers=headers, data=json.dumps(data))

        if response.status_code == 200:
            print("Message produced successfully")
        else:
            raise Exception(f"Failed to produce message: {response.status_code}, {response.text}")
            
    def flush(self):
        self.producer.flush()


