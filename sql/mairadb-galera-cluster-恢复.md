#mairadb galera cluster 恢复

######node 加入集群报错:[ERROR] WSREP: gcs/src/gcs_group.cpp:gcs_group_handle_join_msg():736: Will never receive state. Need to abort.
##解决
## vim /etc/szqs/szqs.cnf
    memlock  
    将此项注掉
    #memlock  
## cluster nodes
    node1 172.16.16.8
    node2 172.16.16.88
    node3 172.16.16.188
##查看cluster status
	mysql > show status like 'wsreq%';

##启动node1
	vim /etc/mysql/galera_node.cnf
	##将此项设置成:
	wsrep-cluster-address = gcomm://
	/etc/init.d/mysql start --wsrep-new-cluster
##启动node2
	vim /etc/mysql/galera_node.cnf
	##将此项设置成:
	wsrep-cluster-address = gcomm://172.16.16.8
	/etc/init.d/mysql start
##启动node3
	vim /etc/mysql/galera_node.cnf
	##将此项设置成:
	wsrep-cluster-address = gcomm://172.16.16.8,172.16.16.88
	/etc/init.d/mysql start
##重启node1
	vim /etc/mysql/galera_node.cnf
	##将此项设置成:
	wsrep-cluster-address = gcomm://172.16.16.88,172.16.16.188
	/etc/init.d/mysql start
