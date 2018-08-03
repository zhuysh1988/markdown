iozone的使用与介绍


#iozone介绍： 
iozone（www.iozone.org)是一个文件系统的benchmark工具，可以测试不同的操作系统中文件系统的读写性能。
可以测试
    
    Read, write, re-read,re-write, read backwards, read strided, fread, fwrite, random read, pread,mmap, aio_read, aio_write 
等等不同的模式下的硬盘的性能。

测试的时候请注意，设置的测试文件的大小一定要大过你的内存(最佳为内存的两倍大小)，不然linux会给你的读写的内容进行缓存。会使数值非常不真实.

#iozone常用的几个参数.
    -a 全面测试，比如块大小它会自动加
    -i N 用来选择测试项, 比如Read/Write/Random 比较常用的是0 1 2,可以指定成-i 0 -i 1 -i2.这些别的详细内容请查man
      0=write/rewrite
      1=read/re-read
      2=random-read/write
      3=Read-backwards
      4=Re-write-record
      5=stride-read
      6=fwrite/re-fwrite
      7=fread/Re-fread
      8=random mix
      9=pwrite/Re-pwrite
      10=pread/Re-pread
      11=pwritev/Re-pwritev
      12=preadv/Re-preadv
    
    -r block size 指定一次写入/读出的块大小
    -s file size 指定测试文件的大小
    -f filename 指定测试文件的名字,完成后会自动删除(这个文件必须指定你要测试的那个硬盘中)
    -F file1 file2... 指定多线程下测试的文件名
    
    批量测试项:
    -g -n 指定测试文件大小范围,最大测试文件为4G,可以这样写 -g 4G
    -y -q 指定测试块的大小范围
    
    输出:
    下面是几个日志记录的参数.好象要输出成图象进行分析，需要指定-a的测试才能输出
    -R 产生Excel到标准输出
    -b 指定输出到指定文件上. 比如 -Rb ttt.xls

我的测试实例:

    ./iozone -a -n 512m -g 4g -i 0 -i 1 -i 5 -f /mnt/iozone -Rb ./iozone.xls

注:进行全面测试.最小测试文件为512M直到测试到4G.测试read,write,和Strided Read.测试的地方在mnt下。生成Excel的文件.
 
    ./iozone -i 0 -i 1 -f /iozone.tmpfile -Rab /test-iozone.xls -g 8G -n 4G -C
 
 
结果分析：
使用这条测试命令测试NAS后，我对下边产生的Execl文件中的一段表进行下解释，很简单的：
    
    Writer Report 		4 	8 	16 	32 	64
    32768 	5300 	8166 	12726 	16702 	24441
    65536 	5456 	8285 	9630 	16101 	18679
    131072 	5539 	6968 	9453 	13086 	14136
    262144 	5088 	7092 	9634 	11602 	14776
    524288 	5427 	9356 	10502 	13056 	13865
    1048576 	6061 	9625 	11528 	12632 	13466

