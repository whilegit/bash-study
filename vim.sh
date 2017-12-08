#!/bin/sh

######### 替换substitute ##########
# 替换当前行第一个
:s/AA\s\+BB/AABB/    # 匹配成Perl标准正则表达式为 AA\s+BB
:s/pattern/replace/ 
# 替换当前行全部
:s/AA BB/AABB/g
# 替换全文全部
:%s/AA BB/AABB/

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
\(  \) # 表示分组, 标准Perl正则是(和)



exit 0
