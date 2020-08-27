# kafka
kafka docker compose 参考 [wurstmeister/kafka-docker](https://github.com/wurstmeister/kafka-docker)

使用注意事项
1. 修改 KAFKA_ADVERTISED_HOST_NAME 为docker host ip. 如果启动单节点, 使用 localhost/127.0.0.1 也可以.
2. 使用本目录下的python脚本收发消息, 测试kafka是否安装成功

kafka python usage [kafka-python api](https://kafka-python.readthedocs.io/en/master/usage.html)

