##Amap服务枚举工具

## 命令使用:

#### 扫描指定端口内正在运行的应用
    amap -bq 192.168.1.6 200-500

## amap help
    amap v5.4 (c) 2011 by van Hauser <vh@thc.org> www.thc.org/thc-amap
    Syntax: amap [-A|-B|-P|-W] [-1buSRHUdqv] [[-m] -o <file>] [-D <file>] [-t/-T sec] [-c cons] [
    -C retries] [-p proto] [-i <file>] [target port [port] ...]Modes:
      -A         Map applications: send triggers and analyse responses (default)
      -B         Just grab banners, do not send triggers
      -P         No banner or application stuff - be a (full connect) port scanner
    Options:
      -1         Only send triggers to a port until 1st identification. Speeeeed!
      -6         Use IPv6 instead of IPv4
      -b         Print ascii banner of responses
      -i FILE    Nmap machine readable outputfile to read ports from
      -u         Ports specified on commandline are UDP (default is TCP)
      -R         Do NOT identify RPC service
      -H         Do NOT send application triggers marked as potentially harmful
      -U         Do NOT dump unrecognised responses (better for scripting)
      -d         Dump all responses
      -v         Verbose mode, use twice (or more!) for debug (not recommended :-)
      -q         Do not report closed ports, and do not print them as unidentified
      -o FILE [-m] Write output to file FILE, -m creates machine readable output
      -c CONS    Amount of parallel connections to make (default 32, max 256)
      -C RETRIES Number of reconnects on connect timeouts (see -T) (default 3)
      -T SEC     Connect timeout on connection attempts in seconds (default 5)
      -t SEC     Response wait timeout in seconds (default 5)
      -p PROTO   Only send triggers for this protocol (e.g. ftp)
      TARGET PORT   The target address and port(s) to scan (additional to -i)
    amap is a tool to identify application protocols on target ports.
    Note: this version was NOT compiled with SSL support!
    Usage hint: Options "-bqv" are recommended, add "-1" for fast/rush checks.
