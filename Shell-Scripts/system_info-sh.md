## system_info.sh
    #!/bin/bash
    ##systemcheckreport
    ##Author by NETDATA
    echo "You are logged in as `whoami`";
    if [ `whoami` != root ]; then
      echo "Must be logged on as root to run this script."
    exit
    fi
    CHECK_DATE=`date +%F`
    if [ -f checksystem$CHECK_DATE.log ]; then
        rm -rf checksystem$CHECK_DATE.log
    else 
           echo "this is file not exist"
    fi
        
    ###hardwaare information
    PV_CPUNUM=`cat /proc/cpuinfo |grep "physical id"|sort |uniq|wc -l`
    PR_CPUNUM=`cat /proc/cpuinfo |grep "processor"|wc -l`
    CORE_CPUNUM=`cat /proc/cpuinfo |grep "cores"|uniq|awk -F: '{print $2}'`
    MH_CPUNUM=`cat /proc/cpuinfo |grep MHz |uniq |awk -F: '{print $2}'`MHZ
    MEM_NUM=`dmidecode|grep -P -A5 "Memory\s+Device"|grep Size|grep -v Range | grep "MB" | wc -l` 
    MEM_Total=`cat /proc/meminfo| grep MemTotal`
    MEM_Free=`cat /proc/meminfo | grep MemFree`
    MEM_SPEED=`dmidecode|grep -A16 "Memory Device"|grep Speed | grep -v "Unknown"`
    SWAP_Total=`cat /proc/meminfo | grep SwapTotal`
    SWAP_Free=`cat /proc/meminfo | grep SwapFree`
    DISK=`df -h`
    PRODUCT_NAME=`dmidecode | grep -A10 "System Information$" |grep "Product Name:"|awk '{print $3,$4,$5}'`
    ###systeminformation
    HOST1=`hostname`
    IPADDR=`ifconfig |grep "inet addr"|grep -v "127.0.0.1" |awk -F: '{print $2}' |awk '{print $1}'`
    KERNEL_OS=`uname -r`
    DB_PORT=42401
    OS_VERSION=`head -n 1 /etc/issue`
    ENV_PATH=`env |grep PATH`
    NETST_LINNK=`netstat -anp |grep -E 'tcp|udp' | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n | awk '{printf("IP:%5s LINKS:%2d\n",$2,$1)}'`
    NETORACLE_LINK=`netstat -anp |grep $DB_PORT | grep -E 'tcp|udp' | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n | awk '{printf("IP:%5s LINKS:%2d\n",$2,$1)}'`
    USER_COUNT=`wc -l /etc/passwd`
    USER_GROUP=`wc -l /etc/group` 
    PROCESS_COUNT=`ps aux | wc -l`
    ORACLE_COUNT=`ps aux | grep oracle | wc -l`
    ###log information
    DM_ERRORLOG=`dmesg | grep -B 2 -E 'error|fail'`
    MESSAGE_ERRORLOG=`grep -B 2 -E 'error|fail' /var/log/messages`
    ###Server Source
    OS_TIME=`uptime`
    CPU_LOAD=`cat /proc/loadavg`
    IO_STAT=`iostat -x 1 3`
    #Sercuritylog log failure 3 
    FAILIP=`grep "Failed " /var/log/secure |awk  '{ print $(NF-3) }' |sort|uniq -c|awk '($1>3)'|awk '{ print $2 }'`
    LOGIN=`who`
    LASTIP=`lastb`
    ##OUTPUT
    echo "************************START CHECK SYSTEM TIME `date`*******">>checksystem$CHECK_DATE.log
    echo "************************HOST HARDWARE************************">>checksystem$CHECK_DATE.log
    echo "Hostname:$HOST1">>checksystem$CHECK_DATE.log
    echo "HostIP:$IPADDR">>checksystem$CHECK_DATE.log
    echo "HOST CPUCOUNT(PV):$PV_CPUNUM">>checksystem$CHECK_DATE.log
    echo "HOST CPUCOUNT(LG)V:$PR_CPUNUM">>checksystem$CHECK_DATE.log
    echo "HOST CPUKERNEL:">>checksystem$CHECK_DATE.log
    echo "$MH_CPUNUM">>checksystem$CHECK_DATE.log
    echo "HOST IO_STAT:">>checksystem$CHECK_DATE.log
    echo "$IO_STAT">>checksystem$CHECK_DATE.log
    echo "HOST OS_TIME:">>checksystem$CHECK_DATE.log
    echo "$OS_TIME">>checksystem$CHECK_DATE.log
    echo "HOST MEM_NUM:$MEM_NUM">>checksystem$CHECK_DATE.log
    echo "$MEM_Total">>checksystem$CHECK_DATE.log
    echo "$MEM_Free">>checksystem$CHECK_DATE.log
    echo "$SWAP_Total">>checksystem$CHECK_DATE.log
    echo "$SWAP_Free">>checksystem$CHECK_DATE.log
    echo "HOST DISK:">>checksystem$CHECK_DATE.log
    echo "`df -h`">>checksystem$CHECK_DATE.log
    echo "HOST PRODUCTNAME:$PRODUCT_NAME">>checksystem$CHECK_DATE.log
    echo "**************************************************************">>checksystem$CHECK_DATE.log
    echo "************************SYSTEM INFORMATION********************">>checksystem$CHECK_DATE.log
    echo "HOSTKERNEL:$KERNEL_OS">>checksystem$CHECK_DATE.log
    echo "HOSTVERSION:$OS_VERSION">>checksystem$CHECK_DATE.log
    echo "HOSTUSERS:$USER_COUNT">>checksystem$CHECK_DATE.log
    echo "HOSTGROUPS:$USER_GROUP">>checksystem$CHECK_DATE.log
    echo "HOSTENV:$ENV_PATH">>checksystem$CHECK_DATE.log
    echo "**************************************************************">>checksystem$CHECK_DATE.log
    echo "************************NETWORKINFORMATION********************">>checksystem$CHECK_DATE.log
    echo "$NETST_LINNK">>checksystem$CHECK_DATE.log
    echo "************************ORACLE NETWORKINFORMATION********************">>checksystem$CHECK_DATE.log
    echo "$NETORACLE_LINK">>checksystem$CHECK_DATE.log
    echo "************************PROCESS INFORMATION********************">>checksystem$CHECK_DATE.log
    echo "CURRENT SYSTEM PROCESS:$PROCESS_COUNT">>checksystem$CHECK_DATE.log
    echo "CURRENT ORACLE PROCESS:$ORACLE_COUNT">>checksystem$CHECK_DATE.log
    echo "**************************************************************">>checksystem$CHECK_DATE.log
    echo "************************Security LOGINFORMATION********************">>checksystem$CHECK_DATE.log
    echo "FAILIP(More than 3 times and failed to log on IP):">>checksystem$CHECK_DATE.log
    echo "$FAILIP">>checksystem$CHECK_DATE.log
    echo "LOGINUSER:">>checksystem$CHECK_DATE.log
    echo "$LOGIN">>checksystem$CHECK_DATE.log
    echo "LAST FAILURE LOGIN:">>checksystem$CHECK_DATE.log
    echo "$LASTIP">>checksystem$CHECK_DATE.log
    echo "**************************************************************">>checksystem$CHECK_DATE.log
    echo "************************LOGINFORMATION********************">>checksystem$CHECK_DATE.log
    echo "DMESGERRLOG:">>checksystem$CHECK_DATE.log
    echo "$DM_ERRORLOG">>checksystem$CHECK_DATE.log
    echo "MESGERRLOG:">>checksystem$CHECK_DATE.log
    echo "$MESSAGE_ERRORLOG">>checksystem$CHECK_DATE.log
