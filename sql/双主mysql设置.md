registry2 52.97.16.12
registry1 52.97.16.10

mysql -uroot -ponceas 

#grant replication slave on *.* to repl@"192.168.80.%" identified by 'repl'

#GRANT REPLICATION SLAVE,RELOAD,SUPER ON *.* TO backup@’52.97.16.12’ IDENTIFIED BY ‘backup’;
create user repl@"db2.paas.sdnxs.com";
grant replication slave on *.* to repl@"db2.paas.sdnxs.com" identified by 'repl';
flush privileges;


create user repl@"db1.paas.sdnxs.com";
grant replication slave on *.* to repl@"db1.paas.sdnxs.com" identified by 'repl';
flush privileges;

 mysqldump -uroot -ponceas --database nacha_application nacha_deployer nacha_monitor nacha_pipeline nacha_runtime nacha_web sdnx_web sdnx_web_test zabbix > all.sql


 CHANGE MASTER TO MASTER_HOST='52.97.16.10',MASTER_USER='repl',MASTER_PORT=6033,MASTER_PASSWORD='repl',MASTER_LOG_FILE='mysql-bin.000006',MASTER_LOG_POS=120;

 CHANGE MASTER TO MASTER_HOST='52.97.16.12',MASTER_USER='repl',MASTER_PORT=6033,MASTER_PASSWORD='repl',MASTER_LOG_FILE='mysql-bin.000004',MASTER_LOG_POS=120;

start savle





