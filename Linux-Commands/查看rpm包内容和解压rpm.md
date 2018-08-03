列出rpm包的内容：
rpm -qpl *.rpm

解压rpm包的内容：（没有安装，就像解压tgz包一样rpm包）
rpm2cpio *.rpm | cpio -div

你的linux下可能没有rpm2cpio这个命令，用过简单指令安装即可。

sudo apt-get install  rpm2cpio/su yum install rpm2cpio;

改天有时间研究一下rpm包压缩格式和cpio等命令，知其然知其所以然。