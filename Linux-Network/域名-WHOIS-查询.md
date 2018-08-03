##域名 WHOIS 查询

### dmitry 命令
    # 可以使用这个命令做个域名过期检测工具
    dmitry -w jsqix.com -o jsqix.com.txt
    grep 'Expiration Date' jsqix.com.txt.txt
       Expiration Date: 19-dec-2017

    dmitry -w zhaoka.com

    HostIP:122.224.178.105
    HostName:zhaoka.com

    Gathered Inic-whois information for zhaoka.com
    ---------------------------------

       Domain Name: ZHAOKA.COM
       Registrar: HICHINA ZHICHENG TECHNOLOGY LTD.
       Sponsoring Registrar IANA ID: 420
       Whois Server: grs-whois.hichina.com
       Referral URL: http://www.net.cn
       Name Server: NS1.DNSV2.COM
       Name Server: NS2.DNSV2.COM
       Status: ok https://icann.org/epp#ok
       Updated Date: 12-apr-2017
       Creation Date: 18-apr-2005
       Expiration Date: 18-apr-2018

### 也可扫描端口
    dmitry -npb www.jzgxt.net


    Deepmagic Information Gathering Tool
    "There be some deep magic going on"

    HostIP:120.76.55.115
    HostName:www.jzgxt.net

    Gathered Netcraft information for www.jzgxt.net
    ---------------------------------

    Retrieving Netcraft.com information for www.jzgxt.net
    Netcraft.com Information gathered

    Gathered TCP Port information for 120.76.55.115
    ---------------------------------

     Port		State

    80/tcp		open

    Portscan Finished: Scanned 150 ports, 148 ports were in state closed

### 帮助
    Deepmagic Information Gathering Tool
    "There be some deep magic going on"

    Usage: dmitry [-winsepfb] [-t 0-9] [-o %host.txt] host
      -o	 Save output to %host.txt or to file specified by -o file
      -i	 Perform a whois lookup on the IP address of a host
      -w	 Perform a whois lookup on the domain name of a host
      -n	 Retrieve Netcraft.com information on a host
      -s	 Perform a search for possible subdomains
      -e	 Perform a search for possible email addresses
      -p	 Perform a TCP port scan on a host
    * -f	 Perform a TCP port scan on a host showing output reporting filtered ports
    * -b	 Read in the banner received from the scanned port
    * -t 0-9 Set the TTL in seconds when scanning a TCP port ( Default 2 )
    *Requires the -p flagged to be passed
