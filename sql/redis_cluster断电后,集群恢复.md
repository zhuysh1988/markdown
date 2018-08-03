redis_cluster断电后,集群恢复

    [redis@server_192 ~]$ redis-trib.rb check 192.168.1.190:6379
    >>> Performing Cluster Check (using node 192.168.1.190:6379)
    M: ec37438ed48c8b19f1057dbc58ba3c68b56cb3cd 192.168.1.190:6379
       slots:10923-16383 (5461 slots) master
       1 additional replica(s)
    M: 21a16aad0ef1e7b0607a39847bb3d913c3f7aca7 192.168.1.191:6379
       slots:5461-10922 (5462 slots) master
       1 additional replica(s)
    S: 986e7ba8425fbb480c8d9eb1835cf5dc18aac48e 192.168.1.191:6400
       slots: (0 slots) slave
       replicates 3449baf019b7eed2288dcbb21b302b4c177e5ee4
    S: 83ead1851423757f38d896e358311c64401bd68b 192.168.1.192:6400
       slots: (0 slots) slave
       replicates 21a16aad0ef1e7b0607a39847bb3d913c3f7aca7
    S: 26c768e8ed47ae8a002dbb1328da41d8d53d96b5 192.168.1.190:6400
       slots: (0 slots) slave
       replicates ec37438ed48c8b19f1057dbc58ba3c68b56cb3cd
    M: 3449baf019b7eed2288dcbb21b302b4c177e5ee4 192.168.1.192:6379
       slots:0-5460 (5461 slots) master
       1 additional replica(s)
    [OK] All nodes agree about slots configuration.
    >>> Check for open slots...
    会出现以下 警告
    [WARNING] Node 192.168.1.191:6379 has slots in importing state (5270,1207).
    [WARNING] Node 192.168.1.192:6379 has slots in importing state (9329).
    [WARNING] The following slots are open: 5270,1207,9329
    >>> Check slots coverage...
    [OK] All 16384 slots covered.

断电后,只需把所有节点开启,集群自动恢复

新建集群:

    redis-trib.rb create --replicas 1 192.168.1.190:6379 192.168.1.190:6400 192.168.1.191:6379 192.168.1.191:6400 192.168.1.192:6379 192.168.1.192:6400
检查集群:

    redis-trib.rb check 192.168.1.190:6379

修复警告:

    redis-cli -c -h 192.168.1.191 -p 6379
    auth 'pass'
    cluster setslot 5270 stable
    cluster setslot 1207 stable

    redis-cli -c -h 192.168.1.192 -p 6379
    auth 'pass'
    cluster setslot 9329 stable
