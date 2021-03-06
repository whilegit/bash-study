#! /bin/sh
STATAS='start'
trap "echo Exiting: critical variable = \$STATUS" EXIT

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
echo $# # 表示参数个数
echo $$ # 表示当前的shell的进程号
echo $? # 上一个命令的退出码,适用sh里调用子命令获取其退出码
echo $HOME # 环境变量HOME
shift # 移动参数,将$2移到$1, $3移到$2, 依次类推,丢弃$1, 保留$0

### set命令
# 设置参数列表
set param1 param2 param3 #设置后,$1\$2\$3等将被分别设置为param1\param2\param3,用于提取某些输出域
set $(date)              # $(date)捕获的返回值将被设置进入$1,$2...$n

### shell交互时读取输入
read val  # 将输入存入val变量中,如果直接按下回车键, val将读取到""空值,测试时应该用双引号括起来
read -p "something to prompt user" val    # 提示用户输入内容，并赋值给变量val

### 变量求值
foo=1
foo=$(($foo+1)) # 算术扩展 

### 参数扩展
for i in 1 2
do
    my_func ${i}_tmp # ${i}表示参数扩展,循环时将获得1_tmp和2_tmp的参数值
done
# 还有${param:-default}指定缺省值($param不赋值),${param:=defaultxx}指定缺省值并赋值, ${#param}获得param的长度,
#     ${param%word}尾部最小截取, ${param%%word}尾部最大截取,　${param#word}头部最小截取, ${param##word}头部最大截取 注:word可以使用?*作为通配符

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
[ -r file ]   # 表示文件或目录存在且为可读时，返回true
[ -e file ]   # 表示文件或目录存在时，返回true
[ $foo -le 20 ] # 表示小于等于20
[ -z $str ]   # 当$str为空的字符串时，返回true
|| #表示condition 条件或,任一或语句返回0表示真,注:所有bash命令都是合法的语句
&& #表示condition 条件与,所有与语句返回0表示真

### 杂项
command | command    # 管道
# 输出重定向到文件,如果文件不存在则创建文件,如果文件已存在则清空文件
command > file_path  
command >> file_path # 如果文件已存在则append到末尾
# 标准输出stdout(1)重定向至file_path,标准错误stderr(2)重定向至stdout,不要忘了&符号
command > file_path 2>&1 
command > /dev/null  ＃舍弃输出
command < file_path  # 文件作为标准输入设备 如: read val < path_file
command <<< "$val"   # 将$val内容先送入stdin，再传给命令.如cat,grep等输入文件作为参数时有用
wc -l file_path      # 统计文件的行数,　-c为统计字数, -w为统计单词数
cut -d , -f 2- file_path  # 提取数据文本, -d指明文本中的分隔符, -f指明提取哪些字段

: # 表示空语句,相当于汇编的nop, 可用于流程控制结构里的语句占位
eval statement #执行后面字符串拼接的语句
exec statement #执行语句,而后退当前执行的脚本
expr expressing #计算后面的表达式,并echo表达式的执行结果,通常以val=$(expr EXPRESSION)的面目出现
val=$(statement) # 捕获输出
val=`statement` #捕获statement的输出,并赋值val，同val=$(statement)
# 执行某个外部的bash文件,注意:新调用的脚本将在当前shell的上下文中运行,也就是会改变环境变量
. # 相当于source命令
source xxxx.sh  

# 脚本信号处理(中断处理语句)
trap 'command' SIGNAL # 在SIGNAL信号到来时,执行command语句
trap SIGNAL           # 在SIGNAL信号到来时,执行空命令(实质上是忽略该信号"
trap - SIGNAL         # 恢复SIGNAL默认的处理方法
trap -l或kill -l      # 查看所有支持的信号符号
# 导出环境变量,该环境变量将在本shell的所有子进程或子shell可见
export val="Some new Content"
export val
# 删除变量或函数
unset val

### 函数的定义和调用(注意:Bash的函数概令与Ｃ的函数不同,有点像内联过程)
func_name(){
  local val="xxxx" # 如果val为早已是全局变量,此处local申请将暂时屏蔽全局变量 
  val2="xxxx"      # 创设或修改全局空间的val2变量.如外部之前未定义,此时外部也能够访问,因此可以作为返回结果的载体
  statements
  echo $result     # 输出一些东西,可能使用$()方式捕捉
  return 0 # 如没有return语句,将返回最后一条语句的返回值
}
# 调用函数,直接列出函数名即可
func_name
# 如有参数,列表名称后面,在函数内部通过$*,$1,$2等获取所传递的参数
funct_name $param1 $param2 ...
# 捕捉函数的标准输出作为返回值
val=$(func_name)

### here 文档(脚本内模拟读取文件)
cat << herexxxx
just
like 
in 
file
herexxxx

### 调试脚本
sh -n <script>   或    set -o noexec     或    set -n  # 不执行脚本,只检查语法
sh -v <script>   或    set -o verbose    或    set -v  # 在执行命令前回显它们
sh -x <script>   或    set -o xtrace     或    set -x  # 在处理完命令后回显它们
                       set -o nounset    或    set -u  # 如果使用了未定义变量,就给出错误消息
                       set +o xtrace  # 取消设置执行后回显
                       set +o nounset # 取消未定义变量错误
                       set +o verbose # 取消执行前回显
exit 0

