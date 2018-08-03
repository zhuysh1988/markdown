## SNMP 服务枚举

>用处不大,现在服务器上都会配置只允许哪些IP访问本机的SNMP服务

### snmpcheck 命令使用:
    没试出来怎么用


### snmpwalk 命令使用:
    # 查找 FTP
    snmpwalk -c public 192.168.1.99 -v 1 |grep ftp
    # 查找 开放的TCP端口
    snmpwalk -c public 192.168.1.99 -v 1 |grep tcpConnState|cut -d "." -f6 |sort -nu
    # 扫描交换机
    snmpwalk -c public 192.168.1.2 -v 2c >snmp.log
####snmp.log 内容:
    so.3.6.1.2.1.1.1.0 = STRING: "H3C Switch S5024PV2-EI Software Version 5.20.99, Release 1106^M
    Copyright(c)2004-2015 Hangzhou H3C Tech. Co., Ltd. All rights reserved."
    iso.3.6.1.2.1.1.2.0 = OID: iso.3.6.1.4.1.25506.1.927
    iso.3.6.1.2.1.1.3.0 = Timeticks: (1364244768) 157 days, 21:34:07.68
    iso.3.6.1.2.1.1.4.0 = STRING: "Hangzhou H3C Technologies Co., Ltd."
    iso.3.6.1.2.1.1.5.0 = STRING: "H3C"
    iso.3.6.1.2.1.1.6.0 = STRING: "Hangzhou, China"
    .....
    iso.3.6.1.2.1.3.1.1.1.30.1.192.168.1.1 = INTEGER: 30
    iso.3.6.1.2.1.3.1.1.1.30.1.192.168.1.4 = INTEGER: 30
    ...
#### 命令帮助:
    OPTIONS:
      -h, --help		display this help message
      -H			display configuration file directives understood
      -v 1|2c|3		specifies SNMP version to use
      -V, --version		display package version number
    SNMP Version 1 or 2c specific
      -c COMMUNITY		set the community string
    SNMP Version 3 specific
      -a PROTOCOL		set authentication protocol (MD5|SHA)
      -A PASSPHRASE		set authentication protocol pass phrase
      -e ENGINE-ID		set security engine ID (e.g. 800000020109840301)
      -E ENGINE-ID		set context engine ID (e.g. 800000020109840301)
      -l LEVEL		set security level (noAuthNoPriv|authNoPriv|authPriv)
      -n CONTEXT		set context name (e.g. bridge1)
      -u USER-NAME		set security name (e.g. bert)
      -x PROTOCOL		set privacy protocol (DES|AES)
      -X PASSPHRASE		set privacy protocol pass phrase
      -Z BOOTS,TIME		set destination engine boots/time
    General communication options
      -r RETRIES		set the number of retries
      -t TIMEOUT		set the request timeout (in seconds)
    Debugging
      -d			dump input/output packets in hexadecimal
      -D[TOKEN[,...]]	turn on debugging output for the specified TOKENs
    			   (ALL gives extremely verbose debugging output)
    General options
      -m MIB[:...]		load given list of MIBs (ALL loads everything)
      -M DIR[:...]		look in given list of directories for MIBs
        (default: $HOME/.snmp/mibs:/usr/share/snmp/mibs:/usr/share/snmp/mibs/iana:/usr/share/snmp/mibs/ietf:/usr/share/mibs/site:/usr/share/snmp/
    mibs:/usr/share/mibs/iana:/usr/share/mibs/ietf:/usr/share/mibs/netsnmp)  -P MIBOPTS		Toggle various defaults controlling MIB parsing:
    			  u:  allow the use of underlines in MIB symbols
    			  c:  disallow the use of "--" to terminate comments
    			  d:  save the DESCRIPTIONs of the MIB objects
    			  e:  disable errors when MIB symbols conflict
    			  w:  enable warnings when MIB symbols conflict
    			  W:  enable detailed warnings when MIB symbols conflict
    			  R:  replace MIB symbols from latest module
      -O OUTOPTS		Toggle various defaults controlling output display:
    			  0:  print leading 0 for single-digit hex characters
    			  a:  print all strings in ascii format
    			  b:  do not break OID indexes down
    			  e:  print enums numerically
    			  E:  escape quotes in string indices
    			  f:  print full OIDs on output
    			  n:  print OIDs numerically
    			  q:  quick print for easier parsing
    			  Q:  quick print with equal-signs
    			  s:  print only last symbolic element of OID
    			  S:  print MIB module-id plus last element
    			  t:  print timeticks unparsed as numeric integers
    			  T:  print human-readable text along with hex strings
    			  u:  print OIDs using UCD-style prefix suppression
    			  U:  don't print units
    			  v:  print values only (not OID = value)
    			  x:  print all strings in hex format
    			  X:  extended index format
      -I INOPTS		Toggle various defaults controlling input parsing:
    			  b:  do best/regex matching to find a MIB node
    			  h:  don't apply DISPLAY-HINTs
    			  r:  do not check values for range/type legality
    			  R:  do random access to OID labels
    			  u:  top-level OIDs must have '.' prefix (UCD-style)
    			  s SUFFIX:  Append all textual OIDs with SUFFIX before parsing
    			  S PREFIX:  Prepend all textual OIDs with PREFIX before parsing
      -L LOGOPTS		Toggle various defaults controlling logging:
    			  e:           log to standard error
    			  o:           log to standard output
    			  n:           don't log at all
    			  f file:      log to the specified file
    			  s facility:  log to syslog (via the specified facility)

    			  (variants)
    			  [EON] pri:   log to standard error, output or /dev/null for level 'pri' and above
    			  [EON] p1-p2: log to standard error, output or /dev/null for levels 'p1' to 'p2'
    			  [FS] pri token:    log to file/syslog for level 'pri' and above
    			  [FS] p1-p2 token:  log to file/syslog for levels 'p1' to 'p2'
      -C APPOPTS		Set various application specific behaviours:
    			  p:  print the number of variables found
    			  i:  include given OID in the search range
    			  I:  don't include the given OID, even if no results are returned
    			  c:  do not check returned OIDs are increasing
    			  t:  Display wall-clock time to complete the walk
    			  T:  Display wall-clock time to complete each request
    			  E {OID}:  End the walk at the specified OID
