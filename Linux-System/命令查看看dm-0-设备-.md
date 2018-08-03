##命令查看看dm-0 设备 


    root@ubuntu108:~# lvdisplay|awk '/LV Name/{n=$3} /Block device/{d=$3; sub(".*:","dm-",d); print d,n;}'
    dm-0 /dev/datavg/datalv
    dm-1 /dev/ubuntu108-vg/root
    dm-2 /dev/ubuntu108-vg/swap_1
