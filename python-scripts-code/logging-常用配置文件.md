#logging 常用配置文件

    #!/usr/bin/env python
    # coding:utf-8
    
    
    __author__ = "jihongrui@jsqix.com"
    
    import os
    import time
    import logging
    import json
    
    
    #################################################################################
    def logfile_list(file):
        "返回本配置文件生成的日志转换的list.  [{line},{line}]"
        try:
            if os.path.isfile(file):
                log_list = []
                with open(file) as f:
                    for line in f.readlines():
                        line = json.loads(line.strip())
                        line = eval(line)
                        log_list.append(line)
                return log_list
            else:
                print("ERROR,%s is not exists" % file)
                return False
        except:
            print("%s format is ERROR" % file)
            return False
    
    
    #########################################################################
    # logging 日志级别重新定义
    # 10
    debug = logging.debug
    # 20
    info = logging.info
    # 30
    warning = logging.warning
    # 40
    error = logging.error
    # 50
    critical = logging.critical
    ########################################################################
    # 目录名为: 年_月
    LogDirName = time.strftime("%Y_%m", time.localtime())
    # 日志文件名为: whios_年-月-日.log
    LogFileName = "%s_%s.%s" % ('whios', time.strftime("%Y-%m-%d", time.localtime()), 'log')
    # 定义 Windows 和 Linux 文件系统下的文件分隔符
    FileOfNT = 'log' + '\\' + LogDirName + '\\' + LogFileName
    FileOfPosix = "%s/%s/%s" % ('log', LogDirName, LogFileName)
    # 三元运算定义相对路径
    LogFilePath = FileOfNT if os.name == 'nt' else FileOfPosix
    # 取得相对路径目录
    LOGDIR = os.path.dirname(LogFilePath)
    
    ###########################################################################
    # 检测目录是否存在,否则新建目录
    try:
        if not os.path.exists(LOGDIR):
            os.makedirs(LOGDIR, mode=0o750)
    
    except:
        print(OSError)
        print("ERROR from class <log_file> where os.mkdir")
    
    logging.basicConfig(
        datefmt='%Y-%m-%d %H:%M:%S',
        filename=LogFilePath,
        level=logging.DEBUG,
        format='''"{'time':'%(asctime)s','level':'%(levelname)s','line':'%(lineno)s','path':'%(pathname)s','message':'%(message)s'}"'''
    )
    
    if __name__ == '__main__':
        "测试通过"
    #######################################################################################
        # 测试生成日志
        # log_mess = 'ps -ef |grep hello |cat /etc/passwd'
        # for i in range(10):
        #     debug(log_mess)
        #     info(log_mess)
        #     warning(log_mess)
        #     error(log_mess)
        #     critical(log_mess)
    
    
    ########################################################################################
        # 测试读取日志,转成dict
    
        # for dic in logfile_list(LogFilePath):
        #     print('='*100)
        #     for k,v in dic.items():
        #         print('-'*50)
        #         print(k,v)
