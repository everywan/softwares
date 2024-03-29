# Bash 编程

## 常用语法
1. `:` 什么都不做, 但执行后会返回一个正确的退出代码. (类似Python中的 `pass`, 函数占位符的作用)
    ```Bash
    if [ "$i" -ne 1 ];then
        :
    elif
        [ "$i" -ne 2 ]
    else
        echo "$i is not equal 1 2"
    fi
    ```
1. `()`: 将多个命令组合在一起执行, 相当于一个命令组
1. `{}`: 与`()`类似, `()`是在产生的子shell下执行，而`{}`是在当前的shell下执行
    - `(A=abc;echo $A);echo $A`
1. `[]`: 用于比较值以及检查文件类型
    - `[ "$A" -eq 123 ]`: 测试 `$A` ?= 123
1. `[[]]`: 将多个 `[]` 支持的测试组合起来
    - `[[ "$A" -eq 123 ] && [ "$B" -eq 234 ]]`
1. `(())`: 专门来做数值运算, 只能对整数操作
    - `((i=1+99));echo $i`: 输出100
    - `echo $((10**2))`: 输出100
1. 注意: 使用 `(())` 时，不需要空格分隔各值和运算符，使用`[]`和`[[]]` 时需要用空格分隔各值和运算符
2. eq/ne 表示数字运算的 等于/不等于, 字符串使用 `==`

set 命令
http://www.ruanyifeng.com/blog/2017/11/bash-set.html
  
### 脚本调试
> 使用 `set -x/+x` 嵌套代码段  
> 通常使用 [重定向](/OS/Linux/summary.md#重定向) 配合来查看错误日志

```Bash
# At Begin: 开启调试模式(把脚本运行过程打印出来)
set -x
..code..
# At End:关闭调试模式
set +x
```
调用脚本时, 将输出信息重定向
```Bash
.tt.sh 1 > ~/tt.log
```

### 变量声明
1. local: 只能用于shell函数, 声明局部变量, 只对当前函数或其子进程有效. 选项option可以是内建命令declare的选项
2. declare: 声明变量, 并且可以设置属性(即变量类型): `-a` 数组, `-i` 整数, ...
3. 数组声明: `citys=(bj xa tj)`， 取指定下标的值 `${citys[i]}`
    - `@/*`可以取数组所有元素, `${citys[@]}`, `#`可以查询长度 `${#citys[@]}`

### 函数定义/使用
1. function: bash中的 func 不用定义参数(与其他语言不同), 直接 `$i` 调用即可. 示例如下, 会输出HelloWorld
    ```Bash
    function show() {echo " $1";}
    show HelloWorld
    ```
    
## Code
1. [打包第N层目录_Bash](/example/zip_file.md)
