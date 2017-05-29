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
# 比较某个工作区文件和暂存区文件的差别
git diff file_name 

###查看版本记录
git log

### 退回到之前的版本
git reset --hard commit_id_xxxxx
git reset --hard HEAD^
git reset --hard HEAD^^
git reset --hard HEAD~10

### 查看所有的版本历史
git reflog 

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
git remote add origin git@github.com/USER_NAME_XXX/GIT_NAME_XXX.git

### 将本地库的内容推送到远程仓库
# 第一次推送,master的所有内容
git push -u origin master
# 常规推送
git push origin master

### 从远程clone一个版本库repository
git clone git@github.com/USER_NAME_XXX/GIT_NAME_XXX.git

### 创建分支
# 创建一个新的分支
git branch dev_branch_id
# 检出并切换到分支
git checkout dev
# 创建新分支并切换到该新分支,相当于前两个命令的组合
git checkout -b dev
# 检查当前分支(列出所有的分支名，并标注当前所在的分支)
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
# 查看分支图
git log --graph --pretty=oneline --abbrev-commit

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








