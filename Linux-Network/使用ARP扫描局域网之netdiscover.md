## 使用ARP扫描局域网之netdiscover

### 命令使用:
    netdiscover -i wlan0 -r 192.168.1.0/24 -f -PL
### netdiscover --help

    netdiscover: invalid option -- '-'

    Netdiscover 0.3-pre-beta7 [Active/passive arp reconnaissance tool]
    Written by: Jaime Penalba <jpenalbae@gmail.com>

    Usage: netdiscover [-i device] [-r range | -l file | -p] [-m file] [-s time] [-n node] [-c co
    unt] [-f] [-d] [-S] [-P] [-c]  -i device: your network device
      -r range: scan a given range instead of auto scan. 192.168.6.0/24,/16,/8
      -l file: scan the list of ranges contained into the given file
      -p passive mode: do not send anything, only sniff
      -m file: scan the list of known MACs and host names
      -F filter: Customize pcap filter expression (default: "arp")
      -s time: time to sleep between each arp request (milliseconds)
      -n node: last ip octet used for scanning (from 2 to 253)
      -c count: number of times to send each arp reques (for nets with packet loss)
      -f enable fastmode scan, saves a lot of time, recommended for auto
      -d ignore home config files for autoscan and fast mode
      -S enable sleep time supression between each request (hardcore mode)
      -P print results in a format suitable for parsing by another program
      -N Do not print header. Only valid when -P is enabled.
      -L in parsable output mode (-P), continue listening after the active scan is completed

    If -r, -l or -p are not enabled, netdiscover will scan for common lan addresses.
