#Ubuntu 更换国内源


    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak #备份
    sudo vim /etc/apt/sources.list #修改
    

##阿里云源

    deb http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse
    deb http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse
    deb http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse
    deb http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse
    deb http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse
    deb-src http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse
    deb-src http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse
    deb-src http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse
    deb-src http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse
    deb-src http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse

## yun-idc  (这个源可以RSYNC)
    deb http://mirrors.yun-idc.com/ubuntu/ trusty main restricted universe multiverse
    deb http://mirrors.yun-idc.com/ubuntu/ trusty-security main restricted universe multiverse
    deb http://mirrors.yun-idc.com/ubuntu/ trusty-updates main restricted universe multiverse
    deb http://mirrors.yun-idc.com/ubuntu/ trusty-proposed main restricted universe multiverse
    deb http://mirrors.yun-idc.com/ubuntu/ trusty-backports main restricted universe multiverse
    deb-src http://mirrors.yun-idc.com/ubuntu/ trusty main restricted universe multiverse
    deb-src http://mirrors.yun-idc.com/ubuntu/ trusty-security main restricted universe multiverse
    deb-src http://mirrors.yun-idc.com/ubuntu/ trusty-updates main restricted universe multiverse
    deb-src http://mirrors.yun-idc.com/ubuntu/ trusty-proposed main restricted universe multiverse
    deb-src http://mirrors.yun-idc.com/ubuntu/ trusty-backports main restricted universe multiverse

# 更新
    sudo apt-get update #更新列表
    
## 模版都一样,只修改域名即可
