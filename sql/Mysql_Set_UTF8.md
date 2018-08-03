/etc/mysql/conf.d/mysql.conf


show variables like '%char%';

[mysql]  
default-character-set = utf8  
[mysql_safe]  
default-character-set = utf8  
[client]  
default-character-set = utf8  
[mysqld]  
max_connections = 10240
init_connect  = 'SET NAMES utf8'  
character-set-server = utf8  
collation-server = utf8_unicode_ci  
-------------------------------------------------------------------------------------------
[mysql]  
default-character-set = utf8  

[client]
default-character-set = utf8  
port		= 3306
socket		= /var/run/mysqld/mysqld.sock

[mysqld_safe]
default-character-set = utf8  
pid-file	= /var/run/mysqld/mysqld.pid
socket		= /var/run/mysqld/mysqld.sock
nice		= 0

[mysqld]
init_connect  = 'SET NAMES utf8'  
character-set-server = utf8  
collation-server = utf8_unicode_ci  
skip-host-cache
skip-name-resolve
user		= mysql
pid-file	= /var/run/mysqld/mysqld.pid
socket		= /var/run/mysqld/mysqld.sock
port		= 3306
basedir		= /usr
datadir		= /var/lib/mysql
tmpdir		= /tmp
lc-messages-dir	= /usr/share/mysql
explicit_defaults_for_timestamp

# Instead of skip-networking the default is now to listen only on
# localhost which is more compatible and is not less secure.
#bind-address	= 127.0.0.1

#log-error	= /var/log/mysql/error.log

# Recommended in standard MySQL setup
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES

# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0

# * IMPORTANT: Additional settings that can override those from this file!
#   The files must end with '.cnf', otherwise they'll be ignored.
#
!includedir /etc/mysql/conf.d/
