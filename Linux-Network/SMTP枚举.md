##SMTP枚举

### smtp-user-enum 命令:
    smtp-user-enum -M VRFY -U user.txt -t smtp.qq.com
#### 结果:
    Mode ..................... VRFY          #使用的模式
    Worker Processes ......... 5             # 进程数
    Usernames file ........... user.txt      # 用户名文件
    Target count ............. 1             # 目标帐户数
    Username count ........... 5             # 文件帐户数
    Target TCP port .......... 25            # Port
    Query timeout ............ 5 secs        # 超时时间
    Target domain ............

    ######## Scan started at Tue Apr 18 11:28:36 2017 #########
    ######## Scan completed at Tue Apr 18 11:28:36 2017 #########

#### 命令帮助:
    /usr/bin/smtp-user-enum version [unknown] calling Getopt::Std::getopts (version 1.11 [paranoid]),
    running under Perl version 5.22.2.

    Usage: smtp-user-enum [-OPTIONS [-MORE_OPTIONS]] [--] [PROGRAM_ARG1 ...]

    The following single-character options are accepted:
    	With arguments: -m -u -U -s -S -r -t -M -f -D -p
    	Boolean (without arguments): -d -v -h

    Options may be merged together.  -- stops processing of options.
    Space is not required between options and their arguments.
      [Now continuing due to backward compatibility and excessive paranoia.
       See 'perldoc Getopt::Std' about $Getopt::Std::STANDARD_HELP_VERSION.]
    smtp-user-enum v1.2 ( http://pentestmonkey.net/tools/smtp-user-enum )

    Usage: smtp-user-enum.pl [options] ( -u username | -U file-of-usernames ) ( -t host | -T file-of-targets )

    options are:
            -m n     Maximum number of processes (default: 5)
    	-M mode  Method to use for username guessing EXPN, VRFY or RCPT (default: VRFY)
    	-u user  Check if user exists on remote system
    	-f addr  MAIL FROM email address.  Used only in "RCPT TO" mode (default: user@example.com)
            -D dom   Domain to append to supplied user list to make email addresses (Default: none)
                     Use this option when you want to guess valid email addresses instead of just usernames
                     e.g. "-D example.com" would guess foo@example.com, bar@example.com, etc.  Instead of
                          simply the usernames foo and bar.
    	-U file  File of usernames to check via smtp service
    	-t host  Server host running smtp service
    	-T file  File of hostnames running the smtp service
    	-p port  TCP port on which smtp service runs (default: 25)
    	-d       Debugging output
    	-t n     Wait a maximum of n seconds for reply (default: 5)
    	-v       Verbose
    	-h       This help message

    Also see smtp-user-enum-user-docs.pdf from the smtp-user-enum tar ball.

    Examples:

    $ smtp-user-enum.pl -M VRFY -U users.txt -t 10.0.0.1
    $ smtp-user-enum.pl -M EXPN -u admin1 -t 10.0.0.1
    $ smtp-user-enum.pl -M RCPT -U users.txt -T mail-server-ips.txt
    $ smtp-user-enum.pl -M EXPN -D example.com -U users.txt -t 10.0.0.1
