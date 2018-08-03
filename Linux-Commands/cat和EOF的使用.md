cat和EOF的使用 

#（1）cat和EOF简介
    
    cat      用于显示文本文件内容，全部输出
    EOF   “end of file”，表示文本结束符
 
#（2）使用
用法1.多行导入文件（新建文件或者覆盖文件内容）
 
    cat << EOF >abcd.txt   
    Hello!   
    This is a test file!   
    Test for cat and EOF!   
    EOF 
 
来看下执行结果
 
    cat abcd.txt  
    Hello!   
    This is a test file!   
    Test for cat and EOF! 

这就是多行导入！
 
用法2.文件追加

    cat << EOF >> test.sh
 
#（3）说明
其实可以用其他字符来代替EOF，它也只是个标识符而已！
如果cat内容中带有 $变量的时候会将$和变量名变成空格，想到到转义字符\添加之后可以搞定。同样cat <
例如
 
 
    cat <<EOF >> /home/oracle/.bash_profile  
    PATH=\$PATH:\$HOME/bin  
    export ORACLE_BASE=/u01/app/oracle  
    export ORACLE_HOME=\$ORACLE_BASE/10.2.0/db_1  
    export ORACLE_SID=yqpt 
    export PATH=\$PATH:\$ORACLE_HOME/bin  
    export NLS_LANG="AMERICAN_AMERICA.AL32UTF8" 
    EOF 
 
如果不是在脚本中，我们可以用Ctrl-D输出EOF的标识
    # cat > test.txt
    abcd
    dcba
    eftf
    Ctrl-D
