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

# for语句, 可以变形为for val in zhangsan lisi wangwu;do
for val in zhangsan lisi wangwu
do
   echo $val
done

### 条件测试(在*nix的sh中,返回值为0表示true, 其它值表示false) 
test 或 [---] # 表示boolean测试,即true/false
[ "$val" = "Some thing" ] # 表示变量$val的值是否为Some thing
[ -f file ]   # 表示常规文件file是否存在 


exit 0

