# wsl启用sshd

1. 启用wsl: 打开 powershell, 执行 `Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux`
2. 下载 ubuntu: `https://aka.ms/wsl-ubuntu-1804`. 推荐使用迅雷下载
3. ubuntu.appx 改名为 ubuntu.zip, 解压然后双击 exe 安装
4. 启用sshd
  - 停止系统自带的ssh服务: 打开 服务, 然后禁用 `OpenSSH...` 服务
  - 启用 wsl 的 ssh 服务: `sudo apt purge openssh-server; sudo apt install openssh-server`
  - 开放端口: 打开 `防火墙` -> 打开 `高级` -> 添加入站规则
5. sshd 添加开机自启

Q&A
1. windows 本身可能占用22端口, 此时 搜索 `_服务_ => 搜索 _SSH_`, 然后关闭即可.
2. 如果需要外网访问, 开通 ssh 接口即可