##CentOS 下 Percona Xtrabackup的安装及使用

###下载 和 安装
#####只有能连网,就这么简单
####CentOS 6
    wget http://mirrors.jsqix.com/soft/linux_software/xtrabackup/percona-xtrabackup-24-2.4.6-2.el6.x86_64.rpm
    yum install percona-xtrabackup-24-2.4.6-2.el6.x86_64.rpm
####CentOS 7
    wget http://mirrors.jsqix.com/soft/linux_software/xtrabackup/percona-xtrabackup-24-2.4.6-2.el7.x86_64.rpm
    yum install percona-xtrabackup-24-2.4.6-2.el7.x86_64.rpm

###使用
####测试在本地不输入用户和密码也可以备份
###Full Backup
    innobackupex -S /var/lib/mysql/mysql.sock --backup /home/mysql_bak/
###Full Backup Database
    innobackupex -uroot -S /var/lib/mysql/mysql.sock --database=nginx_log --backup /home/mysql_bak/
    innobackupex -uroot -S /var/lib/mysql/mysql.sock --database=nginx_log,mysql --backup /home/mysql_bak/
###备份到tar.gz文件
    innobackupex -S /var/lib/mysql/mysql.sock --stream=tar /home/mysql_bak |gzip >/home/mysql_bak/Full_bak_`date +%F`.tar.gz
###恢复
### 1 重做日志应用到备份数据文件
>但是一般情况下，这个备份是不能用于恢复的，因为备份的数据中可能会包含尚未提交的事务或已经提交但尚未同步至数据文件中的事务。因此，此时数据文件处于不一致的状态，我们现在就是要通过回滚未提交的事务及同步已经提交的事务至数据文件也使得数据文件处于一致性状态。
###为了加快速度，一般建议设置--use-memory
    innobackupex --apply-log --use-memory=4G /home/mysql_bak/2017-04-14_15-09-56/
>从上面可以看出，只是对innobackupex加--apply-log参数应用日志，然后加上备份的目录

### 2 完全恢复数据
>先停止mysqld服务，然后清空数据文件目录，恢复完成后再设置权限

    /etc/init.d/mysql stop
    mv /home/mysql/data /home/mysql/olddata
    mkdir /home/mysql/data
    innobackupex --copy-back /home/mysql_bak/2017-04-14_15-09-56/
    chown -R mysql.mysql /home/mysql/data
    /etc/init.d/mysql start

>innobackup的--copy-back选项用于执行恢复操作，它是通过复制所有数据相关文件至MySQL数据目录，因此，需要清空数据目录。我这里是将其重命名，然后再重建目录。最主要一步是将其权限更改

###增量备份:

    [iyunv@Web1 ~]# innobackupex --user=root --password=123456 --incremental /data/backup --incremental-basedir=/data/backup/2014-06-30_11-33-24



>其中，--incremental-basedir指的是完全备份所在的目录，此命令执行结束后，innobackupex命令会在/data/backup目录中创建一个新的以时间命名的目录以存放所有的增量备份数据。另外，在执行过增量备份之后再一次进行增量备份时，其--incremental-basedir应该指向上一次的增量备份所在的目录。

>需要注意的是，增量备份仅能应用于InnoDB或XtraDB表，对于MyISAM表而言，执行增量备份时其实进行的是完全备份。

###增量备份，如果需要恢复的话需要做如下操作

    [iyunv@Web1 ~]# innobackupex --apply-log --redo-only /data/backup/2014-06-30_11-33-24
    [iyunv@Web1 ~]# innobackupex --apply-log --redo-only /data/backup/2014-06-30_11-33-24 --incremental-dir=/data/backup/2014-06-30_13-06-25



###如果存在多次增量备份的话，就需要多次执行.如
    innobackupex --apply-log --redo-only BACKUPDIR 
    innobackupex --apply-log --redo-only BACKUPDIR --incremental-dir=INCREMENTDIR-1
    innobackupex --apply-log --redo-only BACKUPDIR --incremental-dir=INCREMENTDIR-2



###BACKUP是全备目录，INCREMENTDIR是增量备份目录，上面是有2次增量备份，如果存在多次增量备份，则需要多次运行如上的命令
