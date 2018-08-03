##zabbix 使用自带mysql模版监控mysql

###mysql mariadb
>root帐号可无密登陆 vim /etc/my.cnf 添加 以下内容:

    [mysql]
    host=localhost
    user=root
    socket=/var/lib/mysql/mysql.sock

    [mysql_upgrade]

    [mysqladmin]
    host=localhost
    user=root
    socket=/var/lib/mysql/mysql.sock

##编写检测脚本
###vim /etc/zabbix/chk_mysql.sh

    #!/bin/bash
    # -------------------------------------------------------------------------------
    # FileName:    check_mysql.sh
    # Revision:    1.0
    # Date:        2017/04/03
    # Author:      jihongrui
    # Email:        jihongrui@hotmail.com
    # Website:      allcmd.com
    # Description:
    # Notes:       ~
    # -------------------------------------------------------------------------------
    # Copyright:   2015 (c) DengYun
    # License:     GPL

    # 用户名
    MYSQL_USER='root'

    # 密码
    # 因为无密码访问,所有这项不用
    # MYSQL_PWD='zabbix'

    # 主机地址/IP
    # 不要通过IP访问,通过sock的文件
    # MYSQL_HOST='127.0.0.1'
    # 不要通过IP访问,通过sock的文件
    # 端口

    #MYSQL_PORT='3306'

    # 数据连接
    # MYSQL_CONN="/usr/bin/mysqladmin -u${MYSQL_USER} -p${MYSQL_PWD} -h${MYSQL_HOST} -P${MYSQL_PORT}"
    MYSQL_CONN="/usr/bin/mysqladmin -u${MYSQL_USER}"

    # 参数是否正确
    if [ $# -ne "1" ];then
        echo "arg error!"
    fi

    # 获取数据
    case $1 in
        Uptime)
            result=`${MYSQL_CONN} status|cut -f2 -d":"|cut -f1 -d"T"`
            echo $result
            ;;
        Com_update)
            result=`${MYSQL_CONN} extended-status |grep -w "Com_update"|cut -d"|" -f3`
            echo $result
            ;;
        Slow_queries)
            result=`${MYSQL_CONN} status |cut -f5 -d":"|cut -f1 -d"O"`
            echo $result
            ;;
        Com_select)
            result=`${MYSQL_CONN} extended-status |grep -w "Com_select"|cut -d"|" -f3`
            echo $result
                    ;;
        Com_rollback)
            result=`${MYSQL_CONN} extended-status |grep -w "Com_rollback"|cut -d"|" -f3`
                    echo $result
                    ;;
        Questions)
            result=`${MYSQL_CONN} status|cut -f4 -d":"|cut -f1 -d"S"`
                    echo $result
                    ;;
        Com_insert)
            result=`${MYSQL_CONN} extended-status |grep -w "Com_insert"|cut -d"|" -f3`
                    echo $result
                    ;;
        Com_delete)
            result=`${MYSQL_CONN} extended-status |grep -w "Com_delete"|cut -d"|" -f3`
                    echo $result
                    ;;
        Com_commit)
            result=`${MYSQL_CONN} extended-status |grep -w "Com_commit"|cut -d"|" -f3`
                    echo $result
                    ;;
        Bytes_sent)
            result=`${MYSQL_CONN} extended-status |grep -w "Bytes_sent" |cut -d"|" -f3`
                    echo $result
                    ;;
        Bytes_received)
            result=`${MYSQL_CONN} extended-status |grep -w "Bytes_received" |cut -d"|" -f3`
                    echo $result
                    ;;
        Com_begin)
            result=`${MYSQL_CONN} extended-status |grep -w "Com_begin"|cut -d"|" -f3`
                    echo $result
                    ;;

            *)
            echo "Usage:$0(Uptime|Com_update|Slow_queries|Com_select|Com_rollback|Questions|Com_insert|Com_delete|Com_commit|Bytes_sent|Bytes_received|Com_begin)"
            ;;
    esac

###添加权限和检测脚本
    chmod 755 chk_mysql.sh
    ./chk_mysql.sh Uptime  #如有返回值就OK了

###修改zabbix 文件
    将原有UserParameter 改成如下:
    UserParameter=mysql.status[*],/etc/zabbix/chk_mysql.sh $1

###重启zabbinx-agent
    /etc/init.d/zabbix-agent restart
