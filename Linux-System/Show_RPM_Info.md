        有时候，拿到一个RPM，并不想安装它，而想了解包里的内容，怎么办呢？

          如果只相知道包里的文件列表执行：

       #rpm -qpl packetname

          如果想要导出包里的内容，而不是安装，那么执行：

       # rpm2cpio pkgname | cpio -ivd　