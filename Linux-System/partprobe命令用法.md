## partprobe命令用法
    partprobe：
>将磁盘分区表变化信息通知内核，请求操作系统重新加载分区表。

    -d 不更新内核
    -s 显示磁盘分区汇总信息
    -h 显示帮助信息
    -v 显示版本信息
### eg：
    partprobe /dev/sdb


>当磁盘分区信息完整时，手动删除/dev/disk/by-id目录下对应的wwn链接文件，执行partprobe操作，系统会自己创建删除的链接文件。
>通过udevadmin monitor命令可以监控到相关信息。
