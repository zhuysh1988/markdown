## Get-Random
###名称
    Get-Random

###摘要
    从集合中获取随机数或随机选择对象。

    -------------------------- 示例 1 --------------------------

    C:\PS>get-random

    3951433


    说明
    -----------
    此命令获取处于 0（零）和 Int32.MaxValue 之间的一个随机整数。




    -------------------------- 示例 2 --------------------------

    C:\PS>get-random -maximum 100

    47


    说明
    -----------
    此命令获取处于 0（零）和 99 之间的一个随机整数。




    -------------------------- 示例 3 --------------------------

    C:\PS>get-random -minimum -100 -maximum 100

    -56


    说明
    -----------
    此命令获取处于 -100 和 99 之间的一个随机整数。




    -------------------------- 示例 4 --------------------------

    C:\PS>get-random -min 10.7 -max 20.93

    18.08467273887


    说明
    -----------
    此命令获取一个大于或等于 10.7 且小于 20.92 的随机浮点数。




    -------------------------- 示例 5 --------------------------

    C:\PS>get-random -input 1, 2, 3, 5, 8, 13

    8


    说明
    -----------
    此命令从指定的数组中获取一个随机选择的数。




    -------------------------- 示例 6 --------------------------

    C:\PS>get-random -input 1, 2, 3, 5, 8, 13 -count 3

    3
    1
    13


    说明
    -----------
    此命令从数组中按随机顺序获取三个随机选择的数。




    -------------------------- 示例 7 --------------------------

    C:\PS>get-random -input 1, 2, 3, 5, 8, 13 -count ([int]::MaxValue)

    2
    3
    5
    1
    8
    13


    说明
    -----------
    此命令按随机顺序返回整个集合。Count 参数的值是整数的 MaxValue 静态属性。

    若要按随机顺序返回整个集合，请输入大于或等于该集合中的对象数的任何数字。




    -------------------------- 示例 8 --------------------------

    C:\PS>get-random -input "red", "yellow", "blue"

    yellow


    说明
    -----------
    此命令返回非数字集合中的随机值。




    -------------------------- 示例 9 --------------------------

    C:\PS>get-process | get-random

    Handles  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     Id ProcessName
    -------  ------    -----      ----- -----   ------     -- -----------
        144       4     2080        488    36     0.48   3164 wmiprvse


    说明
    -----------
    此命令从计算机上的进程集合中获取随机选择的进程。




    -------------------------- 示例 10 --------------------------

    C:\PS>get-content servers.txt | get-random -count (get-content servers.txt).count | foreach {invoke-expression -computer $_ -command 'get-process
     powershell'}


    说明
    -----------
    此命令按随机顺序在一系列远程计算机上运行命令。




    -------------------------- 示例 11 --------------------------

    C:\PS>get-random -max 100 -setseed 23


    # Commands with the default seed are pseudorandom
    PS C:\ps-test> get-random -max 100
    59
    PS C:\ps-test> get-random -max 100
    65
    PS C:\ps-test> get-random -max 100
    21

    # Commands with the same seed are not random
    PS C:\ps-test> get-random -max 100 -setseed 23
    74
    PS C:\ps-test> get-random -max 100 -setseed 23
    74
    PS C:\ps-test> get-random -max 100 -setseed 23
    74

    # SetSeed results in a repeatable series
    PS C:\ps-test> get-random -max 100 -setseed 23
    74
    PS C:\ps-test> get-random -max 100
    56
    PS C:\ps-test> get-random -max 100
    84
    PS C:\ps-test> get-random -max 100
    46
    PS C:\ps-test> get-random -max 100 -setseed 23
    74
    PS C:\ps-test> get-random -max 100
    56
    PS C:\ps-test> get-random -max 100
    84
    PS C:\ps-test> get-random -max 100
    46


    说明
    -----------
    此示例演示了使用 SetSeed 参数的效果。因为 SetSeed 会产生非随机行为，所以它通常仅用于重现结果，例如调试或分析脚本时。




    -------------------------- 示例 12 --------------------------

    C:\PS>$files = dir -path c:\* -recurse

    C:\PS> $sample = $files | get-random -count 50


    说明
    -----------
    这些命令从本地计算机的 C: 驱动器中获取随机选择的包含 50 个文件的样本。




    -------------------------- 示例 13 --------------------------

    C:\PS>get-random 10001

    7600


    说明
    -----------
    此命令获取小于 10001 的随机整数。因为 Maximum 参数具有位置 1，所以当该值是命令中的第一个或唯一的未命名参数时，您可以忽略该参数名称。
