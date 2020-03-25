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
