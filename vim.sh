#!/bin/sh

######## 搜索 search ##############
:/pattern   # 向下搜索,n下一个,N上一个
:?pattern   # 向上搜索,n上一个,N下一个

######### 替换substitute ##########
# 替换当前行第一个
:s/AA\s\+BB/AABB/    # 匹配成Perl标准正则表达式为 AA\s+BB
:s/pattern/replace/ 
# 替换当前行全部
:s/AA BB/AABB/g
# 替换全文每行的第一个匹配
:%s/AA BB/AABB/
# 替换全文全部
:%s/AA BB/AABB/g

# 元字一览表(特别注意与标准Perl正则的区别)
.  [abc] [a-z0-9] [^abc] \t \s \S 
\d [0-9]  \D [^0-9]  # 数字字符相关
\x [0-9A-Fa-f]   \X [^0-9A-Fa-f]  # 十六进制字符相关
\w [0-9A-Za-z_]  \W [^0-9A-Za-z_] 

*      # 匹配 0-任意个
\+     # 匹配 1-任意个(标准Perl正则不需要加\号)
\?     # 匹配 0-1个(标准Perl正则不需要加\号)
\{n,m} # 匹配 n-m个(标准Perl正则不需要加\号)
\{n} \{n,} \{,m} # 略 

$^ # 匹配行尾和行首
\< # 匹配单词词首, 标准Perl正则是\b
\> # 匹配单词词尾, 标准Perl正则仍是\b
\(  \) # 表示分组和捕获, 标准Perl正则没有反斜杠. \1代表第一个捕获,\n表示第n个捕获

## 正则替换示例
:%s/\s\(\d\+\)/(\1/g  # 全文替换形如 23) 样式的标记为  (23)

########### 窗口相关 ##############
:sp FILENAME  # 横向打开文件(上下分割)
:vsp FILENAME # 纵向打开文件(左右分割)
ctrl+w+j/k # 上下切换窗口
ctrl + w   # 快速双击依次切换窗口
:res NUM   # 设置行数
:res +NUM  # 增加行数
:res -NUM  # 减少行数
:vertical res NUM   # 设置列数
:vertical res +NUM  # 增加列数
:vertical res -NUM  # 减少列数

########### 配置相关 ##############
# 显示行号,可直接在编辑器里输入，也可以放到vimrc配置文件里
set number


exit 0
