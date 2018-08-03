#数据库版
    #!/usr/bin/env python
    # -*- coding:utf-8 -*-
    # jihongrui@jsqix.com
    
    import json
    import urllib2
    import MySQLdb
    import sys
    reload(sys)
    sys.setdefaultencoding('utf8')
    
    MYSQL_HOST = 'localhost'
    MYSQL_PORT = 3306
    MYSQL_USER = 'root'
    MYSQL_PASSWD = 'root'
    MYSQL_DB = 'weixin'
    
    
    def mysqldbupdate(token):
    
        try:
            conn=MySQLdb.connect(host=MYSQL_HOST,user=MYSQL_USER,passwd=MYSQL_PASSWD,port=MYSQL_PORT,charset="utf8")
            cur=conn.cursor()
            conn.select_db(MYSQL_DB)
            SQL = "UPDATE gettoken SET token='%s' WHERE id=1" % token
            cur.execute(SQL )
            conn.commit()
            cur.close()
            conn.close()
            return True
    
        except MySQLdb.Error,e:
            return False
            print "Mysql Error %d: %s" % (e.args[0], e.args[1])
    
    
    def get_token():
        ''''''
        appid = "wxdda3fsdfsdfb42d5"
        secrect = "N26FX62Ej5iFIPHXsdfsdfsdfvNttQX62vw5gKmpbUkadsfsdfczzI2d7o"
        GURL="https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=%s&corpsecret=%s" % (appid,secrect)
        try:
            f = urllib2.urlopen(GURL).read()
            j = json.loads(f)
            token = j['access_token']#.encode('utf8')
    
            if mysqldbupdate(token):
                return token
            else:
                return False
        except:
            print "ERROR from class get token"
            exit("error token")
    
    
    
    
    def mysqldbget():
    
        try:
            conn=MySQLdb.connect(host=MYSQL_HOST,user=MYSQL_USER,passwd=MYSQL_PASSWD,port=MYSQL_PORT,charset="utf8")
            cur=conn.cursor()
            conn.select_db(MYSQL_DB)
            SQL = "SELECT token FROM gettoken WHERE id=1"
            cur.execute(SQL)
            results = cur.fetchall()
            for x in results:
                return x[-1]
            conn.commit()
            cur.close()
            conn.close()
        except MySQLdb.Error,e:
            return False

    
    
    Appid_Group = {
        '1':'2',#zabbix 专用
        '6':'4',#服务器专用
        '7':'5',#DBA 专用
        '8':'6',#技术部专用
        '9':'7',#客服部专用
        '10':'8',#杭州组专用
        '11':'9' #测试专用
    }
    
    
    
    
    def do_push(message,token,AppID=6):
            """"""
            App_ID = str(AppID)
            Group_ID = Appid_Group[App_ID]
            User_ID = '@all'
            Message = str(message)
            dict_arr = {
                        "touser":User_ID,  #企业号中的用户帐号，在zabbix用户Media中配置，如果配置不正常，将按部门发送。
                        "toparty":Group_ID,  #企业号中的部门id
                        "msgtype":"text",
                        "agentid":App_ID,   #企业号中的应用id，消息类型。
                        "text":{
                            "content":Message
                            },
                        "safe":"0"
                        }
    
            try:
                json_template = json.dumps(dict_arr, ensure_ascii=False)
                requst_url = "https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=" + token
                Format_MSG = urllib2.urlopen(requst_url,json_template)
                return_MSG = Format_MSG.read()
                #读取json数据
                j = json.loads(return_MSG)
                j.keys()
                # return self.j.keys
                errcode = j['errcode']
                # print errcode,type(errcode)
                errmsg = j['errmsg']
                # print errmsg,type(errmsg)
                if errcode == 0 and errmsg == u'ok':
                    return True
                else:
                    return False
    
            except urllib2.HTTPError, e:
                print e
            except urllib2.URLError, e:
                print e
            except:
                print "ERROR from send message"
                #log_file("ERROR from send message")
    
    def DO_PUSH(message,appid=6):
        ''''''
        MEG = message
        APD = appid
        TOK = mysqldbget()
        if do_push(MEG, TOK, APD):
            return True
        else:
            TOK = get_token()
            if do_push(MEG, TOK, APD):
                return True
            else:
                return False
    
    
    
    
    
    if __name__=="__main__":
        """"""
        MSG = "test"
        if  DO_PUSH(MSG):
            print 0
        else:
            print 1
