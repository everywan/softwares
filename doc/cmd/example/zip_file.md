# 打包第N层目录_Bash
## 技术点
1. bash 使用 if 的语法如下
    ````
    if []
    then
        code ...
    else
        code ...
    fi
    ````
    - 如果结构是 `if [] codeA... then codeB... fi` , 那么if语句会失效, 即不论判断是否正确都会执行 codeA 和 codeB
2. local: 只能用于shell函数, 声明局部变量, 只对当前函数或其子进程有效. 选项option可以是内建命令declare的选项
    - declare: 声明变量, 并且可以设置属性(即变量类型): `-a` 数组, `-i` 整数, ...
3. function: bash中的 func 不用定义参数(与其他语言不同), 直接 `$i` 调用即可. 示例如下, 会输出HelloWorld
    ````
    function show() {echo " $1";}
    show HelloWorld
    ````
4. `:` 什么都不做, 但执行后会返回一个正确的退出代码. (类似Python中的 `pass`, 函数占位符的作用)
    ````
    if [ "$i" -ne 1 ];then
        :
    else
        echo "$i is not equal 1"
    fi
    ````
5. 使用 `(())` 时，不需要空格分隔各值和运算符，使用`[]`和`[[]]` 时需要用空格分隔各值和运算符
6. `()`: 将多个命令组合在一起执行, 相当于一个命令组
7. `{}`: 与`()`类似, `()`是在产生的子shell下执行，而`{}`是在当前的shell下执行
    - `(A=abc;echo $A);echo $A`
8. `[]`: 用于比较值以及检查文件类型
    - `[ "$A" -eq 123 ]`: 测试 `$A` ?= 123
9. `[[]]`: 将多个 `[]` 支持的测试组合起来
    - `[[ "$A" -eq 123 ] && [ "$B" -eq 234 ]]`
10. `(())`: 专门来做数值运算, 只能对整数操作
    - `((i=1+99));echo $i`: 输出100
    - `echo $((10**2))`: 输出100

## 代码
目的: 压缩 `目录/tmp/111/222/333/444/` 下所有目录

````
#!/bin/bash
function scandir() {
    local cur_dir parent_dir workdir
    workdir=$1
    cd ${workdir}
 
    if [ ${workdir} = "/" ]
    then
        cur_dir=""
    else
        cur_dir=$(pwd)
    fi

   for dirlist in $(ls ${cur_dir})
   do
       if test -d ${dirlist}
       then
           cd ${dirlist}

           if [ $2 -ge  5 ]
           then
              cd ..
              zip -r ${dirlist}.zip  ${dirlist}
              echo  ${cur_dir}/${dirlist}
			  rm -rf ${dirlist}
           else
              scandir ${cur_dir}/${dirlist}  $(($2+1))
              cd .. 
           fi
       fi
   done
}

# 调用函数
scandir /tmp/111 1
````

### Warning
1. 如果没有 `if test -d ${dirlist}` 或者 `if test -d ${dirlist}`判断失效, 碰巧 某个目录下又有大于层级深度的文件个数, 则会出现一个恐怖的结果: `rm -rf /`. 
1. 测试目录结构, 代码如下
````
# 目录结构如下
- /tmp/111
    - 222
        - 333
            - 444
                - 555
                    - 666
                        - 777
                - aa.zip
                - aa.zip2
                - aa.zip22
                - aa.zip222
                - aa.zip2222
                - aa.zip22222
                - aa.zip222222

# 测试代码如下

#!/bin/bash
function scandir() {
    local cur_dir parent_dir workdir
    workdir=$1
    cd ${workdir}
 
    if [ ${workdir} = "/" ]
    then
        cur_dir=""
    else
        cur_dir=$(pwd)
    fi

   for dirlist in $(ls ${cur_dir})
   do
       if test -d ${dirlist}
       # 注意此行, 使 if 失效了
       echo ${dirlist}
       then
           cd ${dirlist}

           if [ $2 -ge  5 ]
           then
                cd ..
                # zip -r ${dirlist}.zip  ${dirlist}
                echo  ${cur_dir}/${dirlist}
                # rm -rf ${dirlist}
           else
                # 执行 scandir 时传入的路径
                # 0. /tmp/111/222/333/444/555 (执行scandir后)--> /tmp/111/222/333/444/555 (执行cd ..后)--> /tmp/111/222/333/444
                # 1. /tmp/111/222/333/444/aa.zip (执行scandir后)--> 
                    # A: 无rm时: 回到0, 陷入循环.
                    # B: 有rm时, 会一直递归到 `$2 ge 5`,由于$1是文件, 每一次for循环都会使then之后的cd ..到上一层目录;`/tmp/111/222/333/444`下有多少个文件,向上多少层(假设有很多文件,从而cd到根目录了).
                        # (执行cd ..后)--> 当前在根目录
                    # 问题: `for dirlist in $(ls ${cur_dir})` 循环时新加文件,是否会遍历新加的文件
                # 2. /tmp/111/222/333/444/aa.zip2 (执行scandir后)--> 由于 `${workdir}=/tmp/111/222/333/444/aa.zip2`, 所以 `cur_dir==$(pwd)==/`, 所以开始遍历根目录
                scandir ${cur_dir}/${dirlist}  $(($2+1))
                cd .. 
           fi
       fi
   done
}

# 调用函数
scandir /tmp/111 1
````