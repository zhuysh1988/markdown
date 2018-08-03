## CentOS 通过EPEL 安装 saltstack

## 一 配置源

### BASE

    cat <<EOF >/etc/yum.repos.d/cenots6.repo
    [jsqix]
    name=CentOS-$releasever - jsqix
    baseurl=http://mirrors.jsqix.com/centos/6
    gpgcheck=1
    enabled=1
    gpgkey=http://mirrors.jsqix.com/centos/6/RPM-GPG-KEY-CentOS-6
    EOF

### EPEL

    cat << EOF > /etc/yum.reops.d/epel.repos
    [epel]
    name=Extra Packages for Enterprise Linux 6 - $basearch
    baseurl=http://mirrors.yun-idc.com/epel/6/$basearch
    failovermethod=priority
    enabled=1
    gpgcheck=0
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6

    [epel-debuginfo]
    name=Extra Packages for Enterprise Linux 6 - $basearch - Debug
    baseurl=http://mirrors.yun-idc.com/epel/6/$basearch/debug
    failovermethod=priority
    enabled=0
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
    gpgcheck=0

    [epel-source]
    name=Extra Packages for Enterprise Linux 6 - $basearch - Source
    baseurl=http://mirrors.yun-idc.com/epel/6/SRPMS
    failovermethod=priority
    enabled=0
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
    gpgcheck=0
    EOF

### EPEL-TESTING
    cat <<EOF >/etc/yum.reops.d/epel-testing.repos
    [epel-testing]
    name=Extra Packages for Enterprise Linux 6 - Testing - $basearch
    baseurl=http://mirrors.yun-idc.com/epel/testing/6/$basearch
    failovermethod=priority
    enabled=0
    gpgcheck=1
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6

    [epel-testing-debuginfo]
    name=Extra Packages for Enterprise Linux 6 - Testing - $basearch - Debug
    baseurl=http://mirrors.yun-idc.com/epel/testing/6/$basearch/debug
    failovermethod=priority
    enabled=0
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
    gpgcheck=1

    [epel-testing-source]
    name=Extra Packages for Enterprise Linux 6 - Testing - $basearch - Source
    baseurl=http://mirrors.yun-idc.com/epel/testing/6/SRPMS
    failovermethod=priority
    enabled=0
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
    gpgcheck=1
    EOF

## 二 安装 salt-master salt-minion

    yum -y install salt-master
    yum -y install salt-minion

## 三 配置 msater minion

### msater

    默认不需要配置

### minion

    vim /etc/salt/minion
    master: 设置为master IP

## 四 设置开机启动

    /etc/init.d/salt-master start
    /etc/init.d/salt-minion start
    chkconfig salt-master on
    chkconfig salt-minion on

## 五 测试 saltstack

### 在master 上执行

    salt-key -L # 查看minion 列表
    salt-key -A # 接受所有KEY
    salt '*' test.ping  # 简单测试
    salt '*' cmd.run 'hostname' # 查看所有minion 的hostname
