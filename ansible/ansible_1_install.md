## 安装ansible 
>如何获取Ansible：https://github.com/ansible/ansible
你能从这里ansible-github地址看到它的代码实现方式，也能给它提issue。

- ### Ansible安装很简单：

        Ubuntu系列
        CentOS系列
        MacOS
        其他

- ### Ansible的依赖

        python 2.7，这个是必须的。
        网络， 你需要部署的机器的网络是必须相互通的，如何check这个，就不在这说了，任何维护人员都懂。
        linux源， 这个也是必须的，比如有些公司无法上外网，那么你就得在内部镜像一个。
        pip源，如果你的linux很奇葩，没关系，pip也能装ansible。
        Linux only， ansible现在只能在linux下完美运行。得益于SSH的原因，因为windows下面没有天生的ssh。


>以上1-3是必须满足的，4或5，2者最少满足其一。那么你才能跟随这个文章继续下去。

## Ansible的安装 
- ### Ubuntu系列

>很简单，你只要会用apt-get就能装好它。

    $ sudo apt-get install software-properties-common
    $ sudo apt-add-repository ppa:ansible/ansible
    $ sudo apt-get update
    $ sudo apt-get install ansible



- ### Centos系列：

    $ sudo yum install ansible


- ### MacOS系列：

    $ brew update
    $ brew install ansible


- ### 其他：

>这个模式应该99%的Linux都支持，先装好Python 2.7然后装pip，以及easy_install大家都懂的。然后执行：

    $ sudo pip install ansible


## 验证安装成功：

    $ ansible --version