在Execl文件中的这段表，它说明了这个表单是关于write的测试结果，左侧一列是测试文件大小（Kbytes),
最上边一行是记录大小，中间数据是测试的传输速度。举例说明，比如表中的“5300”，意思是测试文件大小为
32M，以记录大小为4K来进行传输，它的传输速度为5300 Kbytes/s
 
 
 
 
关于各种测试的定义
 
    Write: 测试向一个新文件写入的性能。当一个新文件被写入时，不仅仅是那些文件中的数据需要被存储，还包括那些用于定位数据存储在存储介质的具体位置的额外信息。这些额外信息被称作“元数据”。它包括目录信息，所分配的空间和一些与该文件有关但又并非该文件所含数据的其他数据。拜这些额外信息所赐，Write的性能通常会比Re-write的性能低。
 
    Re-write: 测试向一个已存在的文件写入的性能。当一个已存在的文件被写入时，所需工作量较少，因为此时元数据已经存在。Re-write的性能通常比Write的性能高。
 
    Read: 测试读一个已存在的文件的性能。
 
    Re-Read: 测试读一个最近读过的文件的性能。Re-Read性能会高些，因为操作系统通常会缓存最近读过的文件数据。这个缓存可以被用于读以提高性能。
 
    Random Read: 测试读一个文件中的随机偏移量的性能。许多因素可能影响这种情况下的系统性能，例如：操作系统缓存的大小，磁盘数量，寻道延迟和其他。
 
    Random Write: 测试写一个文件中的随机偏移量的性能。同样，许多因素可能影响这种情况下的系统性能，例如：操作系统缓存的大小，磁盘数量，寻道延迟和其他。
 
    Random Mix: 测试读写一个文件中的随机偏移量的性能。同样，许多因素可能影响这种情况下的系统性能，例如：操作系统缓存的大小，磁盘数量，寻道延迟和其他。这个测试只有在吞吐量测试模式下才能进行。每个线程/进程运行读或写测试。这种分布式读/写测试是基于round robin 模式的。最好使用多于一个线程/进程执行此测试。
 
    Backwards Read: 测试使用倒序读一个文件的性能。这种读文件方法可能看起来很可笑，事实上，有些应用确实这么干。MSC Nastran是一个使用倒序读文件的应用程序的一个例子。它所读的文件都十分大（大小从G级别到T级别）。尽管许多操作系统使用一些特殊实现来优化顺序读文件的速度，很少有操作系统注意到并增强倒序读文件的性能。
 
    Record Rewrite: 测试写与覆盖写一个文件中的特定块的性能。这个块可能会发生一些很有趣的事。如果这个块足够小（比CPU数据缓存小），测出来的性能将会非常高。如果比CPU数据缓存大而比TLB小，测出来的是另一个阶段的性能。如果比此二者都大，但比操作系统缓存小，得到的性能又是一个阶段。若大到超过操作系统缓存，又是另一番结果。
 
    Strided Read: 测试跳跃读一个文件的性能。举例如下：在0偏移量处读4Kbytes，然后间隔200Kbytes,读4Kbytes，再间隔200Kbytes，如此反复。此时的模式是读4Kbytes，间隔200Kbytes并重复这个模式。这又是一个典型的应用行为，文件中使用了数据结构并且访问这个数据结构的特定区域的应用程序常常这样做。
许多操作系统并没注意到这种行为或者针对这种类型的访问做一些优化。同样，这种访问行为也可能导致一些有趣的性能异常。一个例子是在一个数据片化的文件系统里，应用程序的跳跃导致某一个特定的磁盘成为性能瓶颈。
 
    Fwrite: 测试调用库函数fwrite()来写文件的性能。这是一个执行缓存与阻塞写操作的库例程。缓存在用户空间之内。如果一个应用程序想要写很小的传输块，fwrite()函数中的缓存与阻塞I/O功能能通过减少实际操作系统调用并在操作系统调用时增加传输块的大小来增强应用程序的性能。
这个测试是写一个新文件，所以元数据的写入也是要的。
 
    Frewrite:测试调用库函数fwrite()来写文件的性能。这是一个执行缓存与阻塞写操作的库例程。缓存在用户空间之内。如果一个应用程序想要写很小的传输块，fwrite()函数中的缓存与阻塞I/O功能能通过减少实际操作系统调用并在操作系统调用时增加传输块的大小来增强应用程序的性能。
这个测试是写入一个已存在的文件，由于无元数据操作，测试的性能会高些。
 
    Fread:测试调用库函数fread()来读文件的性能。这是一个执行缓存与阻塞读操作的库例程。缓存在用户空间之内。如果一个应用程序想要读很小的传输块，fwrite()函数中的缓存与阻塞I/O功能能通过减少实际操作系统调用并在操作系统调用时增加传输块的大小来增强应用程序的性能。
 
    Freread: 这个测试与上面的fread 类似，除了在这个测试中被读文件是最近才刚被读过。这将导致更高的性能，因为操作系统缓存了文件数据。
 
几个特殊测试:
 
    Mmap:许多操作系统支持mmap()的使用来映射一个文件到用户地址空间。映射之后,对内存的读写将同步到文件中去。这对一些希望将文件当作内存块来使用的应用程序来说很方便。一个例子是内存中的一块将同时作为一个文件保存在于文件系统中。
    mmap 文件的语义和普通文件略有不同。如果发生了对内存的存储，并不是立即发生相应的文件I/O操作。使用MS_SYNC 和MS_ASYNC标志位的 msyc()函数调用将控制内存和文件的一致性。调用msync() 时将MS_SYNC置位将强制把内存里的内容写到文件中去并等待直到此操作完成才返回。而MS_ASYNC 置位则告诉操作系统使用异步机制将内存刷新到磁盘，这样应用程序可以直接返回而不用等待此操作的完成。
    这个测试就是测量使用mmap()机制完成I/O的性能。
 
    Async I/O: 许多操作系统支持的另外一种I/O机制是POSIX 标准的异步I/O。本程序使用POSIX标准异步I/O接口来完成此测试功能。
    例如： aio_write(), aio_read(), aio_error()。这个测试测量POSIX异步I/O机制的性能。
 
 
 
 
