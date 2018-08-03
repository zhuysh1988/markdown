强大的 Xargs 命令

xargs 命令是最重要的 Linux 命令行技巧之一。你可以使用这个命令将命令的输出作为参数传递给另一个命令。例如，搜索 png 文件然后对其进行压缩或者其它操作：

find. -name *.png -type f -print | xargs tar -cvzf images.tar.gz

又或者你的文件中有一个 URL 的列表，而你想要做的是以不同的方式下载或者处理这些 URL，可以这样做：

cat urls.txt | xargs wget

请你要记得，第一个命令的输出会在 xargs 命令结尾处传递。

那如果命令需要中间过程的输出，该怎么办呢？这个简单！

只需要使用 {} 并结合 -i 参数就行了。如下所示，替换在第一个命令的输出应该去的地方的参数：

ls /etc/*.conf | xargs -i cp {} /home/likegeeks/Desktop/out
