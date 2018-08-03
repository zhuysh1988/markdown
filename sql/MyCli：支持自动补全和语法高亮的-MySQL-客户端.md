##MyCli：支持自动补全和语法高亮的 MySQL 客户端



>MyCli 是一个 MySQL 命令行工具，支持自动补全和语法高亮。也可用于 MariaDB 和 Percona。

##Quick Start

###如果你已会安装 Python 包，那就简单了：


    $ pip install mycli


###如果你是在 OS X 平台，那就用 homebrew：


    $ brew install mycli

##HELP
    $ mycli --help
    Usage: mycli [OPTIONS] [DATABASE]
    
    Options:
      -h, --host TEXT         Host address of the database.
      -P, --port TEXT         Port number to use for connection. Honors
                              $MYSQL_TCP_PORT
      -u, --user TEXT         User name to connect to the database.
      -S, --socket TEXT       The socket file to use for connection.
      -p, --password          Force password prompt.
      --pass TEXT             Password to connect to the database
      -v, --version           Version of mycli.
      -D, --database TEXT     Database to use.
      -R, --prompt TEXT       Prompt format (Default: "\t \u@\h:\d> ")
      -l, --logfile FILENAME  Log every query and its results to a file.
      --help                  Show this message and exit.

###示例


    $ mycli local_database
    $ mycli -h localhost -u root app_db
    $ mycli mysql://amjith@localhost:3306/django_poll
