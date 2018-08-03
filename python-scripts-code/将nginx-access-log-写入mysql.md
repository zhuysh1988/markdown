#将nginx access log 写入mysql    
    #!/usr/bin/env python
    # -*- coding:utf-8 -*-
    
    __author__ = "jihongrui@hotmail.com"
    '''
    {u'status': u'200', " \
    "u'domain': u'nginx.org', " \
    "u'url': u'/index.html', " \
    "u'agent': u'ApacheBench/2.3'," \
    " u'host': u'127.0.0.1', " \
    "u'http_host': u'localhost'," \
    " u'clientip': u'127.0.0.1'}
    
    
    nginx config
    
    log_format json
                     '"host":"$server_addr",'
                     '"clientip":"$remote_addr",'
                     '"http_host":"$host",'
                     '"url":"$uri",'
                     '"agent":"$http_user_agent",'
                     '"xff":"$http_x_forwarded_for",'
                     '"status":"$status",';
    
    access_log syslog:server=localhost:20514,facility=local7,tag=nginx,severity=info json;
    '''
    
    
    import socket, traceback
    import MySQLdb
    
    
    def sql_conn(SQL,data):
        ""
        try:
            conn = MySQLdb.connect(host='localhost', user='root', passwd='root', port=3306)
            cur = conn.cursor()
            conn.select_db('nginxlog')
    
    
            cur.executemany(SQL, data)
            # cur.execute(sql)
    
            conn.commit()
            cur.close()
            conn.close()
        except MySQLdb.Error, e:
            print "Mysql Error %d: %s" % (e.args[0], e.args[1])
    
    
    
    host = ''
    port = 20514
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind((host, port))
    Lists = list()
    while True:
        try:
            message, address = s.recvfrom(8192)
            strs = '{' + message.split('nginx:')[-1] + '}'
            strs = eval(strs)
            List = (strs['url'], strs['agent'], strs['status'], strs['host'], strs['http_host'], strs['clientip'])
            Lists.append(List)
            sql = 'insert into log (url,agent,status,host,http_host,clientip,time) values("%s","%s","%s","%s","%s","%s",NOW())'
            if len(Inst_list) > 1000:
                sql_conn(sql)
                Inst_list = []
                
            s.sendto(message, address)
        except (KeyboardInterrupt, SystemExit):
            raise
        except:
            traceback.print_exc()
