##Get-Date
###名称
    Get-Date

###摘要
    获取当前日期和时间。

    -------------------------- 示例 1 --------------------------

    C:\PS>get-date -DisplayHint date

    Tuesday, June 13, 2006


    说明
    -----------
    此命令检索 DateTime 对象，但只显示日期。它使用 DisplayHint 参数指示只显示日期。




    -------------------------- 示例 2 --------------------------

    C:\PS>get-date -format g

    6/13/2006 12:43 PM


    说明
    -----------
    此命令检索当前日期和时间，并将其设置为短日期和短时间格式。它使用 .NET Framework“g”格式说明符（通用[短日期和短时间]）来指定格式。




    -------------------------- 示例 3 --------------------------

    C:\PS>get-date -uformat "%Y / %m / %d / %A / %Z"

    2006 / 06 / 13 / Tuesday / -07


    说明
    -----------
    此命令检索当前日期和时间，并根据命令的指定来设置其格式。在这种情况下，格式包括年份的全称 (%Y)、两位数字的月份 (%m)、日期 (%d)、一周第几天的全称 (%A)，以及相对于 UTC 的时差（“Zulu”）。




    -------------------------- 示例 4 --------------------------

    C:\PS>(get-date -year 2000 -month 12 -day 31).dayofyear

    366


    说明
    -----------
    此命令显示当前日期是一年中的第几天。例如，12 月 31 日是 2006 年的第 365 天，但它是 2000 年的第 366 天。




    -------------------------- 示例 5 --------------------------

    C:\PS>$a = get-date

    C:\PS> $a.IsDaylightSavingTime()

    True


    说明
    -----------
    这些命令将显示当前的日期和时间是否调整为当前区域设置中的夏令时。

    第一条命令创建名为 $a 的变量，然后将由 Get-Date 检索的对象赋予该 $a 变量。然后，对 $a 中的对象使用 IsDaylightSavingTime 方法。

    要查看 DateTime 对象的属性和方法，请键入：
     "get-date | get-member".




    -------------------------- 示例 6 --------------------------

    C:\PS>$a = get-date

    C:\PS> $a.ToUniversalTime()

    Tuesday, June 13, 2006 8:09:19 PM


    说明
    -----------
    这些命令将当前日期和时间转换为 UTC 时间。

    第一条命令创建名为 $a 的变量，然后将由 Get-Date 检索的对象赋予该 $a 变量。然后，对 $a 中的对象使用 ToUniversalTime 方法。




    -------------------------- 示例 7 --------------------------

    C:\PS>$a = get-wmiobject win32_bios -computer server01

    $a | format-list -property Name, @{Label="BIOS Age"; `
    Expression={(get-date) - $_.ConvertToDateTime($_.ReleaseDate)}}

    Name     : Default System BIOS
    BIOS Age : 1345.17:31:07.1091047


    说明
    -----------
    Windows Management Instrumentation (WMI) 使用不同于 Get-Date 返回的 .NET Framework 日期时间对象的一个日期时间对象。若要在命令中将 WMI 中的日期时间信息与 Get-Date 中的日期时间信息一起使用，则必须使用 Conv
    ertToDateTime 方法将 WMI CIM_DATETIME 对象转换为 .NET Framework DateTime 对象。

    此示例中的命令将显示远程计算机 Server01 上的 BIOS 的 name 和 age。

    第一条命令使用 Get-WmiObject cmdlet 来获取 Server01 上的 Win32_BIOS 类的实例，然后将其存储到 $a 变量中。

    第二条命令使用管道运算符 (|) 将存储在 $a 中的 WMI 对象发送至 Format-List cmdlet。Format-List 的 Property 参数用于指定要在列表中显示的两个属性：“Name”和“BIOS Age”。“BIOS Age”属性将在哈希表中指定。该表包括 La
    bel 键（指定属性的名称）和 Expression 键（包含计算 BIOS age 的表达式）。该表达式使用 ConvertToDateTime 方法将 ReleaseDate 的每个实例转换为 .NET Framework DateTime 对象。然后，从 Get-Date cmdle
    t 的值中减去该值，此 cmdlet 在不带参数的情况下获取当前日期。

    在 Windows PowerShell 中，倒引号字符 (`) 为行继续符。




    -------------------------- 示例 8 --------------------------

    C:\PS>get-date

    Tuesday, June 13, 2006 12:43:42 PM


    说明
    -----------
    此命令获取 DateTime 对象并以系统区域设置的长日期和长时间格式来显示当前日期和时间，就好像您键入了“get-date -format F”一样。




    -------------------------- 示例 9 --------------------------

    C:\PS>get-date

    C:\PS> Tuesday, September 26, 2006 11:25:31 AM

    c:\PS>(get-date).ToString()
    9/26/2006 11:25:31 AM

    C:\PS>get-date | add-content test.txt  
    # Adds 9/26/2006 11:25:31 AM

    C:\PS>get-date -format F | add-content test.txt
    # Adds Tuesday, September 26, 2006 11:25:31 AM


    说明
    -----------
    这些命令演示了如何结合使用 Get-Date 和 Add-Content 以及其他 cmdlet（这些 cmdlet 可将 Get-Date 生成的 DateTime 对象转换为字符串）。

    第一条命令表明“get-date”命令的默认显示采用长日期和长时间格式。

    第二条命令表明 DateTime 对象的 ToString() 方法的默认显示采用短日期和短时间格式。

    第三条命令使用管道运算符将 DateTime 对象发送至 Add-Content cmdlet，该 cmdlet 将内容添加到 Test.txt 文件中。由于 Add-Content 使用 DateTime 对象的 ToString() 方法，所以所添加的日期采用短日期和短时间格式。

    第四条命令使用 Get-Date 的 Format 参数来指定格式。当使用 Format 或 UFormat 参数时，Get-Date 生成字符串，而不是 DateTime 对象。之后，当您将字符串发送到 Add-Content 时，它会在不更改字符串的情况下直接将该字符串添加到 Test
    .txt 文件中。
