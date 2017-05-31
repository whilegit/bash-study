#! /bin/sh

echo 请输入密码 
read pass

while [ "$pass" != 123456 ]
do
   echo 密码不正确，请重新输入
   read pass
done
echo 密码正确

foo=1
while [ "$foo" -le 20 ]
do
   echo 第 $foo 次执行while-do-done 
   foo=$(($foo+1))
done

exit 0
