#Linux iscsi 挂载设备
tgtd server 192.168.1.111

扫描目标服务器target


    iscsiadm -m discovery -t sendtargets -p 192.168.1.111:3260

    192.16.1.111:3260,1 iqn.2004-01.com.storbridge:block02

 挂载到系统中


    iscsiadm -m node -T iqn.2004-01.com.storbridge:block02 -l


设置开机自动挂载


    iscsiadm -m node -T iqn.2004-01.com.storbridge:block02 --op update -n node.startup -v automatic
