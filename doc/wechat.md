# wechat
我们知道, 微信没有开放聊天的API, 目前大部分相关实现基本都是基于web版实现的. 
如下是一些微信相关的接口, 自动化方法.

推荐一个仓库, ItChat, 一个开源的微信个人号接口, 基于Python.
[ItChat](https://github.com/littlecodersh/ItChat)

具体的使用暂不深究, 先做下如下备份.

具体使用参考 [API文档](https://github.com/littlecodersh/ItChat/blob/master/docs)

```Python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import itchat

# hotReload=True
itchat.auto_login(enableCmdQR=2)

itchat.add_friend(userName='15810007687')

mems = itchat.search_friends('XX')
grps = itchat.search_chatrooms('XXXX')

# mems 字典数组, 字典中需要包含 UserName 字段. 根据此字段查找
itchat.add_member_into_chatroom(grps[0].UserName, mems)

# 发送文字
itchat.send_msg('saz asd ', toUserName=grps[0].UserName)

# 注册消息, 接收消息然后回复
from itchat.content import *

@itchat.msg_register([TEXT], isGroupChat=True)
def text_reply(msg):
    msg.user.send('%s: %s' % (msg.type, msg.text))

itchat.run(True)
#itchat.logout()
```
