>在~/.pip/pip.conf文件中添加或修改

    mkdir -p ~/.pip

    cat <<EOF >~/.pip/pip.conf
    [global]
    index-url = http://mirrors.aliyun.com/pypi/simple/

    [install]
    trusted-host=mirrors.aliyun.com
    EOF
