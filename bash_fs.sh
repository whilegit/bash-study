#!/bin/sh

## 查看当前磁盘信息
fdisk -l # 获取当前机器的磁盘信息,若新磁盘未挂载则此处不会显示
df -h    # 该命令同时显示磁盘的使用情况

## 对数据盘进行分区
fdisk -S 56 /dev/vdb # 之后依次输入n,p,1,两次回车,wq,就可完成.

## mkfs.ext4 执行格式化
mkfs.ext4 /dev/vdb1

## /etc/fstab　自动挂载配置文件
# 该文件可读可写,新记录保存后下次启动时就会自动挂载. 
/dev/vdb1 /var/wwwroot ext4 defaults 0 0
# 第一列: 磁盘设备文件或该设备的Label或uuid
# 第二列: 挂载点
# 第三列: 文件系统
# 第四列: 挂载参数,默认值defaults表示　r/w, dev,exec,auto,nouser,async等
# 第五列: 能否被dump备份命令作用(?)
# 第六列: 是否检查扇区,一般根目录设为1

## /etc/mtab 已挂载信息表
# 该文件记录当前已挂载的文件信息,每次mount/unmount命令后,都会修改此文件的相关内容.

## 临时挂载和卸载
mount /dev/xxx /dest/dir # 第一次参数是设备号,第二个参数为目标目录(挂载点)
unmount -v /dev/xxx      # 通过设备号卸载, -v参数表示显示过程
unmount -v /dest/dir     # 通过挂载点卸载

