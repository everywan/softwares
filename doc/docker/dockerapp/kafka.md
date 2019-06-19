# 创建kafka节点

参考 https://github.com/wurstmeister/kafka-docker

流程:
```Bash
# 下载项目
git clone https://github.com/wurstmeister/kafka-docker

# 更改 docker-compose.yml KAFKA_ADVERTISED_HOST_NAME, 修改为自己的IP

# Start a cluster
docker-compose up -d

# Add more brokers
docker-compose scale kafka=3

# Destroy a cluster
docker-compose stop

# 测试
# 进入容器
docker exec -it wurkafka_kafka_1 /bin/bash

# 创建topic
$KAFKA_HOME/bin/kafka-topics.sh --create --topic test --zookeeper wurkafka_zookeeper_1:2181 --replication-factor 1 --partitions 1

# 查看topic
$KAFKA_HOME/bin/kafka-topics.sh --zookeeper wurkafka_zookeeper_1:2181 --describe --topic test

# 发布消息
$KAFKA_HOME/bin/kafka-console-producer.sh --topic=test --broker-list wurkafka_kafka_1:9092

# 接收消息
$KAFKA_HOME/bin/kafka-console-consumer.sh --bootstrap-server wurkafka_kafka_1:9092 --from-beginning --topic test
```

