#zabbix 3.0 迁移数据库
####原来安装zabbix时直接在本机安装的数据库,性能有些不好,所以新建了一个mariadb cluster
####zabbix是yum安装的

    system          centos 7
    zabbix-server   192.168.80.82
    mysql           localhost
    mariadb_cluster 192.168.80.112,192.168.80.113,192.168.80.114

>指定hosts

    cat <<EOF >>/etc/hosts
    192.168.80.112  mysql.cluster
    192.168.80.113  mysql.cluster
    192.168.80.114  mysql.cluster
    EOF

> 将原数据导出到新集群,需修改两个配置文件
这里有坑, 我一直修改/usr/shrec/zabbix/conf/zabbix_config.php 跟本不管用.

    vim /etc/zabbix/zabbix_server.conf

    DBHost=mysql.cluster
    DBName=zabbix
    DBUser=zabbix


    vim /etc/zabbix/web/zabbix_config.php

    $DB['TYPE']     = 'MYSQL';
    $DB['SERVER']   = 'mysql.cluster';
    $DB['PORT']     = '3306';
    $DB['DATABASE'] = 'zabbix';
    $DB['USER']     = 'zabbix';


>zabbix显示中文乱码问题修复

    上传 <微软雅黑>msyh.ttf 至 /usr/share/zabbix/fonts
    sed -i 's/DejaVuSans/msyh/g' /usr/sharc/zabbix/include/defines.inc.php
