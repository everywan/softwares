# mysql

因为目前大多数使用 mysql5.7, 而且mysql8修改了挺多, 所以暂时使用mysql5.7

[dockerhub地址](https://hub.docker.com/_/mysql)

mysql 操作

建议命令行中 使用 mycli 工具管理

sql操作
```sql
-- 修改密码
-- mysqladmin -u -p password newpwd 
set password for 'xxx'@'%'=password('passwd');
grant all on xxx.* to 'root'@'%' identified by 'password' with grant option; 
-- 用户提权
GRANT all ON databasename.tablename TO 'username'@'host';
flush privileges;
```

存在的问题
1. mysql:8 设置 `MYSQL_ROOT_PASSWORD` 环境变量, 但mysql未将该值设置为root密码. 未花时间去验证
2. mysql:8 不支持 `set password ..` 语句
