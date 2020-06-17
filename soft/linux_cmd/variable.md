# 变量定义

local: 定义局部变量

declare: declare有两种用法: 可以设置带属性的变量, 功能类似set. 也可以用来显示shell函数. declare 默认作用域同local
- `+/-`: - 表示给变量添加相应属性, + 表示取消变量的相应属性
- `-f`: 仅显示函数
- `r`: 只读变量
- `x`: 设置为环境变量
- `i`: 值类型限定为数值, 可用于计算

示例: `declare -r passwd=passwd`

export: 定义环境变量, 与local相比, 可以在子进程中使用.

declare/local 定义的变量只能在当前进程使用, export 定义的变量可以在子进程使用.

## 常见问题
如何在当前进程加载 env.sh 的环境变量?

使用 source, 且使用 export 定义变量. 使用 bash 执行时, 会在子进程创建变量,
当前进程仍读取不到 env 中设置的变量.

通常用于拆分环境变量到单独文件.

source: 在当前bash环境下读取并执行FileName中的命令.
