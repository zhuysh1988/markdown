# Ubuntu
安装／升级你的Docker客户端

推荐安装1.10.0以上版本的Docker客户端，参考文档 docker-ce
如何配置镜像加速器

针对Docker客户端版本大于1.10.0的用户

您可以通过修改daemon配置文件/etc/docker/daemon.json来使用加速器：
``` bash
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://wscx7er7.mirror.aliyuncs.com"],
  "insecure-registries": ["http://registry.example.com:5000"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

Windows

安装／升级你的Docker客户端

对于Windows 10以下的用户 推荐使用 Docker Toolbox

Toolbox的介绍和帮助：mirrors.aliyun.com/help/docker-toolbox

Windows系统的安装文件目录：http://mirrors.aliyun.com/docker-toolbox/windows/docker-toolbox/

对于Windows 10以上的用户 推荐使用 Docker for Windows

Windows系统的安装文件目录：http://mirrors.aliyun.com/docker-toolbox/windows/docker-for-windows/
如何配置镜像加速器

针对安装了Docker Toolbox的用户，您可以参考以下配置步骤：

创建一台安装有Docker环境的Linux虚拟机，指定机器名称为default，同时配置Docker加速器地址。

docker-machine create --engine-registry-mirror=https://wscx7er7.mirror.aliyuncs.com -d virtualbox default
查看机器的环境配置，并配置到本地，并通过Docker客户端访问Docker服务。

docker-machine env default
eval "$(docker-machine env default)"
docker info
针对安装了Docker for Windows的用户，您可以参考以下配置步骤：

在系统右下角托盘图标内右键菜单选择 Settings，打开配置窗口后左侧导航菜单选择 Docker Daemon。编辑窗口内的JSON串，填写加速器地址，如下所示：
{
  "registry-mirrors": ["https://wscx7er7.mirror.aliyuncs.com"]
}
编辑完成，点击 Apply 保存按钮，等待Docker重启并应用配置的镜像加速器。

注意

Docker for Windows 和 Docker Toolbox是不兼容，如果同时安装两者的话，需要使用hyperv的参数启动。
docker-machine create --engine-registry-mirror=https://wscx7er7.mirror.aliyuncs.com -d hyperv default
Docker for Windows 有两种运行模式，一种运行Windows相关容器，一种运行传统的Linux容器。同一时间只能选择一种模式运行。
