# Mysql
1. 拉取镜像: `docker pull mysql:5.7`
2. 创建容器: `docker run --name mysql -p 3306:3306 -v $PWD/config:/etc/mysql/conf.d -v $PWD/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=*** -d mysql:5.7`
    - 映射外网IP: `-p 3306:3306`
    - 挂载配置文件: `-v $PWD/config:/etc/mysql/conf.d`
    - 挂载数据: `-v $PWD/data:/var/lib/mysql`
    - 设置密码: `-e MYSQL_ROOT_PASSWORD=***`
3. 链接数据库: 需要在一台有mysql-client的服务器上链接. 无法直接进入容器
    - 示例: `mysql -h 192.168.1.2 -uroot -p***`

