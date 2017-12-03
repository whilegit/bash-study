#!/bin/sh

#### grep(非Bash命令, General Regular Expression Parser)
grep something filepath  # 在filepath文件中搜索something文本
grep -c something filepath1 filepath2  # 在filepath1和filepath2中搜索something, -c输出匹配行数目而不输出匹配行
grep -v something filepath1  # 在filepath1搜索不匹配行
grep ^someth.n[ab]$ filepath  # 符号^.[]$为可以使用的特殊字符
grep -E [[:alpha:]]\{10\} filepath  # 启用正则扩展(稍微复杂一些的正则),命令egrep等效于grep -E
grep [[:alnum:]]ab filepath # [:alnum:] 匹配alpha和number
     # [:alpha:] 字母　[:ascii:] [:blank:]空格或制表符  [:cntrl:]ascii码控制符  
     # [:digit:] [:graph:]非制制非空格　[:lower:]  [:print:] [:punct:]标点 [:space:]空白字符 [:upper:] [:xdigit:]十六进制数字

exit 0
