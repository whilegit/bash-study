#!/bin/sh

## nginx启动后,可以接收几个命令
nginx -s stop # fast shutdown 立即停止
nginx -s quit # graceful shutdown 平稳关闭,各worker手头的请求会处理完
nginx -s reload # 重新加载配置　




exit 0
