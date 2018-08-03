iscsi 碰到的一个奇怪的故障


    iscsi Server : 192.168.1.100

    iscsi Client101 : 192.168.1.101

    iscsi Client101 : 192.168.1.102

在Server上有一个磁盘柜,放了4块2T SAS 硬盘组的RAID 10 ,共4T. 用于ORACLE 数据库组RAC ASM的.



#配置文件:

    cat /etc/tgt/targets.conf


    include /etc/tgt/szqs/*.conf
    include /etc/tgt/oracle/*.conf

    cat /etc/tgt/oracle/oracle.conf

    <target iqn.2017-02.szqs.oracle.storge:server.target1>
        #backing-store /dev/sda
    	direct-store /dev/sda
        initiator-address 192.168.1.101,192.168.1.102
        incominguser user passwd
        write-cache on
    </target>

# 故障重现
    /etc/init.d/tgtd reload
    OR
    /etc/init.d/tgtd restart
    都 OK
    tgt-admin --show
也可以看到 target已ready
    
    Target 3: iqn.2017-02.szqs.oracle.storge:server.target1
        System information:
            Driver: iscsi
            State: ready
        I_T nexus information:

但是在Client就是不能发现这个target,可以发现其它的.

# 故障解决
    把配置文件修改为:
    <target iqn.2017-02.szqs.oracle.storge:server.target1>
            #backing-store /dev/sda
        	direct-store /dev/sda
            initiator-address 192.168.1.0/24  #这里修改后
            incominguser user passwd
            write-cache on
        </target>
        
Client就能成功发现了
