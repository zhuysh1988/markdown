##yum的配置以及 yum.conf 配置文件的说明
###YUM的配置文件
>yum的一切配置信息都储存在一个叫yum.conf的配置文件中，通常位于/etc目 录下，这是整个yum系统的重中之重，所以有必要详细介绍。下面是一个从网上找来的yum.con文件，让我们以此为例，进行说明。

    [main]
    cachedir=/var/cache/yum
    debuglevel=2
    logfile=/var/log/yum.log
    pkgpolicy=newest
    distroverpkg=redhat-release
    tolerant=1
    exactarch=1
    retries=1

    [base]
    name=Fedora Core $releasever - $basearch - Base
    baseurl=http://download.atrpms.net/mirrors/fedoracore/$releasever/$basearch/os
    http://rpmfind.net/linux/fedora/cor...er/$basearch/os
    http://mirror.clarkson.edu/pub/dist...er/$basearch/os

    [updates-released]
    name=Fedora Core $releasever - $basearch - Released Updates
    baseurl=http://download.atrpms.net/mirrors/fedoracore/updates/$releasever/$basearch
    http://redhat.linux.ee/pub/fedora/l...sever/$basearch
    http://fr2.rpmfind.net/linux/fedora...sever/$basearch

    [Fedora.us]
    name=Fedora.us - $basearch - Extras
    baseurl=http://fedora.linux.duke.edu/fedorax86_64/fedora.us/$releasever/$basearch/RPMS.stable

    [Dag Wieers]
    name=Dag RPM Repository for Fedora Core
    baseurl=http://apt.sw.be/fedora/$releasever/en/$basearch/dag

    [Livna]
    Name=Livna RPM, Fedora Core $releasever - $basearch
    baseurl=http://rpm.livna.org/fedora/$releasever/$basearch/RPMS.stable

    [freshrpms]
    name=FreshRPMs
    baseurl=http://ayo.freshrpms.net/fedora/linux/$releasever/$basearch/freshrpms/
    http://ftp.us2.freshrpms.net/linux/...arch/freshrpms/


###第一部分
>（这是yum的全局性设置。默认一般不必改动。）

    [main]
    cachedir：yum缓存的目录，yum在此存储下载的rpm包和数据库，一般是/var/cache/yum。
    debuglevel：除错级别，0──10,默认是2
    logfile：yum的日志文件，默认是/var/log/yum.log。
    pkgpolicy： 包的策略。一共有两个选项，newest和last，这个作用是如果你设置了多个repository，而同一软件在不同的repository中同时存 在，yum应该安装哪一个，如果是newest，则yum会安装最新的那个版本。如果是last，则yum会将服务器id以字母表排序，并选择最后的那个 服务器上的软件安装。一般都是选newest。
    distroverpkg：指定一个软件包，yum会根据这个包判断你的发行版本，默认是redhat-release，也可以是安装的任何针对自己发行版的rpm包。
    exactarch，有两个选项1和0,代表是否只升级和你安装软件包cpu体系一致的包，如果设为1，则如你安装了一个i386的rpm，则yum不会用1686的包来升级。
    retries，网络连接发生错误后的重试次数，如果设为0，则会无限重试。
    tolerent，也有1和0两个选项，表示yum是否容忍命令行发生与软件包有关的错误，比如你要安装1,2,3三个包，而其中3此前已经安装了，如果你设为1,则yum不会出现错误信息。默认是0。
    除了上述之外，还有一些可以添加的选项，如
    exclude=，排除某些软件在升级名单之外，可以用通配符，列表中各个项目要用空格隔开，这个对于安装了诸如美化包，中文补丁的朋友特别有用。
    gpgchkeck= 有1和0两个选择，分别代表是否是否进行gpg校验，如果没有这一项，默认好像也是检查的。

###第二部分
>配置repository服务器了，这是最令人激动的，有了好的repository，就如家门口开了大卖场，要什么东西稍微跑跑腿就行，对了这还是个免费的大卖场。
>所有服务器设置都应该遵循如下格式：

    [serverid]
    name=Some name for this server
    baseurl=url://path/to/repository/

    其中serverid是用于区别各个不同的repository，必须有一个独一无二的名称。
    name，是对repository的描述，支持像$releasever $basearch这样的变量;
    baseurl是服务器设置中最重要的部分，只有设置正确，才能从上面获取软件。它的格式是：
    baseurl=url://server1/path/to/repository/
    url://server2/path/to/repository/
    url://server3/path/to/repository/
>其中url支持的协议有 http:// ftp:// file://三种。baseurl后可以跟多个url，你可以自己改为速度比较快的镜像站，但baseurl只能有一个，也就是说不能像如下格式：

    baseurl=url://server1/path/to/repository/
    baseurl=url://server2/path/to/repository/
    baseurl=url://server3/path/to/repository/
