from datetime import date
from datasource.datasource import IDatasource
import json
from kafka import KafkaProducer

server = ""
class Producer:
    def __init__(self, topic: str, datasource: IDatasource) -> None:
        self.topic = topic
        self.datasource = datasource
        self.kafka_producer = KafkaProducer(bootstrap_servers=[server])

    def send_since(self, since_date: date):
        data = self.datasource.get_since(since_date)
        encoded_data = json.dumps(data).encode()
        self.kafka_producer.send(self.topic, encoded_data)

