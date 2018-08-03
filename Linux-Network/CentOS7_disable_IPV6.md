### 关闭CentOS 7支持的IPV6
#### 在GRUB_CMDLINE_LINUX="后加入ipv6.desable=1"
	cat /etc/default/grub
	GRUB_TIMEOUT=5
	GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
	GRUB_DEFAULT=saved
	GRUB_DISABLE_SUBMENU=true
	GRUB_TERMINAL_OUTPUT="console"
	GRUB_CMDLINE_LINUX="ipv6.disable=1 rd.lvm.lv=cl/root rd.lvm.lv=cl/swap rhgb quiet"
	GRUB_DISABLE_RECOVERY="true"
### 重新配置 grub
	grub2-mkconfig -o /boot/grub2/grub.cfg
### 重启系统
	reboot
### 验证
#### 1 检查系统监听端口
    netstat -luntp # 会发现只有ipv4
#### 2 查检系统mod
    lsmod |grep ipv6

##禁用IPV6的操作步骤
### Step 1: add this rule in /etc/sysctl.conf :
	net.ipv6.conf.all.disable_ipv6=1

### Step 2: add this rule in /etc/sysconfig/network:
	NETWORKING_IPV6=no

### Step 3: add this setting for each nic X (X is the corresponding number for each nic) in /etc/sysconfig/network-scripts/ifcfg-ethX:
	IPV6INIT=no

### Step 4: disable the ip6tables service :
	chkconfig ip6tables off

### Step 5: Reload the sysctl configuration:

	sysctl -p
	OR
	reboot

>注意：禁用IPV6后，可能会导致某些服务无法启动,比如VSFTP，对于VSFTP，需要修改/etc/vsftpd/vsftpd.conf文件中的listen和listen_ipv6两个选项：
	listen=YES
	listen_ipv6=NO
