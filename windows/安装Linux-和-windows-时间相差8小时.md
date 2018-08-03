##安装Linux 和 windows 时间相差8小时



这个问题是因为Windows和linux对硬件标准时间的设置不同

Windows默认为当地时间，而linux默认为UTC时间，所以会差8小时。

将Windows改成utc时间即可。



保存为.cmd OR .bat ,然后运行，重启



    @echo .添加注册表...

    @echo off

    Reg add HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation /v RealTimeIsUniversal /t REG_DWORD /d 1

    @echo .添加注册表成功，关机重启windows即可

    pause
