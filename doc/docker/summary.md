1. 分层结构
2. docker 守护进程

3. 工作流程
从 [docker官方文档](https://github.com/yeasy/docker_practice/blob/master/container/run.md) 中可以看到, 创建一个容器的流程为：

- 检查本地是否存在指定的镜像, 不存在就从公有仓库下载
- 利用镜像创建并启动一个容器
- 分配一个文件系统, 并在只读的镜像层外面挂载一层可读写层
- 从宿主主机配置的网桥接口中桥接一个虚拟接口到容器中去
- 从地址池配置一个 ip 地址给容器
- 执行用户指定的应用程序
- 执行完毕后容器被终止

所以, 作者认为, 每次重启docker容器时, ip地址都会释放-获取, 所以hosts文件每次都会被重置. 

4. 参考资料
- [官方文档](https://www.gitbook.com/book/yeasy/docker_practice/details) .
