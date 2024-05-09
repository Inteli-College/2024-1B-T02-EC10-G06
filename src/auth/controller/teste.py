from confluent_kafka import Producer, Consumer, KafkaError

class ProducerController:
    def __init__(self,servers = 'localhost:29092', client_id = 'python-producer'):
        self.producer = Producer({
            'bootstrap.servers': servers,
            'client.id': client_id
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

class ConsumerController:
    def __init__(self, servers = 'localhost:29092', group_id = 'python-consumer-group', auto_offset_reset = 'earliest'):
        self.consumer = Consumer({
            'bootstrap.servers': servers,
            'group.id': group_id,
            'auto.offset.reset': auto_offset_reset
        })

    def subscribe(self, topics):
        self.consumer.subscribe(topics)

    def poll(self, timeout=1.0):
        return self.consumer.poll(timeout)

    def close(self):
        self.consumer.close()

# Configurações do produtor
producer_config = {
    'bootstrap.servers': 'localhost:29092',
    'client.id': 'python-producer'
}

# Configurações do consumidor
consumer_config = {
    'bootstrap.servers': 'localhost:29092',
    'group.id': 'python-consumer-group',
    'auto.offset.reset': 'earliest'
}

# Criar produtor
producer = Producer(**producer_config)

# Função de callback para confirmação de entrega
def delivery_callback(err, msg):
    if err:
        print(f'Message delivery failed: {err}')
    else:
        print(f'Message delivered to {msg.topic()} [{msg.partition()}]')

# Enviar mensagem
topic = 'users'
message = '{"nome": "Alice", "senha": 30, "permissao": 1}'
producer.produce(topic, message.encode('utf-8'), callback=delivery_callback)

# Aguardar a entrega de todas as mensagens
producer.flush()

# Criar consumidor
consumer = Consumer(**consumer_config)

# Assinar tópico
consumer.subscribe([topic])

# Consumir mensagens
try:
    while True:
        msg = consumer.poll(timeout=1.0)
        if msg is None:
            continue
        if msg.error():
            if msg.error().code() == KafkaError._PARTITION_EOF:
                continue
            else:
                print(msg.error())
                break
        print(f'Received message: {msg.value().decode("utf-8")}')
except KeyboardInterrupt:
    pass
finally:
    # Fechar consumidor
    consumer.close()