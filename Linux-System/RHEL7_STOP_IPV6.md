 
1.	RHEL 7 & CentOS 7禁用IPV6
标签： RHEL 7CentOS 7IPV6
2014-11-24 08:53 49286人阅读 评论(1) 收藏 举报
版权声明：本文为博主原创文章，未经博主允许不得转载。
RHEL 7 & CentOS 7下禁用IPV6的方法和之前的版本不太一样了，本文整理了一下处理方法：本文原文出处: http://blog.csdn.net/bluishglc/article/details/41390785 严禁任何形式的转载，否则将委托CSDN官方维护权益！

首先，我们必须给出最根本的解决方法：修改grub，在引导时就不加载IPV6模块

 

这样修改之后，使用

# lsmod | grep ipv6

进行验证！

下面我们再看一种处理方式，它不如上面提到的方式彻底，但也是有效的！
•	验证IPV6是否关闭

1. 通过命令：

Check to see if you’re installation is currently set up for IPv6:


# cat /proc/sys/net/ipv6/conf/all/disable_ipv6

If the output is 0, IPv6 is enabled.

If the output is 1, IPv6 is already disabled.

需要特别说明的是：在这种方法下，使用# lsmod | grep ipv6依然会有一些相关模块列出。


2. 通过ifconfig查看网卡信息，以下打开和关闭ipv6的差别：
 

•	禁用IPV6的操作步骤
Step 1: add this rule in /etc/sysctl.conf : net.ipv6.conf.all.disable_ipv6=1

Step 2: add this rule in /etc/sysconfig/network: NETWORKING_IPV6=no

Step 3: add this setting for each nic X (X is the corresponding number for each nic) in /etc/sysconfig/network-scripts/ifcfg-ethX: IPV6INIT=no

Step 4: disable the ip6tables service : chkconfig ip6tables off

Step 5: Reload the sysctl configuration:

# sysctl -p
or
# reboot

注意：禁用IPV6后，可能会导致某些服务无法启动,比如VSFTP，对于VSFTP，需要修改/etc/vsftpd/vsftpd.conf文件中的listen和listen_ipv6两个选项：
listen=YES
listen_ipv6=NO


2.	如何在CentOS 7中禁止IPv6

 
你可以用两个方法做到这个。
1.1.1	方法 1
编辑文件/etc/sysctl.conf，
1.	vi /etc/sysctl.conf
添加下面的行：
1.	net.ipv6.conf.all.disable_ipv6 = 1
2.	net.ipv6.conf.default.disable_ipv6 = 1
如果你想要为特定的网卡禁止IPv6，比如，对于enp0s3，添加下面的行。
1.	net.ipv6.conf.enp0s3.disable_ipv6 = 1
保存并退出文件。
执行下面的命令来使设置生效。
1.	sysctl -p
1.1.2	方法 2
要在运行的系统中禁止IPv6，依次输入下面的命令：
1.	echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
2.	echo 1 > /proc/sys/net/ipv6/conf/default/disable_ipv6
或者，
1.	sysctl -w net.ipv6.conf.all.disable_ipv6=1
2.	sysctl -w net.ipv6.conf.default.disable_ipv6=1
就是这样。现在IPv6已经禁止了。
1.1.3	我在禁止IPv6后遇到问题怎么办
你可能在禁止IPv6后遇到一些问题
1.1.3.1	问题1：
如果你在禁止IPv6后SSH遇到问题，按照下面的做。
编辑 /etc/ssh/sshd_config 文件
vi /etc/ssh/sshd_config
找到下面的行：
1.	#AddressFamily any
把它改成：
1.	AddressFamily inet
或者，在这行的前面去掉注释(#)：
1.	#ListenAddress 0.0.0.0
接着重启ssh来使改变生效。
1.	systemctl restart sshd
1.1.3.2	问题2：
如果你在禁止Ipv6后启动postfix遇到问题，编辑/etc/postfix/main.cf：
1.	vi /etc/postfix/main.cf
注释掉配置中的localhost部分，并且使用ipv4回环。
1.	#inet_interfaces = localhost
2.	inet_interfaces = 127.0.0.1
就是这样，干杯！

