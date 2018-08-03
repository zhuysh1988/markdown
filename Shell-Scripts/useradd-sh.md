#useradd.sh



    #!/bin/bash

    #-----------------<jihongrui@outlook.com>-----------------------

    # 本脚本功能 删除系统不必要的用户和组，添加需要的用户和组，并设置强密码。

    # 自动添加 admin sudo 无密码权限

    

    PTAH="/sbin:/usr/sbin:/usr/local/sbin:/bin:/usr/bin:/usr/local/bin"

    export PTAH



    DATE=$(/bin/date +%Y-%m-%d)

    #del user group

    FIUSER="/etc/passwd"

    FIGROUP="/etc/group"

    FIPASS="/etc/shadow"

    olduser=(

    adm

    lp

    sync

    shutdown

    halt

    news

    uucp

    operator

    games

    gopher

    ftp

    dip

    pppusers

    )



    for x in ${olduser[@]}

    do

            grep ${x} ${FIUSER} && userdel ${x} &>/dev/null

            grep ${x} ${FIGROUP} && groupdel ${x} &>/dev/null

    done

    #useradd www code szqsadmin backup

    newuser=(

    admin

    www

    code

    backup

    )

    PASSLOG="${DATE}_passlog.txt"

    [ -f ${PASSLOG} ] && echo >${PASSLOG}

    for u in ${newuser[@]}

    do

            PASS=`date +%s%N|md5sum|openssl rand -base64 32`

            useradd ${u} && \

            echo "$PASS" | passwd --stdin ${u}

            echo -e "\t Newuser:${u} \t Newpass:${PASS}" >>${PASSLOG}

            if [[ $u = "admin" ]]

                    then

    sed -i '98a admin ALL\=\(ALL\)  NOPASSWD\: ALL' /etc/sudoers

            fi

    done

    chmod 600 ${PASSLOG}