命令行参数：
 
接下来解释每个参数的用法。
 
    Usage: iozone [-s filesize_Kb] [-r record_size_Kb ] [-f [path]filename]
    [-i test] [-E] [-p] [-a] [-A] [-z] [-Z] [-m] [-M] [-t children] [-h] [-o]
    [-l min_number_procs] [-u max_number_procs] [-v] [-R] [-x]
    [-d microseconds] [-F path1 path2...] [-V pattern] [-j stride]
    [-T] [-C] [-B] [-D] [-G] [-I] [-H depth] [-k depth] [-U mount_point]
    [-S cache_size] [-O] [-K] [-L line_size] [-g max_filesize_Kb]
    [-n min_filesize_Kb] [-N] [-Q] [-P start_cpu] [-c] [-e] [-b filename]
    [-J milliseconds] [-X filename] [-Y filename] [-w] [-W]
    [-y min_recordsize_Kb] [-q max_recordsize_Kb] [-+m filename]
    [-+u ] [ -+d ] [-+p percent_read] [-+r] [-+t ] [-+A #]
 
它们都是什么意思 ?
 
    -a
           用来使用全自动模式。生成包括所有测试操作的报告，使用的块 大小从4k到16M，文件大小从64k到512M。
     
    -A
    这种版本的自动模式提供更加全面的测试但是消耗更多时间。参数–a在文件不小于
     32MB时将自动停止使用低于64K的块 大小测试。这节省了许多时间。而参数–A
    则告诉Iozone你不介意等待，即使在文件非常大时也希望进行小块 的测试。
    注意： 不推荐在Iozone3.61版中使用这个参数。使用–az –i 0 –i 1替代。
     
    -b filename
    Iozone输出结果时将创建一个兼容Excel的二进制格式的文件。
     
    -B
    使用mmap()文件。这将使用mmap()接口来创建并访问所有测试用的临时文件。一
    些应用程序倾向于将文件当作内存的一块来看待。这些应用程序对文件执行mmap()
    调用，然后就可以以读写内存的方式访问那个块来完成文件I/O。
     
    -c
    计算时间时将close()包括进来。This is useful only if you suspect that close() is
    broken in the operating system currently under test. 对于NFS版本3测试而言这将会
    很有用，同时它也能帮助我们识别nfs3_commit 是否正常工作。
     
    -C
    显示吞吐量测试中每个客户传输的字节数。如果你的操作系统在文件I/O或进程管
    理方面存在饥饿问题时这将派上用场。
     
     
    -d #
    穿过“壁垒”时微秒级的延迟。在吞吐量测试中所有线程或进程在执行测试前都必
    须挂起在一道“壁垒”之前。通常来说，所有线程或进程在同一时间被释放。这个
    参数允许在释放每个进程或线程之间有一定的延迟（微秒级）。Microsecond delay out of barrier.  During the throughput tests all threads or processes are
    forced to a barrier before beginning the test.
     
    -D
    对mmap文件使用msync(MS_ASYNC) 。这告诉操作系统在mmap空间的所有数据
    需要被异步地写到磁盘上。
     
    -e
    计算时间时将flush (fsync,fflush) 包括进来。
     
    -E
    用来进行一些扩展的测试。只在一些平台上可用。使用pread 接口。
     
    -f filename
    用来指定测试时使用的临时文件的文件名。当使用unmount参数时这将很有用。测试时在每个测试之间进行unmount的话，测试使用的临时文件在一个可以被卸载的文件夹中是很有必要的。卸载当前工作目录是不可能的，因为Iozone进程运行于此。
     
    -F filename filename filename …
    指定吞吐量测试中每个临时文件的文件名。文件名的数量应该和指定的进程或线程
    数相同。
     
    -g #
    设置自动模式可使用的最大文件大小（Kbytes）。
     
    -G
    对mmap文件使用msync(MS_SYNC)。这告诉操作系统在mmap空间的所有数据
    需要被同步地写到磁盘上。
     
    -h
    显示帮助。
     
    -H #
    使用POSIX异步I/O接口中的#号异步操作。Iozone使用POSIX 异步I/O接口，并使
    用bcopy 从异步缓存拷贝回应用程序缓存。一些版本的MSC NASTRAN就是这么进
    行I/O操作的。应用程序使用这一技术以便异步I/O可以在一个库中实现，而不需要
    更改程序内模。
    This technique is used by applications so that the async
    I/O may be performed in a library and requires no changes to the applications internal model.
     
    -i #
    用来指定运行哪个测试。 (0=write/rewrite, 1=read/re-read, 2=random-read/write
    3=Read-backwards, 4=Re-write-record, 5=stride-read, 6=fwrite/re-fwrite, 7=fread/Re-fread,
    8=random mix, 9=pwrite/Re-pwrite, 10=pread/Re-pread, 11=pwritev/Re-pwritev, 12=preadv/Re-preadv). 
    总是需要先进行0号测试以便后面的测试有文件可以测试。
    也支持使用-i # -i # -i # 以便可以进行多个测试。
     
    -I
    对所有文件操作使用VxFS VX_DIRECT 。告诉VXFS 文件系统所有对文件的操作将跨
    过缓存直接在磁盘上进行。
     
    -j #
    设置访问文件的跨度为 (# * 块 大小). Stride read测试将使用这个跨度来读块 。
     
    -J # (毫秒级)
    在每个I/O操作之前产生指定毫秒的计算延迟。看 -X 和-Y来获取控制计算延
    迟的其他参数。
        -k #
    Use POSIX async I/O (no bcopy) with # async operations. Iozone will use POSIX async
    I/O and will not perform any extra bcopys. The buffers used by Iozone will be handed to
    the async I/O system call directly.
     
    -K
    在普通测试时生成一些随机访问。
     
    -l #
    Set the lower limit on number of processes to run. When running throughput tests this
    option allows the user to specify the least number of processes or threads to start. This
    option should be used in conjunction with the -u option.
     
    -L #
    Set processor cache line size to value (in bytes). Tells Iozone the processor cache line size.
    This is used internally to help speed up the test.
     
    -m
    Tells Iozone to use multiple buffers internally. Some applications read into a single
    buffer over and over. Others have an array of buffers. This option allows both types of
    applications to be simulated.  Iozone’s default behavior is to re-use internal buffers.
    This option allows one to override the default and to use multiple internal buffers.
     
    -M
    Iozone will call uname() and will put the string in the output file.
     
    -n #
    为自动模式设置最小文件大小(Kbytes)。
     
    -N
    报告结果以毫秒每操作的方式显示。
     
    -o
    写操作是同步写到磁盘的。 (O_SYNC). Iozone 会以O_SYNC 标志打开文件。这强制所有写操作完全写入磁盘后才返回测试。
     
    -O
    报告结果以操作每秒的方式显示。
     
    -p
    This purges the processor cache before each file operation. Iozone will allocate another
    internal buffer that is aligned to the same processor cache boundary and is of a size that
    matches the processor cache. It will zero fill this alternate buffer before beginning each test.
    This will purge the processor cache and allow one to see the memory subsystem without
    the acceleration due to the processor cache.
     
    -P #
    Bind processes/threads to processors, starting with this cpu #. Only available on some
    platforms. The first sub process or thread will begin on the specified processor. Future processes or threads will be placed on the next processor. Once the total number of cpus is exceeded then future processes or threads will be placed in a round robin fashion.
     
    -q #
    设置自动模式下使用的最大块大小(Kbytes) 。也可以通过-q #k ( Kbytes) 或 -q #m ( Mbytes) 或 -q #g ( Gbytes)。设置最小块大小见 –y 。
     
    -Q
    Create offset/latency files. Iozone will create latency versus offset data files that can be
    imported with a graphics package and plotted. This is useful for finding if certain offsets
    have very high latencies. Such as the point where UFS will allocate its first indirect block.
    One can see from the data the impacts of the extent allocations for extent based filesystems
    with this option.
     
    -r # 
    指定测试块 大小，K字节。也可以通过-r #k (Kbytes) 或 -r #m (Mbytes) 或 -r #g (Gbytes).
     
     
    -R
    生成Excel报告. Iozone将生成一个兼容Excel的标准输出报告。这个文件可以使用
     Microsoft Excel打开，可以创建一个文件系统性能的图表。注意：3D图表是面向列
    的。画图时你需要选择这项因为Excel默认处理面向行的数据。
     
     
    -s # 
    指定测试文件大小，K字节。也可以通过-s #k (Kbytes) 或 -s #m (Mbytes) 或 -s #g (Gbytes).
     
    -S #
    Set processor cache size to value (in Kbytes). This tells Iozone the size of the processor cache.
    It is used internally for buffer alignment and for the purge functionality.
     
    -t #
    以吞吐量模式运行Iozone。这一选项允许用户指定测试时使用多少个线程或者进程。
     
    -T
    吞吐量测试时使用POSIX线程。仅在兼容POSIX线程的平台上可用。
     
    -u #
    Set the upper limit on number of processes to run. When running throughput tests this
    option allows the user to specify the greatest number of processes or threads to start.
    This option should be used in conjunction with the -l option.
     
    -U mountpoint
    在测试之间卸载并重新挂载挂载点。这保证了缓存cache不包含任何测试过的文件。
     
     
    -v
    显示Iozone的版本号。
     
    -V #
    Specify a pattern that is to be written to the temporary file and validated for accuracy in
    each of the read tests.
     
    -w
    当临时文件使用完毕时不删除它们。把它们留在文件系统中。
     
    -W
    读或写时锁文件。
     
    -x
    关闭“stone-walling”. Stonewalling 是 Iozone内部使用的一种技术。它是在进行吞吐量测试时使用的。程序启动所有线程或进程然后将它们暂停在“壁垒”前。
    一旦它们都做好准备工作，它们将被同时释放。当其中任何一个线程或进程完成工作，整个测试就终止了并计算到达这个点时所有I/O的吞吐量。这保证了整个测试进行时所有的进程和线程都是并行的。这个标志位允许取消 stonewalling并看看会发生什么。
     
    -X filename
    Use this file for write telemetry information. The file contains  triplets of information:
    Byte offset, size of transfer, compute delay in milliseconds.  This option is useful if one has
    taken a system call trace of the application that is of interest.  This allows Iozone to replicate the I/O operations that this specific application generates and provide benchmark results for this file behavior.  (if column 1 contains # then the line is a comment)
     
    -y #
    设置自动模式下使用的最小块大小(Kbytes) 。也可以通过-y #k ( Kbytes) 或 -y #m ( Mbytes) 或 -y #g ( Gbytes)。设置最大块大小见 –y 。
     
    -Y filename
    Use this file for read telemetry information. The file contains triplets of information:
    Byte offset, size of transfer, compute delay in milliseconds.  This option is useful if one has
    taken a system call trace of the application that is of interest.  This allows Iozone to replicate the I/O operations that this specific application generates and provide benchmark results for this file behavior. (if column 1 contains # then the line is a comment)
     
    -z
    Used in conjunction with -a to test all possible record sizes. Normally Iozone omits testing
    of small record sizes for very large files when used in full automatic mode.  This option forces
    Iozone to include the small record sizes in the automatic tests also.
     
    -Z
    启动混合 mmap I/O 和文件 I/O.
     
    -+m filename
    Use this file to obtain the configuration information of the clients for cluster testing. The file contains one line for each client. Each line has three fields. The fields are space delimited. A # sign in column zero is a comment line. The first field is the name of the client. The second field is the path, on the client, for the working directory where Iozone will execute. The third field is the path, on the client, for the executable Iozone.
    To use this option one must be able to execute commands on the clients without being challenged for a password. Iozone will start remote execution by using “rsh”.
     
    -+u
    Enable CPU utilization mode.
     
    -+d
    启动诊断模式。在这一模式下每个字节都将被验证。这在怀疑I/O子系统出错时有用。
     
    -+p  percent_read
    Set the percentage of the thread/processes that will perform random read testing. Only valid in throughput mode and with more than 1 process/thread.
     
    -+r
    Enable O_RSYNC and O_SYNC for all I/O testing.
     
    -+t
    启动网络性能测试。需要 -+m
     
    -+A
    Enable madvise. 0 = normal, 1=random, 2=sequential, 3=dontneed, 4=willneed.
    For use with options that activate mmap() file I/O. See: -B
