## install rhel 73 Server desktop

- #### IP_ADDR
      192.168.1.118

- #### selinux and firewalld Service
      # disabled  selinux
      setenforce 0
      sed -i 's#^SELINUX=.*$#SELINUX=disabled#g' /etc/selinux/config
      # stop firewalld Service
      systemctl stop firewalld ; systemctl disable firewalld

- #### config  yum repo file
      cat <<EOF >/root/install_repo.sh
      get_repo(){
      curl http://192.168.1.119/repo/7/$1 > /etc/yum.repos.d/$1
      }
      rm -rf /etc/yum.repos.d/*
      for i in epel.repo epel-testing.repo base.repo
      do
      	get_repo $i
      done
      echo "192.168.1.119 yum.example.com" >>/etc/hosts
      EOF
      sh -x /root/install_repo.sh

- #### test yum config
      yum clean all && yum makecache && yum upgrade -y

- #### remove open-jdk and install oracle jdk
      yum remove $(rpm -qa |grep openjdk) -y
      # download jdk-8u65-linux-x64.rpm to /root
      rpm -ivh jdk-8u65-linux-x64.rpm
      # test java version
      java -version
        java version "1.8.0_65"
        Java(TM) SE Runtime Environment (build 1.8.0_65-b17)
        Java HotSpot(TM) 64-Bit Server VM (build 25.65-b01, mixed mode)

- #### config JAVA_HOME
      vim /etc/profile # add this
      export JAVA_HOME=/usr/java/default
      export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
      export PATH=$PATH:$JAVA_HOME/bin            


## install db2 and weblogic
- #### download weblogic to /opt
       # Dont not Use -mode=console ,Use desktop Install
       java -jar wls1030_generic.jar
       # 安装完成后不要启动,安装开发环境需要指定eclipse 目录 ，生产环境不需要
       # 快速启动脚本
       /root/bea/utils/quickstart.sh
       # 配置脚本
       /root/bea/wlserver_10.3/common/bin/config.sh

## Install DB2
- #### download db2 to /opt
      tree -L 1 /opt/server_t/
      /opt/server_t/
      ├── db2
      ├── db2checkCOL_readme.txt
      ├── db2checkCOL.tar.gz
      ├── db2ckupgrade
      ├── db2_deinstall
      ├── db2_install
      ├── db2ls
      ├── db2prereqcheck
      ├── db2setup
      ├── ibm_im
      ├── installFixPack
      ├── nlpack
      └── tmp.txt

- #### 安装db2前先检查环境是否符合
      ./db2prereqcheck -v 11.1.2.2 > /tmp/db2check.tmp
      cat /tmp/db2check.tmp |grep -E '^DBT.* failed'
      # 碰到的几个坑
      # list
      DBT3514W  The db2prereqcheck utility failed to find the following 32-bit library file: "libstdc++.so.6".
      DBT3507E  The db2prereqcheck utility failed to find the following package or file: "sg3_utils".
      DBT3507E  The db2prereqcheck utility failed to find the following package or file: "sg_persist".
      DBT3514W  The db2prereqcheck utility failed to find the following 32-bit library file: "libstdc++.so.6".
      DBT3507E  The db2prereqcheck utility failed to find the following package or file: "sg_persist".
      DBT3507E  The db2prereqcheck utility failed to find the following package or file: "sg3_utils".
      # 需要安装32位libstdc 等等 ，如果有32位的包不能安装成功
      cd /var/cache/yum/x86_64/$releasever/base/packages
      rpm -ivh ./*.rpm --force
      # 最好先把下面的这些包安装下
      yum install libaio libaio-devel libaio.i686 libaio-devel.i686 -y
      yum install kernel-devel gcc-c++ cpp gcc -y
      yum install pam.i686 sg3_utils -y
      yum install ksh perl-Sys-Syslog -y
      yum install numactl-libs-2.0.9-6.el7_2.i686 -y
      # 如果还有其它包 使用以下方法
      yum whatprovides libnuma.so.1  # 会提示需要安装哪个包
- #### 开始安装
      ./db2_install # 按提示和需求先择安装
      # 如果出错，安装日志在/tmp/db2_install.log.xxxxx 会有提示
      # db2 目录
      /opt/ibm/db2/V
- #### Create DB User
      groupadd -g 2010 db2iadm2
      groupadd -g 2011 db2fadm2
      groupadd -g 2012 db2asgrp2
      useradd -m -g db2iadm2 -d /home/db2inst2 db2inst2
      useradd -m -g db2fadm2 -d /home/db2fenc2 db2fenc2
      useradd -m -g db2asgrp2 -d /home/db2as2 db2as2
      passwd user
- #### add PATH
      for i in adm bin instance;do
      DIRS="/opt/ibm/db2/V11.1/${i}"
      chmod -R　775 ${DIRS}
      done
      vim /etc/profile # add
      export PATH=$PATH:/opt/ibm/db2/V11.1/bin         
      export PATH=$PATH:/opt/ibm/db2/V11.1/adm         
      export PATH=$PATH:/opt/ibm/db2/V11.1/instance  

- #### Create Database
      创建实例 db2inst2
      db2icrt -p 50111 -u db2fenc2 db2inst2
      切换到新创建的用户下
      su db2inst2
      启动示例数据库
      db2start
      创建示例数据库sample
      db2 sampl
      db2 connect to sample
