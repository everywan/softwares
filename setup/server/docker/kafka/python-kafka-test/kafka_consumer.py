#!/usr/bin/env python
# -*- coding: utf-8 -*-

from kafka import TopicPartition
from kafka import KafkaConsumer

topic = "test_topic"
bootstrap_servers=['127.0.0.1:9092']

def consume():
    consumer = KafkaConsumer(topic,
                             bootstrap_servers)
    for message in consumer:
        print ("收到消息: topic: %s, partition:%d, offset:%d, key:%s, value:%s" % (
            message.topic, message.partition, message.offset, message.key, message.value))

    # consume earliest available messages, don't commit offsets
    KafkaConsumer(auto_offset_reset='earliest', enable_auto_commit=False)

    # consume json messages
    KafkaConsumer(value_deserializer=lambda m: json.loads(m.decode('ascii')))

    # StopIteration if no message after 1sec
    # KafkaConsumer(consumer_timeout_ms=1000)

def seek(consumer):
    'set offset 0'
    # 获取 partition
    # print(consumer.partitions_for_topic(topic))
    # consumer.seek(TopicPartition(topic, 0), 0)
    pass

if __name__ == "__main__":
    print("test kafka consume start...")
    consume()
