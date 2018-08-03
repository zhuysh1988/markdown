##添加EPEL库
###1、备份(如有配置其他epel源)

    mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup
    
    mv /etc/yum.repos.d/epel-testing.repo /etc/yum.repos.d/epel-testing.repo.backup

###2、下载新repo 到/etc/yum.repos.d/

####epel(RHEL 7)

 
        wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
            
####epel(RHEL 6)

 
        wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
            
####epel(RHEL 5)

        wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-5.repo

##添加阿里云的源
###1、备份

    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup

###2、下载新的CentOS-Base.repo 到/etc/yum.repos.d/

####CentOS 5

    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-5.repo
####CentOS 6

    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
####CentOS 7

    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
####3、之后运行yum makecache生成缓存
    yum makecache
