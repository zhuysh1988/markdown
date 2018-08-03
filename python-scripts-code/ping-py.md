# ping.py 
快速获取ip在不在线

    #!/usr/bin/env python
    # -*- coding:utf-8 -*-
    
    __author__ = "jihongrui@jsqix.com"
    
    import os
    import subprocess
    import threading
    
    from log import log_file
    
    
    class myThread (threading.Thread):
        def __init__(self, threadID, name,ip):
            threading.Thread.__init__(self)
            self.threadID = threadID
            self.name = name
            # self.counter = counter
            self.ip = ip
        def run(self):
            print "Starting " + self.name
           # 获得锁，成功获得锁定后返回True
           # 可选的timeout参数不填时将一直阻塞直到获得锁定
           # 否则超时后将返回False
            threadLock.acquire()
            # print_time(self.name, self.counter, 3)
    
            check_ip(self.ip)
            # 释放锁
            threadLock.release()
    
    
    def ping(ip='127.0.0.1'):
        ''''''
        try:
            if os.name == 'nt':
                result = subprocess.call(['ping', '-n', '2', '-w', '1', ip], stdout=subprocess.PIPE)
                # print result,1
            else:
                result = subprocess.call(['ping', '-c', '3', ip], stdout=subprocess.PIPE)
                # print result,2
        except:
            result = 1
            # print result,3
        finally:
            # print result,4
            if result == 0:
                return True
            else:
                return False
    
    
    def range_ip(ips='192.168.1.', nus=1, nue=255):
        ""
        IP_list = []
        for nu in range(nus, nue):
            ip = "%s%d" % (ips, nu)
            IP_list.append(ip)
        return IP_list
    
    
    def check_ip(ip):
        ""
        if ping(ip):
            log_file("%s \t PASS" % ip)
        else:
            log_file("%s \t NOT PASS" % ip)
    
    
    
    
    if __name__ == "__main__":
        ''
    
        IP_list = range_ip()
        threNU = len(IP_list)
    
        threadLock = threading.Lock()
        threads = []
        thread = 0
    
        for ip in IP_list:
            thread += 1
            TH = "TH%d" % thread
            TH = myThread(thread,"ipcheck%s"%ip,ip)
            TH.start()
            threads.append(TH)
    
    
        # 等待所有线程完成
        for t in threads:
            t.join()
        print "Exiting Main Thread"
        
        
# 另一个脚本 

    #!/usr/bin/env python
    # -*- coding:utf-8 -*-
    
    __author__ = "jihongrui@hotmail.com"
    
    import os
    import subprocess
    import threading
    
    from Queue_test.log import log_file
    
    
    class Ping():
        ''
        def __init__(self,ips='192.168.1.', nus=1, nue=255):
            ''
            self.ips = ips
            self.nus = nus
            self.nue = nue
            self.IP_list = []
            self.IP_PASS = []
            self.IP_FAIL = []
    
        def range_ip(self,):
            ""
            for nu in range(self.nus, self.nue):
                ip = "%s%d" % (self.ips, nu)
                self.IP_list.append(ip)
    
        def ping(self,ip='127.0.0.1'):
            ''''''
            try:
                if os.name == 'nt':
                    result = subprocess.call(['ping', '-n', '2', '-w', '1', ip], stdout=subprocess.PIPE)
                else:
                    result = subprocess.call(['ping', '-c', '3', ip], stdout=subprocess.PIPE)
            except:
                result = 1
            finally:
                if result == 0:
                    self.IP_PASS.append(ip)
                else:
                    self.IP_FAIL.append(ip)
    
    
    if __name__ == "__main__":
        ''
    
        threads = []
        nal1 = Ping()
        nal1.range_ip()
        for ip in nal1.IP_list:
            th = threading.Thread(target=nal1.ping, args=(ip,))
            th.start()
            threads.append(th)
    
        # 等待线程运行完毕
        for th in threads:
            th.join()
    
        IP_PASS = sorted(nal1.IP_PASS,key=lambda i : int(i.split('.')[-1]))
        IP_FAIL = sorted(nal1.IP_FAIL,key=lambda i : int(i.split('.')[-1]))
    
        while IP_PASS:
            ip = IP_PASS.pop(0)
            log_file("%s \t PASS"%ip)
    
        while IP_FAIL:
            ip = IP_FAIL.pop(0)
            log_file("%s \t FAIL"%ip)
