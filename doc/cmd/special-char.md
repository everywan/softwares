# Bash中的特殊字符

https://linux.cn/article-5657-1.html

| 符号   | 使用方法                          | 示例                    | 备注                                          |
| :----- | :-------                          | :--------               | :--                                           |
| `#`    | 注释符号                          | `#!/bin/bash`           |                                               |
| `#!`   | [Shebang](#Shebang)               | `#!/usr/bin/env python` |                                               |
| `;`    |                                   | ``                      |                                               |
| `.`    | 相当于source, 表示在当前shell执行 | ``                      | 参考[脚本执行的四种方式](#脚本执行的四种方式) |

## Shebang
Shebang(也称Hashbang), 出现在文本文件的第一行的前两个字符. 当文件中存在 Shebang, 类Unix操作系统的程序加载器会分析Shebang后的内容, 并将这些内容作为解释器指令并且调用执行. 注意, 在其他语言中`#`只被认为注释并且自动忽略(如Python), 只有在类Unix系统中才会被识别.

用法: `#!/usr/bin/python`: 使用 `/usr/bin/python` 来执行当前文件后续代码 . `#!/usr/bin/env python`: 让程序自动查找当前系统中python的路径, 并使用此程序执行代码. 前一个示例的优化版.

参考: [Shebang-wiki](https://zh.wikipedia.org/wiki/Shebang)
