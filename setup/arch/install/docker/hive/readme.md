# hive
参考 [docker-hive](https://github.com/big-data-europe/docker-hive) 实现.

spark 链接 hive 的thrift端口为 8093

```Bash
# 直接进容器内部, 使用 beeline 访问hive
docker-compose exec hive-server bash
/opt/hive/bin/beeline -u jdbc:hive2://localhost:10000

# 下载 presto-cli, 随处访问hive
wget https://repo1.maven.org/maven2/io/prestosql/presto-cli/308/presto-cli-308-executable.jar
mv presto-cli-308-executable.jar presto.jar
chmod +x presto.jar
./presto.jar --server localhost:8080 --catalog hive --schema default
presto> select * from pokes;
```
