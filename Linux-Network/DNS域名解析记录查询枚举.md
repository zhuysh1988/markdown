##DNS域名解析记录查询枚举

### 示例域名: zhaoka.com
### 字典文件: zhaoka.com.txt

### DNSenum 命令:
#### 基本使用:
    dnsenum zhaoka.com
    dnsenum --enum zhaoka.com
    dnsenum  zhaoka.com -f zhaoka.com.txt --threads 5

####  命令帮助:
    dnsenum.pl VERSION:1.2.3
    Usage: dnsenum.pl [Options] <domain>
    [Options]:
    Note: the brute force -f switch is obligatory.
    GENERAL OPTIONS:
      --dnsserver 	<server>
    			Use this DNS server for A, NS and MX queries.
      --enum		Shortcut option equivalent to --threads 5 -s 15 -w.
      -h, --help		Print this help message.
      --noreverse		Skip the reverse lookup operations.
      --nocolor		Disable ANSIColor output.
      --private		Show and save private ips at the end of the file domain_ips.txt.
      --subfile <file>	Write all valid subdomains to this file.
      -t, --timeout <value>	The tcp and udp timeout values in seconds (default: 10s).
      --threads <value>	The number of threads that will perform different queries.
      -v, --verbose		Be verbose: show all the progress and all the error messages.
    GOOGLE SCRAPING OPTIONS:
      -p, --pages <value>	The number of google search pages to process when scraping names,
    			the default is 5 pages, the -s switch must be specified.
      -s, --scrap <value>	The maximum number of subdomains that will be scraped from Google (default 15).
    BRUTE FORCE OPTIONS:
      -f, --file <file>	Read subdomains from this file to perform brute force.
      -u, --update	<a|g|r|z>
    			Update the file specified with the -f switch with valid subdomains.
    	a (all)		Update using all results.
    	g		Update using only google scraping results.
    	r		Update using only reverse lookup results.
    	z		Update using only zonetransfer results.
      -r, --recursion	Recursion on subdomains, brute force all discovred subdomains that have an NS record.
    WHOIS NETRANGE OPTIONS:
      -d, --delay <value>	The maximum value of seconds to wait between whois queries, the value is defined randomly, default:
     3s.  -w, --whois		Perform the whois queries on c class network ranges.
    			 **Warning**: this can generate very large netranges and it will take lot of time to performe rever
    se lookups.REVERSE LOOKUP OPTIONS:
      -e, --exclude	<regexp>
    			Exclude PTR records that match the regexp expression from reverse lookup results, useful on invalid
     hostnames.OUTPUT OPTIONS:
      -o --output <file>	Output in XML format. Can be imported in MagicTree (www.gremwell.com)


### fierce 命令
#### 简单使用:
    fierce -dns zhaoka.com
#### 使用字典
    fierce -dns zhaoka.com -wordlist zhaoka.com.txt
#### 多线程/指定DNS服务器/使用字典
    # 只扫出 ns 记录其它都没扫出来
    fierce -dns zhaoka.com -dnsserver 180.76.76.76 -threads 5 -wordlist zhaoka.com.txt
#### range 用法 (没试出来怎么用)
    fierce -range 192.168.1.0-255 -dnsserver 192.168.1.8
####  命令帮助:
    Options:
    	-connect	Attempt to make http connections to any non RFC1918
    		(public) addresses.  This will output the return headers but
    		be warned, this could take a long time against a company with
    		many targets, depending on network/machine lag.  I wouldn't
    		recommend doing this unless it's a small company or you have a
    		lot of free time on your hands (could take hours-days).
    		Inside the file specified the text "Host:\n" will be replaced
    		by the host specified. Usage:

    	perl fierce.pl -dns example.com -connect headers.txt

    	-delay		The number of seconds to wait between lookups.
    	-dns		The domain you would like scanned.
    	-dnsfile  	Use DNS servers provided by a file (one per line) for
                    reverse lookups (brute force).
    	-dnsserver	Use a particular DNS server for reverse lookups
    		(probably should be the DNS server of the target).  Fierce
    		uses your DNS server for the initial SOA query and then uses
    		the target's DNS server for all additional queries by default.
    	-file		A file you would like to output to be logged to.
    	-fulloutput	When combined with -connect this will output everything
    		the webserver sends back, not just the HTTP headers.
    	-help		This screen.
    	-nopattern	Don't use a search pattern when looking for nearby
    		hosts.  Instead dump everything.  This is really noisy but
    		is useful for finding other domains that spammers might be
    		using.  It will also give you lots of false positives,
    		especially on large domains.
    	-range		Scan an internal IP range (must be combined with
    		-dnsserver).  Note, that this does not support a pattern
    		and will simply output anything it finds.  Usage:

    	perl fierce.pl -range 111.222.333.0-255 -dnsserver ns1.example.co

    	-search		Search list.  When fierce attempts to traverse up and
    		down ipspace it may encounter other servers within other
    		domains that may belong to the same company.  If you supply a
    		comma delimited list to fierce it will report anything found.
    		This is especially useful if the corporate servers are named
    		different from the public facing website.  Usage:

    	perl fierce.pl -dns examplecompany.com -search corpcompany,blahcompany

    		Note that using search could also greatly expand the number of
    		hosts found, as it will continue to traverse once it locates
    		servers that you specified in your search list.  The more the
    		better.
    	-suppress	Suppress all TTY output (when combined with -file).
    	-tcptimeout	Specify a different timeout (default 10 seconds).  You
    		may want to increase this if the DNS server you are querying
    		is slow or has a lot of network lag.
    	-threads  Specify how many threads to use while scanning (default
    	  is single threaded).
    	-traverse	Specify a number of IPs above and below whatever IP you
    		have found to look for nearby IPs.  Default is 5 above and
    		below.  Traverse will not move into other C blocks.
    	-version	Output the version number.
    	-wide		Scan the entire class C after finding any matching
    		hostnames in that class C.  This generates a lot more traffic
    		but can uncover a lot more information.
    	-wordlist	Use a seperate wordlist (one word per line).  Usage:

    	perl fierce.pl -dns examplecompany.com -wordlist dictionary.txt



### host 命令:
#### 查询 NS 记录 (域名解析服务器)
    host -t ns zhaoka.com
    zhaoka.com name server ns2.dnsv2.com.
    zhaoka.com name server ns1.dnsv2.com.
#### 查询 A 记录
    host -t a zhaoka.com
    zhaoka.com has address 122.224.178.105
#### 查询 MX 记录
    host -t mx zhaoka.com
    zhaoka.com mail is handled by 5 mail.jsqix.com.
####  命令帮助:
    host --help
    host: illegal option -- -
    Usage: host [-aCdlriTwv] [-c class] [-N ndots] [-t type] [-
    W time]            [-R number] [-m flag] hostname [server]
           -a is equivalent to -v -t ANY
           -c specifies query class for non-IN data
           -C compares SOA records on authoritative nameservers
           -d is equivalent to -v
           -l lists all hosts in a domain, using AXFR
           -i IP6.INT reverse lookups
           -N changes the number of dots allowed before root lo
    okup is done       -r disables recursive processing
           -R specifies number of retries for UDP packets
           -s a SERVFAIL response should stop query
           -t specifies the query type
           -T enables TCP/IP mode
           -v enables verbose output
           -w specifies to wait forever for a reply
           -W specifies how long to wait for a reply
           -4 use IPv4 query transport only
           -6 use IPv6 query transport only
           -m set memory debugging flag (trace|record|usage)
           -V print version number and exit