>其中url指向的目录必须是这个repository header目录的上一级，它也支持$releasever $basearch这样的变量。
url之后可以加上多个选项，如gpgcheck、exclude、failovermethod等，比如：

    [updates-released]
    name=Fedora Core $releasever - $basearch - Released Updates
    baseurl=http://download.atrpms.net/mirrors/fedoracore/updates/$releasever/$basearch
    http://redhat.linux.ee/pub/fedora/linux/core/updates/$releasever/$basearch
    http://fr2.rpmfind.net/linux/fedora/core/updates/$releasever/$basearch
    gpgcheck=1
    exclude=gaim
    failovermethod=priority

>其中gpgcheck，exclude的含义和[main]部分相同，但只对此服务器起作用，
failovermethode 有两个选项roundrobin和priority，意思分别是有多个url可供选择时，yum选择的次序，roundrobin是随机选择，如果连接失 败则使用下一个，依次循环，priority则根据url的次序从第一个开始。如果不指明，默认是roundrobin。

##几个变量
    $releasever，发行版的版本，从[main]部分的distroverpkg获取，如果没有，则根据redhat-release包进行判断。
    $arch，cpu体系，如i686,athlon等
    $basearch，cpu的基本体系组，如i686和athlon同属i386，alpha和alphaev6同属alpha。
>对yum.conf设定完成，我们就可以好好体验yum带来的方便了。

>对 了，万事具备，只欠东风。还有一件事没有做。那就是导入每个reposity的GPG key，前面说过，yum可以使用gpg对包进行校验，确保下载包的完整性，所以我们先要到各个repository站点找到gpg key，一般都会放在首页的醒目位置，一些名字诸如 RPM-GPG-KEY.txt之类的纯文本文件，把它们下载，然后用

    rpm --import xxx.txt

>命令将它们导入，最好把发行版自带GPG-KEY也导入，

    rpm --import /usr/share/doc/redhat-release-*/RPM-GPG-KEY

>官方软件升级用的上。

### FC3:

    rpm --import /usr/share/doc/fedora-release-3/RPM-GPG-KEY-fedora
###FC4:

    rpm --import /usr/share/doc/fedora-release-4/RPM-GPG-KEY-fedora

>更详细的内容可以参考man 文档
    man 5 yum.conf

###[配置完后］
    [repo1]
    name=test1
    baseurl=http://mirror.centos.org/centos-5/5.5/os/$basearch
    enabled=1
    gpgcheck=1
    gpgkey=http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-5

    [repo2]
    name=test2
    baseurl=http://ftp.sjtu.edu.cn/centos/5.5/os/$basearch
    enabled=1
    gpgcheck=1
    gpgkey=http://ftp.sjtu.edu.cn/centos/RPM-GPG-KEY-CentOS-5

###本地YUN源的配置
>在linux上安装软件包的时候当遇到软件包之间的依赖关系时，将是一个头疼的问题。所以配置YUM源，让其自动解决依赖关系，安装必须的相互依赖的包。
###System-config-packets 调出安装程序。
    1 把源文件的内容拷贝到一个目录中。
    2 编辑/etc/yum.repos.d/rhel-debuginfo.repo
     在[]中的表示仓库的名称
     name :指明对仓库的描述
     baseurl:仓库的具体位置
    注意：如果是本地yun源的话，前面的ftp必须改成file：///不然会发生你意想不到的错误。
    enable :为0关闭yum源 为1时开启
    gpbcheck ：为1表示开启对软件包的验证。
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
    用命令：rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
    createrepo -vg /yum/repodata/respon.xml /yum/
>这条命令的respon.xml就是group了，具体大概就是什么软件对应什么的吧。。。反正必须。
>3 编辑/usr/lib/python2.4/site-packages/yum/yumRepo.py 找到remote “remote = url + ‘/’+ relative”把/改为源文件的目录如：/yum
####配置好后先清一下缓存：
    yum clean all
####然后测试下：
      yum list
####安装某个包试试：
    yum install httpd-xxx.rpm~        


###利用镜像文件做yum源
    1 mkdir /media/iso
    2 mkdir /media/yum
    3 mount –t iso9660 –o loop /path/image.iso /media/cdrom
    4 createrepo -o /media/yum/ -g /media/cdrom/Server/repodata/comps-rhel5-server-core.xml /media/cdrom/Server/
>解释下这句话： 主要作用是依据comps-rhel5-server-core.xml组文件创建/media.cdrom/Server软件包依赖关系 输出到/media/yum 中
###5  在/etc/yum.repo/ 下建个repo文件
    [iso]
    name=local yum
    baseurl=file:///media/cdrom/Server
    enable=1
    gpgcheck=0
###测试下：
####先yum clean all 清下缓存
    yum install bind
####如果不成功
    mount –bind /media/yum/repodata /media/cdrom/Server/repodata                                    
>在centos下 repodata目录不是放在rpm包同一个目录下的 如果你在repo文件中指定路径到rpm包 会提示找不到repomd.xml这个文件 解决方法就是将路径直到上一层 即repodata目录所在的目录。yum程序 会自动往下查找的
