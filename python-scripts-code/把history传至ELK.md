#把history传至ELK
    #!/usr/bin/env python
    # -*- coding:utf-8 -*-
    
    __author__ = "jihongrui@jsqix.com"
    
    # import subprocess
    import time
    import socket
    # import shlex
    import os
    import shutil
    
    
    #def bash(cmd):
    #        """
    #            run a bash shell command
    #            执行bash命令
    #        """
    #        return shlex.os.system(cmd)
    #
    #def return_bash(cmd):
    #    """
    #    执行CMD or bash 命令,返回结果
    #    """
    #    return_command = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
    #    return return_command.stdout.read().strip().split()
    
    # def read_file_get_data(history_file):
    #     """
    #       传入history记录文件,转换为列表,可直接批量插入mysql
    #       [(root,192.168.1.2,ls-l),(...)]
    #      """    
    #     f = open(history_file, "r")
    #     lines = f.readlines()  # 读取全部内容
    #     Lists = []
    #     for line in lines:
    #         line = line.replace('#', '')
    #         line = line.replace('\n', '')
    #         Lists.append(line)
    #
    #     data = zip(Lists[::2], Lists[1::2])
    #     return data
    
    
    def get_hist_cmds(user,ip,date,history_file):
        "传入一个history文件,返回命令列表"
        f = open(history_file, "r")
        lines = f.readlines()  # 读取全部内容
        hist_cmds = []
        while len(lines):
            hist_time = time.localtime(int(lines.pop(0).replace('#', '').replace('\n', '')))
            timeStr = time.strftime("%Y%m%d%H%M%S", hist_time)
            hist = timeStr + '    ' + lines.pop(0)
            hist_cmds.append(hist)
        for hist_msg in hist_cmds:
            msg = "user: %s ,user_login_ip: %s ,login_time: %s ,[ %s ]" % (user,ip,date,hist_msg)
            s.sendto(msg, address) # 通过UDP传送至logstash
    
    
    
    
    if __name__ == '__main__':
        ""
        address = ('192.168.80.80', 50514)
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    
        bak_dir = "/var/log/hist_bak/"
        
        dir = "/var/log/.hist/"
        users = os.listdir(dir)
        for user in users:
            user_bak_dir = "%s%s" % (bak_dir,user)
            if not os.path.exists(user_bak_dir):
                os.makedirs(user_bak_dir)
            user_dir = dir + user
            hist_files = os.listdir(user_dir)
            for hist in hist_files:
                List_hist = hist.split('.hist.')
                user_ip = List_hist[0]
                user_date = List_hist[-1][0:8] + List_hist[-1][9:]
                hist_file = "%s%s/%s" % (dir, user, hist)
                bak_hist_file = "%s/%s" % (user_bak_dir,hist)
                get_hist_cmds(user,user_ip,user_date,hist_file)
                shutil.move(hist_file,bak_hist_file)
        s.close()
