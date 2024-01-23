import kafka

address = "20.241.238.196"
port = 9094

# address = "10.244.0.25"
# port = 9095

# address = "1.2.3.4"

sasl_plain_username = "user1"
sasl_plain_password = ""

client = kafka.KafkaClient(
    bootstrap_servers=[f"{address}:{port}"],
    # sasl_plain_username=sasl_plain_username,
    # sasl_plain_password=sasl_plain_password
    )
res = client.check_version()
print(res)

client.add_topic("abc")

producer = kafka.KafkaProducer(bootstrap_servers=[f"{address}:{port}"])
print(
    producer.config.items()
)
producer.send("abc", b"kafka works!")

consumer = kafka.KafkaConsumer(topics=["abc"], bootstrap_servers=[f"{address}:{port}"])

for msg in consumer:
    print(msg)
