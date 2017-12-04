#!/bin/sh

## Linux 定时任务 crontab
# 相关文件 执行命令 ( ls -la /etc | grep cron)
# /etc/cron.deny 表示楚止使用的user列表,即黑名单
# /etc/cron.allow 表示允许使用的user列表,即白名单
# /var/spool/cron 存放的具体任务,每用户一个文件,但最好不要直接操作该文件.

##显示当前计划
crontab -u USERNAME -l # 可以省去 -u USERNAME 


## 增加任务
# 编辑当前用户的cron计划,调用本命令后打开一个文件编辑器,保存命令后即可更新至
#     /var/spool/cron相关的文件里,并立即生效.若存在错误,则不允许保存.
# 如果缺省-u USERNAME,则默认当前用户
crontab -u USERNAME -e 

## 任务格式
m h d M w command
#第一部分 m 表示分钟,取值[0,59] 
#第二部分 h 表示小时,取值[0,23]
#第三部分 d 表示日期,取值[1,31]
#第四部分 M 表示月份,取值[1,12]
#第五部分 w 表示星期,取值[0,7],其中0和7都表示周日.
#           也可使用sun,mon,tue,wed,thu,fri,sat
#第六部分 是 bash命令

## 任务格式的第1至第5部分可以使用以下格式.
# 通配符 * 表示该部分可以任意值
# 逗号,表示一个列表范围,并列关系
# 连接符-表示整数区间,即2-6表示2,3,4,5,6
# 斜杠/表示时间频率,小时字段设置成0-23/2或*/2表示每两小时执行一次

## 删除全部任务
crontab -u USERNAME -r # 将删除整个文件,要作好备份工作


exit 0

