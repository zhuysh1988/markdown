## Select-String
###名称
    Select-String

###摘要
    查找字符串和文件中的文本。

###语法
    Select-String [-Path] <string[]> [-Pattern] <string[]> [-AllMatches] [-CaseSensitive] [-Context <Int32[]>] [-Encoding <string>] [-Exclude <string
    []>] [-Include <string[]>] [-List] [-NotMatch] [-Quiet] [-SimpleMatch] [<CommonParameters>]

    Select-String -InputObject <psobject> [-Pattern] <string[]> [-AllMatches] [-CaseSensitive] [-Context <Int32[]>] [-Encoding <string>] [-Exclude <s
    tring[]>] [-Include <string[]>] [-List] [-NotMatch] [-Quiet] [-SimpleMatch] [<CommonParameters>]


###说明
    Select-String cmdlet 在输入字符串和文件中搜索文本和文本模式。您可以像在 UNIX 中使用 Grep、在 Windows 中使用 Findstr 一样使用该命令。

    Select-String 以文本行为基础。默认情况下，Select-String 会查找每行中的第一个匹配项，对于每个匹配项，它会显示文件名、行号以及包含匹配项的行中的所有文本。

    但是，您可以指示它检测每行中的多个匹配项，显示匹配项前后的文本，或只显示指明是否找到匹配项的布尔值（True 或 False）。

    Select-String 使用正则表达式匹配，但它还执行简单匹配，以在输入内容中搜索您指定的文本。

    Select-String 可以显示每个输入文件的所有文本匹配项或者在找到第一个匹配项后停止。它还可以显示与指定模式不匹配的所有文本。

    您还可以指定 Select-String 应采用特定的字符编码（例如搜索 Unicode 文本文件时）。


