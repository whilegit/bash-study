#!/bin/sh

## umask, 用于创建文件时提供默认的文件mode(即文件权限表)
## 不仅是shell脚本, 对于Ｃ程序创建的文件也适用
umask        # 返回当前用户的掩码. 如002表示-------w-,即掩掉其它用户的写权限
umask 022    # 设置当前用户的掩码

## time工具,用于测算应用程序运行的时间
time ./command
TIMEFORMAT="" time ./command  # 加上TIMEFORMAT环境变量,让time输出ＣＰＵ使用率
