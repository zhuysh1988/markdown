## 执行前的设定

>安装完毕Ansible后，肯定急迫的需要测试下它了吧？稍等下，我们还需要简单设置些配置，才能让你非常爽快的让它带你爽带你飞。

### Ansible的config：

>它的Config文件呢，默认在/etc/ansible/ansible.cfg。里面有很多关于config的东西。我们用它是为了解决自己的问题对吧，所以我们不需要知道里面具体干啥了，我们只需要知道我们要做啥。

>第一步，就是我们的ansible的机器，需要链接上被它控制的机器。因为ansible的ssh是默认有个检查key的设置，我们第一次使用它，肯定对面机器没有Public key啊，所以我们要关闭配置文件内的private key的检查：

    host_key_checking = False


>记得找到上面这个参数，把#去掉，然后加上NO。这样第一次链接被控制的机器的时候，就不会问你是否检查private key了。

>或者在系统变量中：

    $ export ANSIBLE_HOST_KEY_CHECKING=False


>达到一样的效果。

### 生成ssh-key

>生成ssh-key这部分，就不再多说了。

### 创建你的hosts

>你需要创建你自己的Hosts，虽然ansible有默认的hosts文件，不过我建议你用你自己的。别管它默认的。

    $ cd $your_path
    $ touch hosts

>然后就是要把你想控制的机器的ip\域名等等按照ansible的格式写进去：

- ### Example：

    [webservers]
    foo.example.com
    bar.example.com


>什么意思呢？我把域名为foo.example.com和bar.example.com的2个机器，分给了webservers组。
嗯？你看出来了节点管理？很好。那个我们以后再说，现在先回到第一次ansible的运行。
除了域名也可以这样：

    [webservers]
    192.168.10.12
    127.152.112.13



>这时候，有经验的运维人员，肯定纳闷，又没配好ssh，又没地方写密码用户，怎么连过去？

>这里ansible是准备好了答案的，它支持在ssh配好以前，使用用户名密码登录远程机器

    [webservers]
    192.168.10.12  ansible_ssh_pass=123456 ansible_ssh_user=root
    127.152.112.13 ansible_ssh_pass=123567 ansible_ssh_user=root


>这么一设置，能理解了吧？那么我们本次第一次运行ansible的准备工作也差不多了。

### 第一次执行ansible

>到了令人激动的时刻，经过简单的安装与设置后，我们终于可以同时操作N台机器了，当然这里举例只有2台。

    $ ansible -i hosts all -m ping

>这里执行了ansible的最简单的模块ping，让它对所有在Hosts里的机器进行ping.

>结果应该会返回一个pong。很有趣是吧？