###参数
    -AllMatches [<SwitchParameter>]
        在每个文本行中搜索多个匹配项。若不使用此参数，Select-String 只会查找每个文本行中的第一个匹配项。

        当 Select-String 在一个文本行中找到多个匹配项时，它仍然只会为该行发出一个 MatchInfo 对象，但是该对象的 Matches 属性包含所有匹配项。

        是否必需?                    False
        位置?                        named
        默认值                
        是否接受管道输入?            false
        是否接受通配符?              False

    -CaseSensitive [<SwitchParameter>]
        使匹配项区分大小写。默认情况下，匹配项不区分大小写。

        是否必需?                    False
        位置?                        named
        默认值                
        是否接受管道输入?            false
        是否接受通配符?              False

    -Context <Int32[]>
        捕获包含匹配项的行前后的指定行数。这允许您在上下文中查看匹配项。

        如果您输入一个数字作为此参数的值，该数字将确定捕获的匹配项前后的行数。如果您输入两个数字作为此参数的值，则第一个数字将确定匹配项前面的行数，第二个数字确定匹配后面的行数。

        在默认显示中，包含匹配项的行会通过显示内容第一列中的右尖括号 (ASCII 62) 来指示。无标记行是上下文。

        此参数不会更改 Select-String 生成的对象数。Select-String 会为每个匹配项生成一个 MatchInfo (Microsoft.PowerShell.Commands.MatchInfo) 对象。上下文以字符串数组的形式存储在该对象的 Context 属性中
        。

        当您将 Select-String 命令的输出通过管道传递给另一个 Select-String 命令时，接收命令只搜索匹配行（MatchInfo 对象的 Line 属性的值）中的文本，而不会搜索上下文行中的文本。因此，Context 参数在接收 Select-String 命令上无
        效。

        当上下文包括匹配项时，每个匹配项的 MatchInfo 对象都将包括所有上下文行，但是重叠行只会在显示内容中出现一次。

        是否必需?                    False
        位置?                        named
        默认值                
        是否接受管道输入?            false
        是否接受通配符?              False

    -Encoding <string>
        指定 Select-String 在搜索文件时应采用的字符编码。默认值为 UTF8。

        有效值包括“UTF7”、“UTF8”、“UTF32”、“ASCII”、“Unicode”、“BigEndianUnicode”、“Default”和“OEM”。“Default”是系统当前 ANSI 代码页的编码。“OEM”是操作系统的当前原始设备制造商代码页标识符。

        是否必需?                    False
        位置?                        named
        默认值                
        是否接受管道输入?            false
        是否接受通配符?              False

    -Exclude <string[]>
        排除指定项。此参数的值对 Path 参数进行限定。请输入路径元素或模式，例如“*.txt”。允许使用通配符。

        是否必需?                    False
        位置?                        named
        默认值                
        是否接受管道输入?            false
        是否接受通配符?              False

    -Include <string[]>
        只包括指定项。此参数的值对 Path 参数进行限定。请输入路径元素或模式，例如“*.txt”。允许使用通配符。

        是否必需?                    False
        位置?                        named
        默认值                
        是否接受管道输入?            false
        是否接受通配符?              False

    -InputObject <psobject>
        指定要搜索的文本。请输入包含文本的变量，或键入可获取文本的命令或表达式。

        是否必需?                    True
        位置?                        named
        默认值                
        是否接受管道输入?            true (ByValue)
        是否接受通配符?              False

    -List [<SwitchParameter>]
        只返回每个输入文件中的第一个匹配项。默认情况下，Select-String 会为它找到的每个匹配项返回一个 MatchInfo 对象。

        是否必需?                    False
        位置?                        named
        默认值                
        是否接受管道输入?            false
        是否接受通配符?              False

    -NotMatch [<SwitchParameter>]
        查找与指定模式不匹配的文本。

        是否必需?                    False
        位置?                        named
        默认值                
        是否接受管道输入?            false
        是否接受通配符?              False

    -Path <string[]>
        指定要搜索的文件的路径。允许使用通配符。默认位置为本地目录。

        指定目录中的文件，如“log1.txt”、“*.doc”或“*.*”。如果只指定一个目录，该命令会失败。

        是否必需?                    True
        位置?                        2
        默认值                
        是否接受管道输入?            true (ByPropertyName)
        是否接受通配符?              False

    -Pattern <string[]>
        指定要查找的文本。键入字符串或正则表达式。如果您键入字符串，则使用 SimpleMatch 参数。

        若要了解正则表达式，请参阅 about_Regular_Expressions。

        是否必需?                    True
        位置?                        1
        默认值                
        是否接受管道输入?            false
        是否接受通配符?              False

    -Quiet [<SwitchParameter>]
        返回布尔值（True 或 False），而不是 MatchInfo 对象。如果找到模式，则该值为“True”，否则为“False”。

        是否必需?                    False
        位置?                        named
        默认值                
        是否接受管道输入?            false
        是否接受通配符?              False

    -SimpleMatch [<SwitchParameter>]
        使用简单匹配，而不是正则表达式匹配。在简单匹配中，Select-String 会在输入内容中搜索 Pattern 参数中的文本。它不会将 Pattern 参数的值解释为正则表达式语句。

        是否必需?                    False
        位置?                        named
        默认值                
        是否接受管道输入?            false
        是否接受通配符?              False

    <CommonParameters>
        此 cmdlet 支持通用参数: Verbose、Debug、
        ErrorAction、ErrorVariable、WarningAction、WarningVariable、
        OutBuffer 和 OutVariable。有关详细信息，请键入
        “get-help about_commonparameters”。

    输入
    System.Management.Automation.PSObject
        可以通过管道将具有 ToString 方法的任何对象传递给 Select-String。


    输出
    Microsoft.PowerShell.Commands.MatchInfo 或 System.Boolean
        默认情况下，输出内容是一组 MatchInfo 对象，每个找到的匹配项对应于一个 MatchInfo 对象。如果使用 Quiet 参数，则输出内容是一个指示是否找到模式的布尔值。


    注释


        Select-String 类似于 UNIX 中的 Grep 命令和 Windows 中的 FindStr 命令。

        若要使用 Select-String，请键入要查找的文本作为 Pattern 参数的值。


        若要指定要搜索的文本，请执行以下操作：

        -- 以带引号字符串的形式键入文本，然后通过管道将其传递给 Select-String。
        -- 将文本字符串存储到变量中，然后将该变量指定为 InputObject 参数的值。
        -- 如果文本存储在文件中，则使用 Path 参数指定文件的路径。


        默认情况下，Select-String 会将 Pattern 参数的值解释为正则表达式。（有关详细信息，请参阅 about_Regular_Expressions。）不过，您可以使用 SimpleMatch 参数来重写正则表达式匹配。SimpleMatch 参数会在输入内容中查找
        Pattern 参数值的实例。

        Select-String 的默认输出是 MatchInfo 对象，它包含有关匹配项的详细信息。当您在文件中搜索文本时，该对象中的信息非常有用，因为 MatchInfo 对象具有 Filename 和 Line 之类的属性。当输入内容不是来自文件时，这些参数的值是“InputStr
        eam”。

        如果您不需要 MatchInfo 对象中的信息，可使用 Quiet 参数，它会返回一个布尔值（True 或 False）以指明是否找到了匹配项，而不返回 MatchInfo 对象。

        匹配短语时，Select-String 使用为系统设置的当前区域性。若要查找当前区域性，请使用 Get-Culture cmdlet。

        若要查找 MatchInfo 对象的属性，请键入：

        select-string -path test.txt -pattern "test" | get-member | format-list -property *

