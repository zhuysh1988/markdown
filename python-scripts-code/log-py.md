# log.py

    #!/usr/bin/env python
    # -*- coding:utf-8 -*-
    # jihongrui@jsqix.com
    
    import os
    import time
    
    
    class log_file:
        """
        效率比较低,适用于脚本输出,但使用方便
        from log import log_file
        log_file(log_message)
        """
    
        def __init__(self, message, dir_name=False, file_name=False):
            ""
            # 取当前时间
            self.nowtime = time.strftime("%Y-%m-%d  %H:%M:%S", time.localtime())
            # 在每条信息前加上 当前时间
            self.message = self.nowtime + '\t' + message + '\n'
            # 定义目录名，为1999-12 年4-月2
            self.LogDirName = time.strftime("%Y_%m", time.localtime()) if dir_name == False else dir_name
    
            # 检测目录，如没有就创建一个
            try:
                if not os.path.exists(self.LogDirName):
                    os.mkdir(self.LogDirName)
            except OSError, e:
                print e
            except:
                print "ERROR from class <log_file> where os.mkdir"
    
            # 定义文件名
            self.LogFileName = time.strftime("%Y-%m-%d", time.localtime()) + '.log' if file_name == False else file_name
    
            # windows系统目录
            self.FileOfNT = self.LogDirName + '\\' + self.LogFileName
            # liunx系统目录
            self.FileOfPosix = self.LogDirName + '/' + self.LogFileName
            # 三元运算判断操作系统
            self.LogFilePath = self.FileOfNT if os.name == 'nt' else self.FileOfPosix
    
            # "写入文件"
            try:
                WriteFile = open(self.LogFilePath, 'a')
                WriteFile.write(self.message)
                WriteFile.close()
            except OSError, e:
                print e
            except IOError, e:
                print e
            except:
                print "ERROR from class <log_file> where WriteFile.write"
    
    
    if __name__ == "__main__":
        ""
        for x in range(1, 10):
            log_file("testtest", 'LOG', 'test.txt')
