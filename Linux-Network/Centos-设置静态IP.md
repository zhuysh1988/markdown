>如果你想要为CentOS 7中的某个网络接口设置静态IP地址，有几种不同的方法，这取决于你是否想要使用网络管理器。



>网络管理器（Network Manager）是一个动态网络的控制器与配置系统，它用于当网络设备可用时保持设备和连接开启并激活。默认情况下，CentOS/RHEL 7安装有网络管理器，并处于启用状态。

>使用下面的命令来验证网络管理器服务的状态：

    $ systemctl status NetworkManager.service
>运行以下命令来检查受网络管理器管理的网络接口：

    $ nmcli dev status 


>如果某个接口的nmcli的输出结果是“已连接”（如本例中的enp0s3），这就是说该接口受网络管理器管理。你可以轻易地为某个特定接口禁用网络管理器，以便你可以自己为它配置一个静态IP地址。

>下面将介绍在CentOS 7上为网络接口配置静态IP地址的两种方式，在例子中我们将对名为enp0s3的网络接口进行配置。

##不使用网络管理配置静态IP地址
>进入/etc/sysconfig/network-scripts目录，找到该接口的配置文件（ifcfg-enp0s3）。如果没有，请创建一个。

###修改

    “NM_CONTROLLED=no”
    表示该接口将通过该配置文件进行设置，而不是通过网络管理器进行管理。
    “ONBOOT=yes”告诉我们，系统将在启动时开启该接口。

>保存修改并使用以下命令来重启网络服务：

    # systemctl restart network.service
>现在验证接口是否配置正确：

    # ip add 


##使用网络管理器配置静态IP地址
>如果你想要使用网络管理器来管理该接口，你可以使用nmtui（网络管理器文本用户界面），它提供了在终端环境中配置配置网络管理器的方式。

>在使用nmtui之前，首先要在/etc/sysconfig/network-scripts/ifcfg-enp0s3中设置“NM_CONTROLLED=yes”。

###现在，请按以下方式安装nmtui。

    # yum install NetworkManager-tui
>然后继续去编辑enp0s3接口的网络管理器配置：

    # nmtui edit enp0s3 
>在下面的屏幕中，我们可以手动输入与/etc/sysconfig/network-scripts/ifcfg-enp0s3中所包含的内容相同的信息。

>使用箭头键在屏幕中导航，按回车选择值列表中的内容（或填入想要的内容），最后点击屏幕底部右侧的确定按钮。



>最后，重启网络服务。

    # systemctl restart network.service