### 示例
    -------------------------- 示例 1 --------------------------

    C:\PS>"Hello","HELLO" | select-string -pattern "HELLO" -casesensitive


    说明
    -----------
    此命令为通过管道传递给 Select-String 命令的文本执行区分大小写的匹配。

    因此，Select-String 只查找“HELLO”，因为“Hello”不匹配。

    因为每个带引号的字符串都被视为一行，所以若不使用 CaseSensitive 参数，Select-String 会将这两个字符串都识别为匹配项。





    -------------------------- 示例 2 --------------------------

    C:\PS>select-string -path *.xml -pattern "the the"


    说明
    -----------
    此命令在当前目录中搜索所有扩展名为 .xml 的文件，并显示这些文件中包含字符串“the the”的各行。





    -------------------------- 示例 3 --------------------------

    C:\PS>select-string -path $pshome\en-US\*.txt -pattern "@"


    说明
    -----------
    此命令在 Windows PowerShell 概念性帮助文件 (about_*.txt) 中搜索有关 at 符号 (@) 用法的信息。

    为了指示路径，此命令使用 $pshome 自动变量的值，该变量存储 Windows PowerShell 安装目录的路径。在此示例中，该命令搜索 en-US 子目录，该目录包含 Windows PowerShell 的美国英语版帮助文件。





    -------------------------- 示例 4 --------------------------

    C:\PS>function search-help
    {
        $pshelp = "$pshome\es\about_*.txt", "$pshome\en-US\*dll-help.xml"
        select-string -path $pshelp -pattern $args[0]
    }


    说明
    -----------
    这一简单函数使用 Select-String cmdlet 在 Windows PowerShell 帮助文件中搜索特定字符串。在此示例中，该函数在“en-US”子目录中搜索美国英语语言文件。

    若要使用该函数查找字符串（如“psdrive”），请键入“search-help psdrive”。

    若要在任何 Windows PowerShell 控制台中使用此函数，请将路径更改为指向系统上的 Windows PowerShell 帮助文件，然后将该函数粘贴到您的 Windows PowerShell 配置文件中。





    -------------------------- 示例 5 --------------------------

    C:\PS>$events = get-eventlog -logname application -newest 100

    C:\PS> $events | select-string -inputobject {$_.message} -pattern "failed"


    说明
    -----------
    此示例在事件查看器的应用程序日志的 100 个最新事件中搜索字符串“failed”。

    第一条命令使用 Get-EventLog cmdlet 从应用程序事件日志中获取 100 个最新事件。然后，它将事件存储在 $events 变量中。

    第二条命令使用管道运算符 (|) 将 $events 变量中的对象发送到 Select-String。它使用 InputObject 参数代表来自 $events 变量的输入。InputObject 参数的值是每个通过管道传递的对象的 Message 属性。当前对象由 $_ 符号表示。

    当每个事件到达管道中时，Select-String 会在它的 Message 属性值中搜索“failed”字符串，然后显示包含匹配项的所有行。





    -------------------------- 示例 6 --------------------------

    C:\PS>get-childitem c:\windows\system32\* -include *.txt -recurse |
    select-string -pattern "Microsoft" -casesensitive


    说明
    -----------
    此命令检查 C:\Windows\System32 子目录中所有扩展名为 .txt 的文件，并搜索字符串“Microsoft”。CaseSensitive 参数指明“Microsoft”中的“M”必须大写，其余字符必须小写，以便 Select-String 按此条件查找匹配项。





    -------------------------- 示例 7 --------------------------

    C:\PS>select-string -path process.txt -pattern idle, svchost -notmatch


    说明
    -----------
    此命令查找 Process.txt 文件中不包括“idle”或“svchost”字词的文本行。





    -------------------------- 示例 8 --------------------------

    C:\PS>$f = select-string -path audit.log -pattern "logon failed" -context 2, 3

    C:\PS> $f.count

    C:\PS> ($f)[0].context | format-list


    说明
    -----------
    第一条命令在 Audit.Log 文件中搜索短语“logon failed”。它使用 Context 参数捕获匹配项的前 2 行和后 3 行。

    第二条命令使用对象数组的 Count 属性来显示找到的匹配项数，在本例中为 2。

    第三条命令显示第一个 MatchInfo 对象的 Context 属性中存储的行。它使用数组表示法指明第一个匹配项（在从零开始的数组中为匹配项 0），然后使用 Format-List cmdlet 以列表形式显示 Context 属性的值。

    输出内容包括两个 MatchInfo 对象，每个检测到的匹配项一个。上下文行存储在 MatchInfo 对象的 Context 属性中。





    -------------------------- 示例 9 --------------------------

    C:\PS>$a = get-childitem $pshome\en-us\about*.help.txt | select-string -pattern transcript


    C:\PS> $b = get-childitem $pshome\en-us\about*.help.txt | select-string -pattern transcript -allmatches

    C:\PS> $a
    C:\Windows\system32\WindowsPowerShell\v1.0\en-us\about_Pssnapins.help.txt:39:       Start-Transcript and Stop-Transcript.

    C:\PS> $b
    C:\Windows\system32\WindowsPowerShell\v1.0\en-us\about_Pssnapins.help.txt:39:       Start-Transcript and Stop-Transcript.


    C:\PS>> $a.matches
    Groups   : {Transcript}
    Success  : True
    Captures : {Transcript}
    Index    : 13
    Length   : 10
    Value    : Transcript


    C:\PS> $b.matches
    Groups   : {Transcript}
    Success  : True
    Captures : {Transcript}
    Index    : 13
    Length   : 10
    Value    : Transcript

    Groups   : {Transcript}
    Success  : True
    Captures : {Transcript}
    Index    : 33
    Length   : 10
    Value    : Transcript


    说明
    -----------
    此示例说明 Select-String 的 AllMatches 参数的作用。AllMatches 会查找一行中的所有模式匹配，而不是只查找每行中的第一个匹配项。

    该示例中的第一条命令在 Windows PowerShell 概念性帮助文件（“about”帮助）中搜索单词“transcript”。第二条命令与之相同，只不过它使用 AllMatches 参数。

    第一条命令的输出保存在 $a 变量中，第二条命令的输出保存在 $b 变量中。

    当您显示变量的值时，默认显示是相同的，如输出示例中所示。

    但是，第五条和第六条命令会显示每个对象的 Matches 属性的值。第一条命令的 Matches 属性只包含一个匹配项（也就是一个 System.Text.RegularExpressions.Match 对象），而第二条命令的 Matches 属性包含该行中两个匹配项的对象。
