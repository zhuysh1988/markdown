## reposync 同步 YUM源

### Install reposync 
    yum install yum-utils createrepo yum-plugin-priorities -y
### 获取 YUM 文件
#### Example: 
    cat openstack.repo 
    [openstack]
    name=openstack - ocata
    baseurl=http://mirrors.163.com/centos/7/cloud/x86_64/openstack-ocata/
    gpgcheck=0
    enabled=1
#### 清除YUM缓存 
    yum clean all 
#### 建立YUM快速缓存
　　yum makecache 
#### 建立YUM源存放目录 
    mkdir -p /data/yum/openstack-ocata
#### 同步
    reposync --repoid=openstack --download_path=/data/yum/openstack-ocata
#### 建立本地YUM源
    cd /data/yum/openstack-ocata
    createrepo . 
    
#### 配置Nginx 或者 Apache 访问就可以了
    