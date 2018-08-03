## weblogic 启动慢解决
>创建域慢启动慢的特征：创建域到70%时，进程长时间等待（命令行创建时停止在100%处），创建域启动Weblogic的时候也是长时间停止。 

>Weblogic在Linux下启动慢的原因，发现从进程堆来看，线程挂在security相关的随机数生成上面，是由于JDK的Bug(JDK从/dev/random读取‘randomness’经常耗费10分钟或者更长的时间)，查询了下相关资料，解决办法可以有如下三种办法： 


### 1）较好的解决办法： 在Weblogic启动参数里添加 “- 

    Djava.security.egd=file:/dev/./urandom” (/dev/urandom 无法启动) 

### 2）最差的解决办法： 执行命令 mv /dev/random /dev/random.ORIG ; ln /dev/urandom /dev/random 

    将/dev/random 指向/dev/urandom 

### 3)最好的解决办法: 修改Linux上Weblogic使用的jdk $JAVA_HOME/jre/lib/security/java.security 文件 

    将securerandom.source=file:/dev/urandom 修改为 

    securerandom.source=file:/dev/./urandom 

>这样可以解决任何一个域Weblogic启动慢的问题。 

>此外由于Weblogic创建域的时候使用的JDK是自带的jrockit，所以要解决WebLogic在Linux上创建域慢的问题，解决办法如下： 

#####修改Linux上Weblogic使用的jdk $JROCKIT_HOME/jre/lib/security/java.security 文件 

#####将securerandom.source=file:/dev/urandom 修改为 

######securerandom.source=file:/dev/./urandom 