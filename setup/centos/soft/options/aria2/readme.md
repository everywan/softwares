参考 [aria2-ariang-x-docker-compose](https://github.com/wahyd4/aria2-ariang-x-docker-compose)

需要爱添加 `privileged: true` 是因为 centos 默认开启 selinux, docker 内无法操作外部文件. 而arch默认不开启selinx.

1. filebrower
  - url: ip:80
  - default user/password: admin/admin
2. aria
  - url: ip:80/ui
  - default user/pd: admin/adminadmin, 见配置
