#!/usr/bin/env python
# -*- coding: utf-8 -*-

from kafka import KafkaProducer
from kafka.errors import KafkaError

# 不知道为啥, 用 test_topic 作为 topic 名称就会挂掉, 发布出去消息
topic = "tests"
bootstrap_servers='127.0.0.1:9092'

def produce():
    producer = KafkaProducer(bootstrap_servers=bootstrap_servers)

    # Asynchronous by default
    future = producer.send(topic, b'raw_bytes')
    
    # Block for 'synchronous' sends
    try:
        record_metadata = future.get(timeout=2)
    except KafkaError as e:
        print("发送失败. KafkaError: ", repr(e))
        return 
    
    # Successful result returns assigned partition and offset
    print ("发送成功: topic: %s, partition: %s, offset:%s" % (record_metadata.topic,
           record_metadata.partition,record_metadata.offset))
    
    # block until all async messages are sent
    producer.flush()
    
    # configure multiple retries
    producer = KafkaProducer(retries=5)

if __name__=="__main__":
    produce()
