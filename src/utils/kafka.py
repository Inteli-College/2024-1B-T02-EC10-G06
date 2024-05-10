from confluent_kafka import Producer

class ProducerController:
    def __init__(self,servers = 'localhost:29092', client_id = 'python-producer', username = "apikey", password = "yourpassword"):
        self.producer = Producer({
            'bootstrap.servers': servers,
            'client.id': client_id,
            "sasl.mechanism" : "PLAIN",
            "security.protocol" : "SASL_SSL",
            "sasl.username" : username,
            "sasl.password" : password,
        })

    def delivery_callback(self, err, msg):
        if err:
            print(f'Message delivery failed: {err}')
        else:
            print(f'Message delivered to {msg.topic()} [{msg.partition()}]')

    def produce(self, topic, message):
        self.producer.produce(topic, message.encode('utf-8'), callback=self.delivery_callback)

    def flush(self):
        self.producer.flush()


