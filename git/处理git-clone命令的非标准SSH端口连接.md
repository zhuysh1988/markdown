###处理git clone命令的非标准SSH端口连接
FROM <http://nanxiao.me/git-clone-ssh-non-22-port/>
#####使用git clone命令clone项目时，如果repository的SSH端口不是标准22端口时（例如，SSH tunnel模式，等等），可以使用如下命令：

    git clone ssh://git@hostname:port/.../xxx.git
####举例如下：

    git clone ssh://git@10.137.20.113:2222/root/test.git
