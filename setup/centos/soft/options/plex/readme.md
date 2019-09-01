参见 https://github.com/linuxserver/docker-plex

注意检查防火墙是否开通32400端口, centos 默认开启 firewalld 服务.

1. 下载安卓端软件
  - 直接从 google play 下载
  - 未安装google play: https://plex-for-android.en.uptodown.com/android
2. tv 端配置
  - 找不到服务器: 需要关闭服务端的 https 认证. 在 `setting/network/` 下
