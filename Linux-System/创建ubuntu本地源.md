## 搭建Ubuntu 12.04 本地源


- ### 1. 安装apt-mirror工具

      sudo apt-get install apt-mirror

>或者下载源码编译，不过推荐apt安装.方法自行摸索.

## 注意文件 mirrors.list 不是source.list 
- ### 2. 配置apt-mirror工具
      

      gksu gedit /etc/apt/mirrors.list

>清除原有内容，没关系，输入以下内容：

      set nthreads     20
      set _tilde 0
      #
      ############# end config ##############
      deb http://mirrors.sohu.com/ubuntu/ lucid main universe restricted multiverse
      deb http://mirrors.sohu.com/ubuntu/ lucid-security universe main multiverse restricted
      deb http://mirrors.sohu.com/ubuntu/ lucid-updates universe main multiverse restricted
      deb http://mirrors.sohu.com/ubuntu/ lucid-proposed universe main multiverse restricted
      deb http://mirrors.sohu.com/ubuntu/ lucid-backports universe main multiverse restricted

      clean http://mirrors.sohu.com/ubuntu

>这里的地址规则和sources.list中是一样的，用的是sohu的镜像，内容很全的，与官方同步的.

- ### 3. 开始制作

      sudo apt-mirror

>大概会显示

      Downloading 80 index files using 20 threads...
      Begin time: Fri Mar 30 21:47:40 2012
      [20]... [19]... [18]... [17]... [16]... [15]... [14]... [13]... [12]... [11]... [10]... [9]... [8]... [7]... [6]... [5]... [4]... [3]... [2]... [1]... [0]... 
      End time: Fri Mar 30 21:47:57 2012
      
      Proceed indexes: [PPPPP]
      
      44 GiB will be downloaded into archive.
      Downloading 4388 archive files using 20 threads...
      
>制作完成后会有提示,制作过程可以中断，之后再次运行apt-mirror会继续以前的工作.每次都可以这样更新.

>此过程根据网速不同，会有不同的时间.网速快的话，1个晚上就能完成.


- ### 4. 作为本地源头更新

>制作完成后，在本地存储的地址为：/var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu

### 编辑sources.list

    gksu gedit /ets/apt/sources.list

>删除原有内容，写入：

    deb file:///var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/ lucid main universe restricted multiverse  
    deb file:///var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/ lucid-security universe main multiverse restricted  
    deb file:///var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/ lucid-updates universe main multiverse restricted  
    deb file:///var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/ lucid-proposed universe main multiverse restricted  
    deb file:///var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/ lucid-backports universe main multiverse restricted 
    

- ### 5. 本地安装软件包

      sudo apt-get update

      sudo apt-get install xxxx


- ### 6. 制作成局域网源

      安装apaches
      
      /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/ 作为webroot
      
      地址为局域网ip地址即可.