经常要使用到 Linux 的批量查找与替换，这里我们为大家介绍使用 sed 命令来实现查找文件中的内容并替换。

语法格式



    sed -i "s/原字符串/新字符串/g" `grep 原字符串 -rl 所在目录`

实例

以下我们实现在当前目录下查找包含 baidu 的字符串，并将字符串 baidu 替换为 runoob，执行命令：



    sed -i "s/baidu/runoob/g" `grep "runoob" -rl ./`

接下来使用一个更复杂实例，批量替换网址 libs.baidu.com 为 cdn.static.runoob.com：



    sed -i "s/https:\/\/libs.baidu.com/https:\/\/cdn.static.runoob.com\/libs/g" `grep -rl "libs.baidu.com" ./`
