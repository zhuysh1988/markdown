#文件版
    #!/usr/bin/env python
    # -*- coding:utf-8 -*-
    
    __author__ = "jihongrui@jsqix.com"
    
    import urllib2
    import json
    
    Appid_Group = {
        '1': '2',  # zabbix 专用
        '6': '4',  # 服务器专用
        '7': '5',  # DBA 专用
        '8': '6',  # 技术部专用
        '9': '7',  # 客服部专用
        '10': '8',  # 杭州组专用
        '11': '9'  # 测试专用
    }
    
    class weixin(object):
        ""
        def __init__(self,appid,msg):
            ""
            self.appid = str(appid)
            self.msg = str(msg)
            self.tokenfile = 'token.log'
    
        def get_token(self,mode=False):
            ""
            if mode:
                file = open(self.tokenfile,'r')
                # try:
                #     self.token  = file.read()
                # finally:
                #     file.close()
                with open(self.tokenfile, 'r') as f:
    
                    self.token = f.read()
            else:
    
                appid = "wxddaasdasdcb42d5"
                secrect = "N26FX62Ej5isadasdasdasdttQX62vw5gKmpbUkap4_6CczzI2d7o"
                GURL = "https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=%s&corpsecret=%s" % (appid, secrect)
                try:
                    f = urllib2.urlopen(GURL).read()
                    j = json.loads(f)
                    self.token = j['access_token']  # .encode('utf8')
    
                    file = open(self.tokenfile,'w')
                    # try:
                    #     file.write(self.token)
                    # finally:
                    #     file.close()
                    with open(self.tokenfile,'w') as f:
                        f.write(self.token)
                except:
                    print "ERROR from class get token"
                    exit("error token")
    
        def send_msg(self):
            ""
            # App_ID = str(AppID)
            Group_ID = Appid_Group[self.appid]
            User_ID = '@all'
            # Message = str(message)
            dict_arr = {
                "touser": User_ID,  # 企业号中的用户帐号，在zabbix用户Media中配置，如果配置不正常，将按部门发送。
                "toparty": Group_ID,  # 企业号中的部门id
                "msgtype": "text",
                "agentid": self.appid,  # 企业号中的应用id，消息类型。
                "text": {
                    "content": self.msg
                },
                "safe": "0"
            }
    
            try:
                json_template = json.dumps(dict_arr, ensure_ascii=False)
                requst_url = "https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=" + self.token
                Format_MSG = urllib2.urlopen(requst_url, json_template)
                return_MSG = Format_MSG.read()
                # 读取json数据
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
    
    def DO_PUSH(appid,msg):
        ""
        xp = weixin(appid,msg)
        xp.get_token(True)
        if xp.send_msg():
            return True
        else:
            xp.get_token(False)
            if xp.send_msg():
                return True
            else:
                return False
    
    
    if __name__ == '__main__':
        ""
        DO_PUSH(6,'test')
