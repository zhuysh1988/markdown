## netstat 查找网络连接
###Linux
    netstat -aon |grep '192.168.1.1:443'
    ss -aon |grep '192.168.1.1:443'    
###Windows
    netstat -aon |findstr '192.168.1.1:443'
    netstat -aonp TCP | where { $_ -match "192.168.1.1:443"}

##取时间格式化后的字符
### Windows
    get-date -uformat "%Y%m%d%H%M%S"
