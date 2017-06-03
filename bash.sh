#! /bin/sh

### 变量的赋值
# 赋值(bash里的变量默认为字符串类型)
var="some thing"

### 打印命令
# echo 命令,加上参数-n将去掉换行符
echo [-n] some thing 
echo "变量val=$val"   # 变量val=some thing
echo "变量val=\$val"  # 变量val=$val
echo '变量val=$val'   # 变量val=$val
# printf 命令
printf "%s\n%s" Hello Pringf

### 参数
echo $0 # 当前程序名
echo $1 # 表示第一个参数, $2,$3...依次类推
echo $* # 表示所有参数,并以环境变量IFS字符串的第一个字符隔开
echo $@ # 表示所有参数,如果IFS第一个字符为空格,此时为适当整,比$*智能一些 
echo $HOME # 环境变量HOME
shift # 移动参数,将$2移到$1, $3移到$2, 依次类推,丢弃$1, 保留$0

### shell交互时读取输入
read val  # 将输入存入val变量中,如果直接按下回车键, val将读取到""空值,测试时应该用双引号括起来

### 变量求值
foo=1
foo=$(($foo+1)) 等效于 foo=`($foo+1)`

# if语句.其中then语句可以移到条件那一行,如 if condition;then
if condition
then
   statements
elif condition
then
   statements
else
   statements
fi 

### 循环语句
# while语句
while condition
do
   statements
done

# until语句
until condition
do
   statements
done

# for语句, 可以变形为for val in zhangsan lisi wangwu;do
for val in zhangsan lisi wangwu
do
   echo $val
done

# break, continue语句
# 循环体while,until,for内可以使用break,continue中断循环
# break和continue后面都可以加一个数字,表示跳出的层数

# case语句,支持[]范围和*匹配
case "$val" in
   y ) statements;;
   n*) statements;;
   [Aa] ) statements;;
   B*|b* ) statements;;
   * ) 
      statements
      ;;
esac

### 条件测试(在*nix的sh中,返回值为0表示true, 其它值表示false) 
test 或 [---] # 表示boolean测试,即true/false
[ "$val" = "Some thing" ] # 表示变量$val的值是否为Some thing
[ -f file ]   # 表示常规文件file是否存在 
[ $foo -le 20 ] # 表示小于等于20
|| #表示condition 条件或,任一或语句返回0表示真,注:所有bash命令都是合法的语句
&& #表示condition 条件与,所有与语句返回0表示真


### 杂项
| # 管道
> # 重定向
command > /dev/null　＃舍弃输出
: # 表示空语句,相当于汇编的nop, 可用于流程控制结构里的语句占位

# 执行某个外部的bash文件,注意:新调用的脚本将在当前shell的上下文中运行,也就是会改变环境变量
. # 相当于source命令
source xxxx.sh  

# 导出环境变量,该环境变量将在本shell的所有子进程或子shell可见
export val="Some new Content"
export val

### 函数的定义和调用
func_name(){
  local val="xxxx" # 如果val为早已是全局变量,此处local申请将暂时屏蔽全局变量 
  statements
  return 0 # 如没有return语句,将返回最后一条语句的返回值
}
# 调用函数,直接列出函数名即可
func_name
# 如有参数,列表名称后面,在函数内部通过$*,$1,$2等获取所传递的参数
funct_name $param1 $param2 ...

exit 0

