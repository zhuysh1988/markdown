## Yum模块

### 模块常用参数
|参数名|是否必须|默认值|选项值|参数说明|
|:-|:-|:-|:-|:-|
|conf_file|不|||设定远程yum执行时所依赖的yum配置文件|
|disable_gpg_check|不|No|Yes/No|在安装包前检查包，只会影响state参数为present或者latest的时候|
|list|No|||只能由ansible调用，不支持playbook，这个干啥的大家都懂|
|name|Yes|||你需要安装的包的名字，也能如此使用name=python=2.7安装python2.7|
|state|no|present|present/latest/absent|用于描述安装包最终状态，present/latest用于安装包，absent用于remove安装包|
|update_cache|no|no|yes/no|用于安装包前执行更新list,只会影响state参数为present/latest的时候|

## 案例


- ###  安装最新版本的apache
      yum: name=httpd state=latest

- ### 移除apache
      yum: name=httpd state=absent

- ### 安装一个特殊版本的apache
      yum: name=httpd-2.2.29-1.4.amzn1 state=present

- ### 升级所有的软件包
      yum: name=* state=latest

- ### 从一个远程yum仓库安装nginx
      yum: name=http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm state=present

- ### 从本地仓库安装nginx
      yum: name=/usr/local/src/nginx-release-centos-6-0.el6.ngx.noarch.rpm state=present

- ### 安装整个Development tools相关的软件包
      yum: name="@Development tools" state=present
