出现认证问题，应该是设置了认证密码，输入密码既可以啦

注意密码是字符串形式！

[plain] view plain copy 在CODE上查看代码片派生到我的代码片

127.0.0.1:6379> auth "yourpassword"  

------------------------------------------------------------

[plain] view plain copy 在CODE上查看代码片派生到我的代码片

127.0.0.1:6379> set name "hello"  

(error) NOAUTH Authentication required.  

127.0.0.1:6379> (error) NOAUTH Authentication required.  

(error) ERR unknown command '(error)'  

127.0.0.1:6379> auth "root"  



可以进入



127.0.0.1:6379> auth "root"

OK
