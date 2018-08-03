#CentOS 6.X系统初始化

##1 关闭 SElinux AND iptables
    setenforce 0 &&  sed -i 's#^SELINUX=.*$#SELINUX=disabled#g' /etc/sysconfig/selinux
    /etc/init.d/ip6tables stop && chkconfig ip6tables off
    /etc/init.d/iptables stop && chkconfig iptables off

##2 建立 /export/scripts 目录 下载脚本包
    SCRI='/export'
    test -d "${SCRI}" && mkdir -p "${SCRI}"
    which wget &>/dev/null || yum install wget  -y
    cd "${SCRI}" && wget http://mirrors.jsqix.com/server.tar.gz && tar xf server.tar.gz
    cd scripts

##3 更改 root 密码
    /bin/bash -x rootpass.sh
    # 记录ROOT密码
##4 更新YUM源,安装常用软件
    ／bin/bash -x yum.sh
    yum install vim lrzsz lsof tcpdump -y
##5 建立新用户
    /bin/bash -x useradd.sh
    记录用户和密码
##6 修复open-ssl bug
    /bin/bash -x openssl_scripts.sh
##7 升级系统至最新
    yum upgrade -y
##8 绑定网卡bond0
    vim ip.sh  # 修改ip netmask gateway dns mode
    /bin/bash -x ip.sh
##9 调整SSH
    /bin/bash -x ssh.sh
    /bin/bash -x /etc/ssh/sshrc
##10 开启NTP SYSLOG
    /bin/bash -x ntp.sh
    /bin/bash -x log_udp.sh
##11 设置history转发
    /bin/bash -x hist.sh
    echo "44 */1 * * * root python `pwd`/Linux_history.py" >>/etc/crontab
##12 设置脚本运行
    /bin/bash -x code_backup.sh
    /bin/bash -x tomcat-cp.sh
    /bin/bash -x EveryDay_chk.sh
