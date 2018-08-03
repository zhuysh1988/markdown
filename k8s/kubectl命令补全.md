## kubectl 命令自动补全

>在k8s 1.3版本之前，设置kubectl命令自动补全是通过以下的方式：

    source ./contrib/completions/bash/kubectl 
>但是在k8s 1.3版本，源码contrib目录中已经没有了completions目录，无法再使用以上方式添加自动补全功能。

>1.3版本中，kubectl添加了一个completions的命令， 该命令可用于自动补全

    source <(kubectl completion bash) 
>通过以上方法进行配置了，便实现了kubectl的自动补全。

### 在Linux上

yum install -y bash-completion
locate bash_completion /usr/share/bash-completion/bash_completion
source /usr/share/bash-completion/bash_completion
source <(kubectl completion bash)
###在mac上

    $ brew install bash-completion
    $ source $(brew --prefix)/etc/bash_completion
    $ source <(kubectl completion bash)