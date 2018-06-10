#!/bin/sh
#
# chkconfig: 3 20 80
# description: Starts and stops the nginx server

# Source function library. 
# This file contains functions to be used by most or all shell scripts in the /etc/init.d direcory. (见 /etc/init.d/functions)
if [ -f /etc/init.d/functions ] ; then
    . /etc/init.d/functions
elif [ -f /etc/rc.d/init.d/functions ] ; then
    . /etc/rc.d/init.d/functions
else
    exit 1
fi

# Avoid using root's TMPDIR
unset TMPDIR

RETVAL=0
BINFILE=/data/bin/nginx-1.11.4/sbin/nginx
PIDFILE=/data/bin/nginx-1.11.4/nginx.pid
CFGFILE=/data/bin/nginx-1.11.4/conf/nginx.conf
KIND=nginx

start() {
    echo -n $"Starting $KIND services: "
    $BINFILE
    RETVAL=$?  # 获取nginx启动过程的退出码,为0表示启动正确
    success
    echo
    [ $RETVAL -eq 0 ]
        RETVAL=1
    return $RETVAL
}

stop() {
    echo -n $"Shutting down $KIND services: "
    kill -QUIT `cat $PIDFILE`  # 先执行命令cat $PIDFILE并捕获其输出(pid)，再执行kill命令
    RETVAL=$?
    success
    echo
    [ $RETVAL -eq 0 ] && rm -f $PIDFILE  # 一并删掉 nginx.pid 文件
    return $RETVAL
}

restart() {
    stop
    start
}

reload() {
    echo -n $"Reloading $CFGFILE: " 
    kill -HUP `cat $PIDFILE` # 给nginx主进程 master 传递 -HUP中断信号，让其重新载入配置文件
    RETVAL=$?
    success
    echo
    return $RETVAL
}

configtest() {
    $BINFILE -t  # -t参数用于测试nginx.conf文件的正确性
    RETVAL=$?
    if [ $RETVAL -eq 0 ]; then
        echo Syntax OK
        return $RETVAL
    fi
    return $RETVAL
}

status() {
    if [ ! -r $PIDFILE ]; then  # 当 nginx.pid 文件不可读时，表示nginx已退出运行
        echo "nginx is stopped"
        exit 0
    fi

    PID=`cat $PIDFILE`
    if ps -p $PID | grep -q $PID; then  # 检查 PID 所指的进程是否存在, ps -p或ps -q只是列出进程
        echo "nginx (pid $PID) is running..."
    else
        echo "nginx dead but pid file exists"
    fi
}

# Check that we can write to it... so non-root users stop here
[ -w $BINFILE ] || exit 4  # 检查用户对 #BINFILE文件的可写性，若不可写时表明非ROOT用户，则直接退出而不真正执行脚本。

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    reload)
        reload
        ;;
    configtest)
        configtest
        ;;
    status)
        status
        ;;
    *)
        echo $"Usage: $0 {start|stop|restart|reload|status|configtest}"
        exit 2
esac

