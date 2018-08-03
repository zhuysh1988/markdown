PowerShell

###在PowerShell中运行有空格的命令或者目录:
    & 'C:\Program Files\2345Soft\HaoZip\haozip.exe'
    & '.\hao zip.exe'

###更改PowerShell的执行策略
#####查询PowerShell的执行策略
    Get-ExecutionPolicy
#####设置PowerShell的执行策略
    Set-ExecutionPolicy
        1 受限 Restricted
            在此策略下,PowerShell只是作为一个交互式shell程序运行,试图运行一个脚本时会生成错误信息
        2 签名 Allsingned
             powershell只能运行包含数字签名的脚本,当你尝试运行由一个powershell没有见过的发行都签名的脚本时,会先询问,再执行
        3 远程签名 (推荐) remote signed
            powershell运行大多数脚本而不提示.
        4 不受限制 Unrestricted
            不需要任何脚本包含数字签名,但当脚本来自互联网时,会有警告

# 查找实现指定任务的命令
    Get-Command
    Example:
        Get-Command Get-Process
        Get-Command *string*
        Get-Command -Verb Get
        Get-Command -Noun Service

# 查看指定命令的帮助信息
    Get-Help
    Example:
        Get-Help Get-Process  OR  Get-Process -?
        #查看详细帮助信息
        Get-Help Get-Process -Detailed
        # 查看所有帮助信息
        Get-Help Get-Process -Full
        # 查看使用示例
        Get-Help Get-Process -Examples
