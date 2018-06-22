#!/bin/sh

## By default `sed` prints all processed input. Use -n to suppress output.  
## And the `p` command to print specific lines. 
## sed treats multiple input files as one long stream. 
sed -n '10p' file.txt                       # 打印 file.txt的第10行
sed -n '1p ; $p' one.txt two.txt three.txt  # 打印 one.txt的第1行, three.txt的最后一行


## 读入inputfile.txt，将所有的Search内容替换成Replacement，再输出至stdout 
## 以下三个命令等效
sed 's/Search/Replacement' inputfile.txt
sed 's/Search/Replacement' < inputfile.txt 
cat inputfile.txt | sed 's/Search/Replacement' - 


## 读入inputfile.txt, 将所有的Search内容替换成Replacement，再输出到outputfile.txt
## 以下三个命令等效
sed 's/Search/Replacement' inputfile.txt > outputfile.txt
sed 's/Search/Replacement' < inputfile.txt > outputfile.txt
cat inputfile.txt | sed 's/hello/world/' - > outputfile.txt


## Use -i to edit files in-place instead of printing to standard output. 
## The following command modifies `file.txt` and does not produce any output.
sed -i 's/Search/Replace' file.txt


## 按行正则匹配 /Search:.*/ 并替换成 /Replace:\"$val\"/
sed -i "s/Search:.*/Replace:\"$val\"/" file.txt

