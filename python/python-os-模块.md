python os模块 常用命令

python编程时，经常和文件、目录打交道，这是就离不了os模块。os模块包含普遍的操作系统功能，与具体的平台无关。以下列举常用的命令

1. os.name()——判断现在正在实用的平台，Windows 返回 ‘nt'; Linux 返回’posix'

2. os.getcwd()——得到当前工作的目录。

3. os.listdir()——指定所有目录下所有的文件和目录名。


4. os.remove()——删除指定文件

5. os.rmdir()——删除指定目录

6. os.mkdir()——创建目录

注意：这样只能建立一层，要想递归建立可用：os.makedirs()

7. os.path.isfile()——判断指定对象是否为文件。是返回True,否则False

8. os.path.isdir()——判断指定对象是否为目录。是True,否则False。例：

9. os.path.exists()——检验指定的对象是否存在。是True,否则False.例：

10. os.path.split()——返回路径的目录和文件名。例：

此处只是把前后两部分分开而已。就是找最后一个'/'。看例子：


11. os.getcwd()——获得当前工作的目录（get current work dir)

12. os.system()——执行shell命令。例：

注意：此处运行shell命令时，如果要调用python之前的变量，可以用如下方式：

    var=123
    os.environ['var']=str(var) //注意此处[]内得是 “字符串”
    os.system('echo $var')
13. os.chdir()——改变目录到指定目录

14. os.path.getsize()——获得文件的大小，如果为目录，返回0

15. os.path.abspath()——获得绝对路径。例：

    

16. os.path.join(path, name)——连接目录和文件名。例：

    

17.os.path.basename(path)——返回文件名

    

18. os.path.dirname(path)——返回文件路径

    

19. 获得程序所在的实际目录


    import os
    import sys

    if __name__ == "__main__":
        print os.path.realpath(sys.argv[0])
        print os.path.split(os.path.realpath(sys.argv[0]))
        print os.path.split(os.path.realpath(sys.argv[0]))[0]


    /home/jihite/ftp/del.py
    ('/home/jihite/ftp', 'del.py')
    /home/jihite/ftp　
细节——os.path.spilit()把目录和文件区分开


    >>> import os
    >>> os.path.split("a/b/c/d")
    ('a/b/c', 'd')
    >>> os.path.split("a/b/c/d/")
    ('a/b/c/d', '')
    
    
python中对文件、文件夹的操作需要涉及到os模块和shutil模块。

创建文件：
1) os.mknod("test.txt") 创建空文件
2) open("test.txt",w)           直接打开一个文件，如果文件不存在则创建文件

创建目录：
os.mkdir("file")                   创建目录

创建多层新目录：
### 创建多层目录
def mkdirs(path): 
    # 去除首位空格
    path=path.strip()
    # 去除尾部 \ 符号
    path=path.rstrip("\\")
 
    # 判断路径是否存在
    # 存在     True
    # 不存在   False
    isExists=os.path.exists(path)
 
    # 判断结果
    if not isExists:
        # 创建目录操作函数
        os.makedirs(path)
        # 如果不存在则创建目录
        print path + u' 创建成功'
        return True
    else:
        # 如果目录存在则不创建，并提示目录已存在
        print path + u' 目录已存在'
        return False

复制文件：

    shutil.copyfile("oldfile","newfile")       oldfile和newfile都只能是文件
    shutil.copy("oldfile","newfile")            oldfile只能是文件夹，newfile可以是文件，也可以是目标目录

复制文件夹：

    shutil.copytree("olddir","newdir")        olddir和newdir都只能是目录，且newdir必须不存在

重命名文件（目录）

    os.rename("oldname","newname")       文件或目录都是使用这条命令

移动文件（目录）

    shutil.move("oldpos","newpos")    

删除文件

    os.remove("file")

删除目录

    os.rmdir("dir") 只能删除空目录
    shutil.rmtree("dir")    空目录、有内容的目录都可以删 

转换目录

    os.chdir("path")    换路径

判断目标
    
    os.path.exists("goal")    判断目标是否存在
    os.path.isdir("goal")     判断目标是否目录
    os.path.isfile("goal")    判断目标是否文件  
备注：若路径中含中文，在windows环境（编码为GBK）下，要将目录编码成GBK，如：dir.encode('GBK')
