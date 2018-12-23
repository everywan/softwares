`startx`: 启动 Xserver 与 Xclient

`sudo X`: 启动 X 服务器, 默认端口6000, 第0个服务器.
- 格式: `sudo X :a.b`, a表示端口, 从6000开始. 如 :0=>6000, :1=>6001. b暂且无用处

客户端直接执行: `termite --display localhost:0`. termite 表示要执行的软件, localhost 可省略, 0表示监听6000端口的xserver.

或者导入 DISPLAY 环境变量, xclient 会自动读取. `export DISPLAY=xxx.xxx.xxx.xxx:0.0`

对于win, 需要开通6000端口, 或者通过端口转发映射6000端口.
