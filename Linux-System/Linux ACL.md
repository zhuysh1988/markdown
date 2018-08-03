##Linux setfacl 命令帮助:
###选项
    -b,--remove-all：删除所有扩展的acl规则，基本的acl规则(所有者，群组，其他）将被保留。
    -k,--remove-default：删除缺省的acl规则。如果没有缺省规则，将不提示。
    -n，--no-mask：不要重新计算有效权限。setfacl默认会重新计算ACL mask，除非mask被明确的制定。
    --mask：重新计算有效权限，即使ACL mask被明确指定。
    -d，--default：设定默认的acl规则。
    --restore=file：从文件恢复备份的acl规则（这些文件可由getfacl -R产生）。通过这种机制可以恢复整个目录树的acl规则。此参数不能和除--test以外的任何参数一同执行。
    --test：测试模式，不会改变任何文件的acl规则，操作后的acl规格将被列出。
    -R，--recursive：递归的对所有文件及目录进行操作。
    -L，--logical：跟踪符号链接，默认情况下只跟踪符号链接文件，跳过符号链接目录。
    -P，--physical：跳过所有符号链接，包括符号链接文件。
    --version：输出setfacl的版本号并退出。
    --help：输出帮助信息。
    --：标识命令行参数结束，其后的所有参数都将被认为是文件名
    -：如果文件名是-，则setfacl将从标准输入读取文件名。
    选项-m和-x后边跟以acl规则。多条acl规则以逗号(,)隔开。
    选项-M和-X用来从文件或标准输入读取acl规则。
    选项--set和--set-file用来设置文件或目录的acl规则，先前的设定将被覆盖。 选项-m(--modify)和-M(--modify-file)选项修改文件或目录的acl规则。
    选项-x(--remove)和-X(--remove-file)选项删除acl规则。
    当使用-M，-X选项从文件中读取规则时，setfacl接受getfacl命令输出的格式。


##Linux权限管理--ACL权限

####ACL权限不是针对某个文件或某个目录的，它是针对分区而言的。

#####使用df -h 查看系统分区

    [linuxidc@linuxidc ~]$ df -h
    Filesystem            Size  Used Avail Use% Mounted on
    /dev/sda3              16G  2.9G  12G  20% /
    tmpfs                947M    0  947M  0% /dev/shm
    /dev/sda1            291M  35M  242M  13% /boot
    /dev/sr0              3.0G  3.0G    0 100% /media/cdrom

####可以看到/的分区号是/dev/sda3,查看/dev/sda3是否支持acl权限
####使用命令dumpe2fs查看是否支持acl

    [root@linuxidc ~]# dumpe2fs -h /dev/sda3
    dumpe2fs 1.41.12 (17-May-2010)
    Filesystem volume name:  <none>
    Last mounted on:          /
    Filesystem UUID:          4e32f639-ccc9-4942-ac35-b281fdfbb79e
    Filesystem magic number:  0xEF53
    Filesystem revision #:    1 (dynamic)
    Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
    Filesystem flags:        signed_directory_hash
    Default mount options:    user_xattr acl
    Filesystem state:        clean
    Errors behavior:          Continue

####可以看到Default mount options项是支持acl的

####一般操作系统默认是支持acl权限的.如果不支持可开启分区的alc权限
####使用mount命令重新挂载/分区,并支持acl权限

    [root@linuxidc ~]# mount -o remount,acl /

####使用mount命令重新挂载并支持acl权限只是临时生效,系统重启后失效

    [root@linuxidc ~]# vim /etc/fstab

    #
    # /etc/fstab
    # Created by anaconda on Sun May  1 09:19:06 2016
    #
    # Accessible filesystems, by reference, are maintained under '/dev/disk'
    # See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
    #
    UUID=4e32f639-ccc9-4942-ac35-b281fdfbb79e /                      ext4    defaults        1 1
    UUID=7e2ce555-c044-41f8-9cd5-18c7d5293cf1 /boot                  ext4    defaults        1 2
    UUID=fa77a5dd-1f7f-4428-bcc4-79f7742ed320 swap                    swap    defaults        0 0

####系统默认是支持acl权限的,如果默认不支持,我们可以在对应的分区后面加上acl选项,如下所示,以/分区为例

    9 UUID=4e32f639-ccc9-4942-ac35-b281fdfbb79e /                      ext4    defaults,acl        1 1

>有时候一个文件的拥有者,所属组,其他人三种角色对文件的权限并不能完全满足、适合某一个用户所需要对文件的操作权限,这时就需要对特殊的用户单独设置权限,下面举例说明

####查看home目录中linuxidc目录的访问权限

    [root@linuxidc home]# getfacl linuxidc
    # file: linuxidc
    # owner: linuxidc
    # group: linuxidc
    user::rwx
    group::---
    other::---

>可以看到只有用户linuxidc(root除外)才对自己家目录有rwx权限.所属组和其他人没有任何权限.
现在有这样一个用户,只能让他进入linuxidc目录,查看里面有哪些文件和文件内容,但是不能让他创建文件
可以先找一个存在的用户试试,看看能不能对/home/linuxidc目录做任何操作

    [linuxidc@linuxidc home]$ tail -3 /etc/passwd
    named:x:25:25:Named:/var/named:/sbin/nologin
    linuxidc:x:501:501::/home/linuxidc:/bin/bash
    iaknehc:x:502:502::/home/iaknehc:/bin/bash

    [iaknehc@linuxidc home]$ cd linuxidc
    -bash: cd: linuxidc: Permission denied

>可以看到当切换到iaknehc时,用户对linuxidc目录没有任何权限,这里只是测试了一下其他人对linuxidc的权限,其实所属组的用户也一样,可以自己试试.所以我们需要一种更灵活的权限设置方法.这就是acl.

    [linuxidc@linuxidc home]$ setfacl -m u:iaknehc:rx linuxidc    //将目录linuxidc的rx权限分配给用户iaknehc
    [linuxidc@linuxidc home]$ getfacl linuxidc
    # file: linuxidc
    # owner: linuxidc
    # group: linuxidc
    user::rwx
    user:iaknehc:r-x
    group::---
    mask::r-x
    other::---

####下面切换到iaknehc用户试试权限是否生效

    [linuxidc@linuxidc home]$ su - iaknehc
    Password:
    [iaknehc@linuxidc ~]$ cd ..
    [iaknehc@linuxidc home]$ cd linuxidc
    [iaknehc@linuxidc linuxidc]$ ll      //iaknehc可以进入linuxidc目录,并浏览目录中的文件
    total 4
    -rw-rw-r-- 1 linuxidc vampire 12 May 16 23:21 linuxidc
    [iaknehc@linuxidc linuxidc]$ cat vampire    //iaknehc可以查看文件类容
    just a test
    [iaknehc@linuxidc linuxidc]$ touch test    //iaknehc不能在linuxidc目录中创建文件
    touch: cannot touch `test': Permission denied

####可以看到针对目录linuxidc设置的acl权限已经生效.

####先查看目录linuxidc的acl权限

    [root@linuxidc home]# getfacl linuxidc
    # file: linuxidc/
    # owner: linuxidc
    # group: linuxidc
    user::rwx
    user:iaknehc:r-x
    group::---
    mask::r-x
    other::---

###mask是用来指定最大有效权限的,如果给用户赋予了ACL权限,是需要和mask的
####权限"相与"才能得到用户的真正权限.
####将用户iaknehc的权限设置为rwx在查看acl权限

    [linuxidc@linuxidc home]$ setfacl -m u:iaknehc:rwx linuxidc
    [vampire@linuxidc home]$ getfacl linuxidc
    # file: linuxidc
    # owner: linuxidc
    # group: linuxidc
    user::rwx
    user:iaknehc:rwx
    group::---
    mask::rwx
    other::---

###设置acl最大权限后再查看iaknehc的acl权限

    [linuxidc@linuxidc home]$ setfacl -m m:rx linuxidc  //修改最大有效权限,即mask的值
    [linuxidc@linuxidc home]$ getfacl linuxidc
    # file: linuxidc
    # owner: linuxidc
    # group: linuxidc
    user::rwx
    user:iaknehc:rwx        #effective:r-x    //虽然之前设置了rwx权限,但是后来通过mask限制了最大权限,现在用户实际权限为rx
    group::---
    mask::r-x
    other::---

    setfacl -m m:rx linuxidc
>通过执行该命令后,文件所属组,其他人和通过acl设置的用户对该文件最大权限只有rx,可以防止
设置权限不能准确把握时,导致设置权限过大,但该命令不影响文件拥有者的权限.

###acl相关命令选项
    setfacl -m 给用户或组设置acl权限
    setfacl -m u:iaknehc:rx linuxidc //给用户iaknehc设置acl权限
    setfacl -m g:iaknehc:rx linuxidc //给组iaknehc设置acl权限

###修改最大有效权限
    setfacl -m m:rx linuxidc //修改文件vampire的最大有效权限为rx,一般只有文件所属者或root才能修改文件最大有效权限

    setfacl -x 删除指定用户的acl权限
    setfacl -x u:iaknehc linuxidc //删除用户iaknehc对文件linuxidc的acl权限
    setfacl -x g:iaknehc linuxidc //删除组iaknehc对文件linuxidc的acl权限

    setfacl -b 删除文件所有acl权限
    setfacl -b linuxidc //删除文件vampire的所有acl权限,所有用户的acl权限都被删除

    setfacl -d 设置文件默认acl权限

    setfacl -k 删除默认的acl权限

    setfacl -R 递归设置acl权限
