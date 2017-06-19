#!/bin/sh

# 函数: 按任意键继续
pause(){
    echo -e "按下任意键继续... \c"
    read x
    return 0
}

# 函数: 确认操作
confirm(){
    echo -e "确定吗?(y确定,n取消)　\c"
    while true
    do
        read x
        case "$x" in
            y | yes | Y | Yes | YES ) return 0;;
            n | no | N | No | NO )
               echo "已取消"
               return 1;;
            * ) echo "请输入y或n";;
        esac
    done
}

menu_choice=""
title_file="title.tmp"
tracks_file="tracks.tmp"
temp_file=/tmp/cdb.$$

set_menu_choice(){
    clear
    echo " 菜单 : -"
    echo
    echo "  a) 增加一张ＣＤ"
    echo "  f) 查找ＣＤ"
    echo "  c) 统计ＣＤ和曲目数量"
    if [ "$cdcatnum" != "" ];then
        echo "  1) 列出 [$cdtitle] 上的所有曲目"
        echo "  2) 删除 [$cdtitle]"
        echo "  3) 更新 [$cdtitle] 上的曲目信息"
    fi
    echo "  q) 退出"
    echo
    echo -e "请输入选项,然后按下回车键 \c"
    read menu_choice
    return 
}

insert_title(){
    echo $* >> $title_file
    return
}

insert_track(){
    echo $* >> $tracks_file
    return
}

add_record_tracks(){
    echo "当前CD $cdtitle, 请输入曲目"
    echo "当前CD没有更多曲目后,输入q返回"
    cdtrack=1
    cdttitle=""
    while [ "$cdttitle" != "q" ]
    do
        echo -e "输入曲目名称: \c"
        read tmp
        cdttitle=${tmp%%,*}
        if [ "$tmp" != "$cdttitle" ];then
            echo "曲目标题不可以含有逗号,请重新输入."
            continue
        fi
        if [ -n "$cdttitle" ];then
            if [ "$cdttitle" != "q" ];then
                insert_track $cdcatnum,$cdtrack,$cdttitle
            fi
        else
            cdtrack=$((cdtrack-1))
        fi
        cdtrack=$((cdtrack+1))
    done
}

add_record(){
    echo -e "输入CD编号: \c"
    read tmp
    cdcatnum=${tmp%%,*}

    echo -e "输入CD名称: \c"
    read tmp
    cdtitle=${tmp%%,*}

    echo -e "输入CD类型: \c"
    read tmp
    cdtype=${tmp%%,*}

    echo -e "输入歌手/作曲家: \c"
    read tmp
    cdac=${tmp%%,*}

    echo "准备添加CD到库中"
    echo "$cdcatnum $cdtitle $cdtype $cdac"

    if confirm ;then
        insert_title $cdcatnum,$cdtitle,$cdtype,$cdac
        add_record_tracks
    else
        remove_records
    fi

    return
}

find_cd(){
    if [ "$1" = "n" ]; then
        asklist=n
    else
        asklist=y
    fi

    cdcatnum=""
    echo -e "请输入要搜索的ＣＤ名称: \c"
    read searchstr
    if [ "$searchstr" = "" ];then
        return 0
    fi

    grep "$searchstr" $title_file > $temp_file

    set $(wc -l $temp_file)
    linesfound=1

    case "$linesfound" in
        0 ) echo "对不起,没有找到."
            pause
            return 0
            ;;
        1 ) ;;
        2 ) echo "对不起,数据文件中存在同名的多张ＣＤ!"
            echo "列表如下"
            cat $temp_file
            pause
            return 0
    esac

    IFS=","
    read cdcatnum cdtitle cdtype cdac < $temp_file
    IFS=" "
    if [ -z "$cdcatnum" ]; then
        echo "对不起,读取ＣＤ目录失败"
        pause
        return 0
    fi

    echo 
    echo CD目录编号: $cdcatnum
    echo CD名称: $cdtitle
    echo CD类型: $cdtype
    echo CD作曲家: $cdac
    echo
    pause
    if [ "$asklist" = "y" ]; then
        echo -e "是否要查看该ＣＤ的曲目列表? \c"
        read x
        if [ "$x" = "y" ]; then
            echo
            list_tracks
            echo
        fi
    fi
    return 1
}


add_record
add_record

find_cd y


exit 0





















