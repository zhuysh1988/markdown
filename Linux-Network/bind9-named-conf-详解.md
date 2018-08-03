##bind9 named.conf 详解
###acl：定义IP地址表的名字,用于访问控制等
####语法:
    acl acl-name {
        address_match_list;
    }
##controls：宣告一个用于rndc工具控制通道
###语法:
    controls {
      [ inet ( ip_addr | * ) [ port ip_port ] allow {  address_match_list  }
                    keys { key_list }; ]
      [ inet ...; ]
      [ unix path perm number owner number group number keys { key_list }; ]
      [ unix ...; ]
    };


##include：包含一个文件
###语法:
    include filename;
##key：定义key信息用于验证和TSIG验证
###语法:
    key key_id {
        algorithm string;
        secret string;
    };
##logging：定义bing服务的日志, channel -> categroy.
###语法:
    logging {
      [ channel channel_name {
        ( file path name
            [ versions ( number | unlimited ) ]
            [ size size spec ]
          | syslog syslog_facility
          | stderr
          | null );
        [ severity (critical | error | warning | notice |
                    info | debug [ level ] | dynamic ); ]
        [ print-category yes or no; ]
        [ print-severity yes or no; ]
        [ print-time yes or no; ]
      }; ]
      [ category category_name {
        channel_name ; [ channel_name ; ... ]
      }; ]
      ...
    };

##category 参数:
    default: 默认分类,没有分类的日志都使用这个分类的配置.
    general: 没有分类的日志都记录在此分类中.
    database: 服务器内部使用存储zone和缓存数据.
    security: 允许/拒绝的请求.
    config: 配置文件分析和处理.
    resolver: DNS解析,被dns缓存服务器进行递归查询.
    xfer-in: 接收区域传输.
    xfer-out: 发送区域传输.
    notify: NOTIFY协议.
    client: 客户端请求进程.
    unmatched: 未匹配的查询?
    network: 网络操作.
    update: 动态更新.
    update-security: 允许/拒绝更新请求.
    queries: 客户端队列日志.
    dispatch: 数据包传送日志.
    dnssec: DNSSEC和TSIG协议处理.
    lame-servers: 远端的配置错误的服务器发送的请求.
    delegation-only: NXDOMAIN的结果将被强制定义到delegation-only区域
##lwres：定义named为一个轻量级的解析进程
###语法:
    lwres {
        [ listen-on { ip_addr [port ip_port] ; [ ip_addr [port ip_port] ; ... ] }; ]
        [ view view_name; ]
        [ search { domain_name ; [ domain_name ; ... ] }; ]
        [ ndots number; ]
    };
##masters：定义主域服务器列表
###语法:
    masters name [port ip_port] { ( masters_list | ip_addr [port ip_port] [key key] ) ; [...] };
##options：设定全局配置选项和默认值
###语法:
    options {
        [ version version_string; ]
        [ hostname hostname_string; ]
        [ server-id server_id_string; ]
        [ directory path_name; ]
        [ key-directory path_name; ]
        [ named-xfer path_name; ]
        [ tkey-domain domainname; ]
        [ tkey-dhkey key_name key_tag; ]
        [ cache-file path_name; ]
        [ dump-file path_name; ]
        [ memstatistics-file path_name; ]
        [ pid-file path_name; ]
        [ statistics-file path_name; ]
        [ zone-statistics yes_or_no; ]
        [ auth-nxdomain yes_or_no; ]
        [ deallocate-on-exit yes_or_no; ]
        [ dialup dialup_option; ]
        [ fake-iquery yes_or_no; ]
        [ fetch-glue yes_or_no; ]
        [ flush-zones-on-shutdown yes_or_no; ]
        [ has-old-clients yes_or_no; ]
        [ host-statistics yes_or_no; ]
        [ host-statistics-max number; ]
        [ minimal-responses yes_or_no; ]
        [ multiple-cnames yes_or_no; ]
        [ notify yes_or_no | explicit | master-only; ]
        [ recursion yes_or_no; ]
        [ rfc2308-type1 yes_or_no; ]
        [ use-id-pool yes_or_no; ]
        [ maintain-ixfr-base yes_or_no; ]
        [ dnssec-enable yes_or_no; ]
        [ dnssec-validation yes_or_no; ]
        [ dnssec-lookaside domain trust-anchor domain; ]
        [ dnssec-must-be-secure domain yes_or_no; ]
        [ dnssec-accept-expired yes_or_no; ]
        [ forward ( only | first ); ]
        [ forwarders { [ ip_addr [port ip_port] ; ... ] }; ]
        [ dual-stack-servers [port ip_port] {
            ( domain_name [port ip_port] |
              ip_addr [port ip_port] ) ;
            ... }; ]
        [ check-names ( master | slave | response )
            ( warn | fail | ignore ); ]
        [ check-mx ( warn | fail | ignore ); ]
        [ check-wildcard yes_or_no; ]
        [ check-integrity yes_or_no; ]
        [ check-mx-cname ( warn | fail | ignore ); ]
        [ check-srv-cname ( warn | fail | ignore ); ]
        [ check-sibling yes_or_no; ]
        [ allow-notify { address_match_list }; ]
        [ allow-query { address_match_list }; ]
        [ allow-query-cache { address_match_list }; ]
        [ allow-transfer { address_match_list }; ]
        [ allow-recursion { address_match_list }; ]
        [ allow-update { address_match_list }; ]
        [ allow-update-forwarding { address_match_list }; ]
        [ update-check-ksk yes_or_no; ]
        [ allow-v6-synthesis { address_match_list }; ]
        [ blackhole { address_match_list }; ]
        [ avoid-v4-udp-ports { port_list }; ]
        [ avoid-v6-udp-ports { port_list }; ]
        [ listen-on [ port ip_port ] { address_match_list }; ]
        [ listen-on-v6 [ port ip_port ] { address_match_list }; ]
        [ query-source ( ( ip4_addr | * )
            [ port ( ip_port | * ) ] |
            [ address ( ip4_addr | * ) ]
            [ port ( ip_port | * ) ] ) ; ]
        [ query-source-v6 ( ( ip6_addr | * )
            [ port ( ip_port | * ) ] |
            [ address ( ip6_addr | * ) ]
            [ port ( ip_port | * ) ] ) ; ]
        [ max-transfer-time-in number; ]
        [ max-transfer-time-out number; ]
        [ max-transfer-idle-in number; ]
        [ max-transfer-idle-out number; ]
        [ tcp-clients number; ]
        [ recursive-clients number; ]
        [ serial-query-rate number; ]
        [ serial-queries number; ]
        [ tcp-listen-queue number; ]
        [ transfer-format ( one-answer | many-answers ); ]
        [ transfers-in  number; ]
        [ transfers-out number; ]
        [ transfers-per-ns number; ]
        [ transfer-source (ip4_addr | *) [port ip_port] ; ]
        [ transfer-source-v6 (ip6_addr | *) [port ip_port] ; ]
        [ alt-transfer-source (ip4_addr | *) [port ip_port] ; ]
        [ alt-transfer-source-v6 (ip6_addr | *) [port ip_port] ; ]
        [ use-alt-transfer-source yes_or_no; ]
        [ notify-source (ip4_addr | *) [port ip_port] ; ]
