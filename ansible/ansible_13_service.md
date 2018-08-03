## service模块
### 模块说明

>service模块说白了，就是Linux下的service命令。但是它更简单。这个是playbook中用的非常多的模块。

### 常用参数
|参数名 |	 是否必须 	|默认值 |	选项 |	说明|
|:-|:-|:-|:-|:-|
|enabled |	no |		  yes/no ||	      启动os后启动对应service的选项。使用service模块的时候，enabled和state至少要有一个被定义|
|name    |	yes| 			|    |           需要进行操作的service名字|
|state 	 | no |		  |           stared/stoped/restarted/reloaded |	service最终操作后的状态。|
案例

# 不管当前什么情况，启动apache
- service: name=httpd state=started

# 不管当前什么情况，停止apache
- service: name=httpd state=stopped

# 不管当前什么情况，重启apache
- service: name=httpd state=restarted


# 系统重启后，启动apache
- service: name=httpd enabled=yes