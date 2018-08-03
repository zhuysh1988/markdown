#####下面是节点galera 节点197.3.155.152异常关闭之后，197.3.155.151节点的日志：

    2016-07-07 11:05:49 1400117****4240 [Note] WSREP: (fb55d9c9, 'tcp://0.0.0.0:4567') turning message relay requesting on, nonlive peers: tcp://197.3.155.152:4567 

###发现nonlive的节点197.3.155.152

    2016-07-07 11:05:51 1400117****4240 [Note] WSREP: (fb55d9c9, 'tcp://0.0.0.0:4567') reconnecting to 51f4c07a (tcp://197.3.155.152:4567), attempt 0

###重新尝试发送一个keepalived的链接。



    2016-07-07 11:05:55 1400117****4240 [Note] WSREP: evs::proto(fb55d9c9, GATHER, view_id(REG,128a493c,122)) suspecting node: 51f4c07a

###经过5秒还没有收到响应，怀疑节点已经宕掉，51f4c07a即197.3.155.152。

    2016-07-07 11:05:55 1400117****4240 [Note] WSREP: evs::proto(fb55d9c9, GATHER, view_id(REG,128a493c,122)) suspected node without join message, declaring inactive



###宣判节点宕掉。declaring inactive



    2016-07-07 11:05:55 1400117****4240 [Note] WSREP: declaring 128a493c at tcp://197.3.155.150:4567 stable

###获取存活的节点信息。

    2016-07-07 11:05:55 1400117****4240 [Note] WSREP: Node 128a493c state prim

###获取存活的节点的状态。

    2016-07-07 11:05:55 1400117****4240 [Note] WSREP: view(view_id(PRIM,128a493c,123) memb {
    
            128a493c,0
    
            fb55d9c9,0
    
    } joined {
    
    } left {
    
    } partitioned {
    
            51f4c07a,0
    
    })

###对宕掉的节点进行移除，即partitioned

    2016-07-07 11:05:55 1400117****4240 [Note] WSREP: save pc into disk
    
    2016-07-07 11:05:55 1400117****4240 [Note] WSREP: forgetting 51f4c07a (tcp://197.3.155.152:4567)
    
    2016-07-07 11:05:55 1400117****1536 [Note] WSREP: New COMPONENT: primary = yes, bootstrap = no, my_idx = 1, memb_num = 2
    


###打印新的primary   COMPONENT 信息。



    2016-07-07 11:05:55 1400117****1536 [Note] WSREP: STATE EXCHANGE: Waiting for state UUID.
    
    2016-07-07 11:05:55 1400117****4240 [Note] WSREP: (fb55d9c9, 'tcp://0.0.0.0:4567') turning message relay requesting off
    
    2016-07-07 11:05:55 1400117****1536 [Note] WSREP: STATE EXCHANGE: sent state msg: b8a08882-43ef-11e6-884e-2beaea270cdb
    
    2016-07-07 11:05:55 1400117****1536 [Note] WSREP: STATE EXCHANGE: got state msg: b8a08882-43ef-11e6-884e-2beaea270cdb from 0 (node3)
    
    2016-07-07 11:05:55 1400117****1536 [Note] WSREP: STATE EXCHANGE: got state msg: b8a08882-43ef-11e6-884e-2beaea270cdb from 1 (node2)
    
    2016-07-07 11:05:55 1400117****1536 [Note] WSREP: Quorum results:
    
            version    = 4,
    
            component  = PRIMARY,
    
            conf_id    = 33,
    
            members    = 2/2 (joined/total),
    
            act_id     = 128****12,
    
            last_appl. = 0,
    
            protocols  = 0/7/3 (gcs/repl/appl),
    
            group UUID = afbfeed1-38e8-11e6-84b1-d20f5b484535

###新的集群状态信息在新的primary component 内的节点进行交换与确认。

    2016-07-07 11:05:55 1400117****1536 [Note] WSREP: Flow-control interval: [23, 23]
    
    2016-07-07 11:05:55 1400119****1184 [Note] WSREP: New cluster view: global state: afbfeed1-38e8-11e6-84b1-d20f5b484535:128****12, view# 34: Primary, number of nodes: 2, my index: 1, protocol version 3
    
    2016-07-07 11:05:55 1400119****1184 [Note] WSREP: wsrep_notify_cmd is not defined, skipping notification.
    
    2016-07-07 11:05:55 1400119****1184 [Note] WSREP: REPL Protocols: 7 (3, 2)
    
    2016-07-07 11:05:55 1400118****6944 [Note] WSREP: Service thread queue flushed.
    
    2016-07-07 11:05:55 1400119****1184 [Note] WSREP: Assign initial position for certification: 128****12, protocol version: 3
    
    2016-07-07 11:05:55 1400118****6944 [Note] WSREP: Service thread queue flushed.
    
    2016-07-07 11:05:58 1400117****4240 [Note] WSREP:  cleaning up 51f4c07a (tcp://197.3.155.152:4567)
    
    

###完全剔除197.3.155.152。



###上面的日志中，涉及到进行节点宕机检查的timeout 时间，详细信息请参考官方文档，作者做了截图，请查看！

###几个相关的参数有相对大小的关系，特殊设置时请注意：





#####顺便提一下，在galera 集群中，执行ddl会造成整个集群hang ,如果ddl只要执行的时间较长，在交易频率的系统上，则就造成了悲剧。下面的方式可以避免这种情况。




###To run an ALTER statement in this manner, on each node run the following queries:

###在galera集群的每一个节点上执行下面的步骤：

##1. Change the Schema Upgrade method to Rolling Schema Upgrade.

    SET wsrep_OSU_method='RSU';

###设置为滚动schema变更模式。

##2. Run the ALTER statement.

###执行alter 语句。

###3. Reset the Schema Upgrade method back to Total Order Isolation.

    SET wsrep_OSU_method='TOI';

####将schema的变更模式重新设置为TOI。
