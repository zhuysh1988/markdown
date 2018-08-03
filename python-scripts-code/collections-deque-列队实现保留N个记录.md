#collections.deque 列队实现保留N个记录
    file:
        1  sh startup.sh
        2  exit
        3  cd /data/tomcat6/bin/
        4  ps -ef |grep tomcat
        5  top
        6  ps -ef |grep tomcat
        7  kill -9 12621
        8  ps -ef |grep tomcat
        9  sh startup.sh
       10  exit
       11  cd /data/tomcat6/bin/
       12  ps -ef |grep tomcat
       13  kill -9 24844
       14  ps -ef |grep tomcat
       15  sh startup.sh
       16  exit
       17  ps -ef |grep tomcat
       18  cd /data/tomcat6/bin/
       19  kill -9 23973
       20  ps -ef |grep tomcat

#例:
    from collections import deque
    def search(line,pattern,history=5):
        previous_lines = deque(maxlen=history)
        for li in line:
            if pattern in li:
                yield li,previous_lines
            previous_lines.append(li)
    
    if __name__ == '__main__':
        "在 file 文件中,查找 'sh startup.sh' 字符串, 并且显示查找到'sh startup.sh' 字符串之前的5个记录"
        with open('file') as f:
            for line,previlnes in search(f,'sh startup.sh',5):
                for piline in previlnes:
                    print(piline)
                print(line)
                print('_' * 20)
