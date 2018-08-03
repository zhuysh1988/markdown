最近公司需要准备一个测试环境，刚好用到Oracle，这里选择了oracle11g R2版本。

本次安装为实体机，当然实体机虚拟机并不影响此次安装操作步骤。

准备：

环境 CentOS release 6.7

建好 oracle 用户 设置好密码

准备的环境可以上网，如不能上网，就根据文中的提示，下载所需的包上传手工安装。

VNC主要是用于远程桌面控制，所以我们的思路是装vnc需要把一些桌面环境，字体包全部装好。

#一 检查环境
    rpm -qa |grep vnc
    如果没有输出信息说明没有安装vnc软件
#二 安装vnc server
2.1 cnetos利用自带的yum安装

    yum install tigervnc-server -y

2.2 再次检查

    rpm -qa |grep vnc

    tigervnc-server-1.1.0-18.el6.x86_64

#三、安装桌面环境
3.1 安装gnome

    yum install gnome -y

#四、配置VNC
    为了防黑屏，需要修改一下/root/.vnc/xstartup
4.1

    vim /etc/sysconfig/vncservers
    添加
    VNCSERVERS="1:root"
    VNCSERVERARGS[2]="-geometry 800x600 -nolisten tcp -localhost"
    VNCSERVERS="2:oracle"
    VNCSERVERARGS[2]="-geometry 1024x768  -nolisten tcp -localhost"

4.2

    vim /home/oracle/.vnc/xstartup
    # 说明：使用的是gnome图像界面，则需要注释掉以下两行,
    # xterm -geometry 80x24+10+10 -ls -title “$VNCDESKTOP Desktop” &
    # twm &
    #并添加以下这行：
    gnome-session &


    #如果没有这个文件,则运行以下命令
    su - oracle
    vncpass oracle  # 设置vnc连接密码
    vncserver  # 输入vnc密码
    再返至上面 vim /home/oracle/.vnc/xstartup

    退回至 root
    /etc/init.d/vncserver restart

4.3 变更xstartup的权限

很多利用vnc连接发现黑屏问题，很大一个原因是xtartup的权限不够。

    授权：chmod 777 /home/oracle/.vnc/xstartup


#五、防火墙设置

vncserver启动后，默认是5901端口，这里也跟sysctl里设置有关系。

可以根据实际启动的端口进行设置，这个步骤可以在vncserver启动之前，也可以在启动之后。

    iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 5901 -j ACCEPT

#六、安装vnc客户端
在windows下安装vnc客户端 ，下载地址：<http://pan.baidu.com/s/1pJFkIIB> ；

软件包名称，RealVNC_cngr.rar，windows安装vnc viewer省略。

#七 打开vnc viewer

我这里使用的外网，是因为我的windows机器不能直连idc的内网，当然如果你们使用了vpn打通，

或者使用其它任何方式可以直接ping通内网，完全不需要外网连接。

点击connect后，输入密码，该密码即前面设置的vnc访问密码

    VNC Server IP:5901
