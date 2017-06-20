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
        echo "  l) 列出 [$cdtitle] 上的所有曲目"
        echo "  r) 删除 [$cdtitle]"
        echo "  u) 更新 [$cdtitle] 上的曲目信息"
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

add_records(){
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

update_cd(){
    if [ -z "$cdcatnum" ]; then
        echo "请输入CD编号"
        find_cd n
    fi

    if [ -n "$cdcatnum" ]; then
        echo "$cdcatnum 的曲目表:"
        list_tracks
        echo
        echo "为 $cdtitle 重新设置曲目表:"
        confirm && {
            grep -v "^${cdcatnum}," $tracks_file > $temp_file
            mv $temp_file $tracks_file
            echo
            add_record_tracks
        }
    fi
    return
}

list_tracks(){
    if [ "$cdcatnum" = "" ];then
        echo "没有输入CD编号"
        return
    else
       grep "^${cdcatnum}," $tracks_file > $temp_file
       num_tracks=$(wc -l $temp_file)
       if [ "$num_tracks" = "0" ];then
          echo " CD \"$cdtitle\"　没有曲目." 
       else {
          echo
          echo "$cdtitle:-"
          echo
          cut -f 2- -d , $temp_file
          echo
        } | ${PAGER:-more}
       fi
    fi
    pause
    return
}

count_cds(){
    set $(wc -l $title_file)
    num_titles=$1
    set $(wc -l $tracks_file)
    num_tracks=$1
    echo "发现$num_titles 张CD, 总共有 $num_tracks 首歌曲"
    confirm
    return
}

remove_records(){
    if [ -z "$cdcatnum" ];then
        echo "您必须先输入ＣＤ编号"
        find_cd n
    fi
    if [ -n "$cdcatnum" ];then
        echo "您正在删除CD $title"
        confirm && {
           grep -v "^${cdcatnum}," $title_file > $temp_file
           mv $temp_file $title_file
           grep -v "^${cdcatnum}," $tracks_file > $temp_file
           mv $temp_file $tracks_file
           cdcatnum=""
           echo "$cdcatnum 已删除"
        }
        pause
    fi 
}

rm -f $temp_file
if [ ! -f $title_file ]; then
    touch $title_file
fi

if [ ! -f $tracks_file ]; then
    touch $tracks_file
fi

clear
echo
echo
echo "Mini CD 管理器"
sleep 1

quit=n
while [ "$quit" != "y" ];
do
    set_menu_choice
    case "$menu_choice" in
        a ) add_records;;
        r ) remove_records;;
        f ) find_cd y;;
        u ) update_cd;;
        c ) count_cds;;
        l ) list_tracks;;
        b ) echo
           more $title_file
           echo
           pause;;
        q | Q ) quit=y;;
        * ) echo "不能识别的操作 $menu_choice ";;
    esac
done

rm -f $temp_file
echo "结束"
exit 0


