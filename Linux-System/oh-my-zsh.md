首先安装zsh

1
apt-get install zsh
然后安装oh-my-zsh

1
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
最后使用zsh替换bash

1
chsh -s `which zsh`
修改终端主题
通过修改~/.zshrc来进行配置，修改如下

1
ZSH_THEME="agnoster"


http://ohmyz.sh/

$ sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"


$ sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
