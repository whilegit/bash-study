#!/bin/sh；

## 初次运行git前的配置
# /etc/gitconfig 文件：放置系统级的配置信息，对所有用户有效
#    --system 选项，读写的就是这个文件
# ～/.gitconfig 文件：放置当前用户级的配置信息，只对当前用户有效
#    --global 选项，读写的就是这个文件
# .git/config文件位于当前项目目录下，只对当前项目有效

# 优先级 .git/config  >  ~/.gitconfig    >    /etc/gitconfig
# 高优先级的覆盖低优先级的配置 
git config --global user.name "Linzhongren"
git config --global user.email "6215714@qq.com"

# 配置默认的编辑
git config --global core.editor vim

# git色彩支持
git config --global color.ui true

# 差异分析工具
git config --global merge.tool vimdiff

### 查看配置信息
# 列出所有的配置信息 【有重复时以最后为准】
git config --list 
# 列出global级的配置
git config --global --list
# 查看当前某个有效的环境变量
git config user.name

### 初始化一个版本库repository
git init

### 添加待修改的文件到版本库(告诉git这些文件是要提交的)
# 生成文件快照，放入暂存区。只有暂存区的文件才能提交到版本库。
git add file1
git add file2 file3
git add -A # 添加所有文件

### 提交(把修改内容提交到repository中,多次add，一次提交)
# 将暂存区的所有文件提交到版本库
git commit -m "写下提交说明"

### 查看repository状态
git status

### git 文件的三种状态
# Untracked files: 未跟踪的文件
# Changes not staged for commit: 文件已修改，未达提交状态
# Changes to be committed: 文件可提交,commit

### 比较文件差异
git diff
# 比较某个工作区文件和暂存区文件(如果暂存区没有快照,则比较最近一次提交)则比较最近一次提交)的差别
git diff file_name 
# 比较暂存区和HEAD的差异
git diff --cached file_name
# 比较两次提交commit的差异
git diff --stat -p commit1..commit2   # --stat表示列表统计信息(即改了哪些文件) -p列表具体差异, 比较范围一端可以省略(替代为HEAD)

###查看全部版本记录
git log
# 查看最近几个版本记录
git log -3
# 查看版本变更统计信息
git log --stat
# 查看版本变更详细
git log -p
# 查看分支图
git log --graph --pretty=oneline --abbrev-commit
### 查看所有的版本历史
git reflog 

### 退回到之前的版本
git reset --hard commit_id_xxxxx
git reset --hard HEAD^
git reset --hard HEAD^^
git reset --hard HEAD~10


### 舍弃工作区的内容(回到最近一次commit或者add时的状态)
# 如果暂存区有快照，则恢复暂存区的内容至工作区
# 如果暂存区没有快照，则从版本库中拉取最新的版本
git checkout -- file_name

### 将暂存区的修改撤销掉，重新放回工作区 
git reset HEAD file_name

### 删除文件
# 删除文件也是一种修改，执行完本命令后，工作区的file-name文件自动删除
# 必须要commit才能版本库的文件删除
git rm file-name

### 生成rsa密钥对，应用于github.com的提交者确认
ssh-keygen -t rsa -C "6215714@qq.com"

### 关联远程仓库
git remote add origin git@github.com:USER_NAME_XXX/GIT_NAME_XXX.git

### 将本地库的内容推送到远程仓库
# 第一次推送,master的所有内容
git push -u origin master
# 常规推送
git push origin master
# git push的常规语法,origin是远程主机名,git push后的三个名称都可以有条件省略
git push <origin> <local_branch_name>:<remote_branch_name>

### 从远程clone一个版本库repository
git clone git@github.com:USER_NAME_XXX/GIT_NAME_XXX.git

### 创建分支
# 创建一个新的分支
git branch dev_branch_id
# 检出并切换到分支
git checkout dev
# 创建新分支并切换到该新分支,相当于前两个命令的组合
git checkout -b dev
# 检查当前分支(列出所有的分支名，并标注当前所在的分支),如加上参数-a将列出远程分支名
git branch

### 合并和删除分支
# 合并
git merge dev_branch_id
# 禁用快速合并模式 Fast forward, 合并时将生成一个commit,以便追踪。
git merge --no-ff -m "加上--no-ff参数，表示禁止fast forward模式" dev
# 删除(master)
# 删除dev
git branch -d dev_branch_id

### merge时冲突解决
# 在冲突的文件,寻找<<<<<<<<，========和>>>>>>>>标志的区块
#     把冲突的地方手动修改,然后再
git add conflict_file_name
git commit -m "some message"

### 现场保护和切换
# 工作现场保护,切换上最近一次提交时的状态
git stash
# 查看stash列表
git stash list
# 恢复最近一次的工作现场
git stash apply
# 恢复到指定一次的工作现场
git stash apply stash@{n}
# 删除最近一次的stash
git stash drop
# 删除指定一次的stash
git stash drop stash@{n}
# 清空stash
git stash clear
# 恢复最近一次的stash，并删除该stash
git stash pop 

### 删除一个未经合并的分支
git branch -D branch_id

### 查看远程库信息,加上参数-v将显示更详细。如没有push项，表示没有push权限
git remote

### 从远程分支创建一个本地库
# 克隆
git clone SSH_ADDRESS
# 获取所有的远程分支,加上参数-p 将本地删除已被远程删除的分支
git fetch
# 建立分支,origin/dev是远程分支名
git checkout -b dev origin/dev 


### 新建一个本地分支,并跟踪某个远程分支(--set-upstream参数可能已过时)
git branch --track DEV origin/DEV 

### 如果push失败，使用git pull拉取远程分支的内容,并自动merge
git pull

### tag 版本号
git tag # 显示本地库的所有tag
git tag v1.0.0  #在本地库打上tag
git tag -a v1.0.1 -m "v1.0.1版本简易说明" # 带附注的tag
git tag -a v1.0.1 97bf370  # 在某一次commit上打tag
git push origin v1.0.1  # 将本地的v1.0.1发布到远程库中
git push origin --tags  # 把本地库的所有tags都上传到远程库中
git tag -d v1.0.1       # 删除v1.0.1这个本地tag
git checkout v1.0.1  # tag类似于branch，可以直接用checkout切换


### .gitignore文件(在版本库根目录新建.gitignore文件)
# 列出所有的文件名,可以使用通配符*?[]
*.ini
password_?.ini
temp[123].dat
# 指定文件
/dir/*  #忽略根目录下dir目录的所有文件
dir/*   #忽略目录名为dir的下面所有文件
# 不忽略
!.gitignore  # !表示不忽略





