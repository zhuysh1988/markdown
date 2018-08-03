


* 如果您需要使用私有registry在安装过程中提取这些映像，则可以提前指定注册表信息。
* 对于高级安装方法，可以根据需要在库存文件中设置以下Ansible变量： 
```
openshift_docker_additional_registries=<registry_hostname>
openshift_docker_insecure_registries=<registry_hostname>
openshift_docker_blocked_registries=<registry_hostname>
```
* example
```
oreg_url=registry.example.com:5000/openshift3/ose-${component}:${version}
openshift_docker_additional_registries=registry.example.com:5000
openshift_docker_insecure_registries=registry.example.com:5000
openshift_examples_modify_imagestreams=true
```

* 对于快速安装方法，您可以在每个目标主机上导出以下环境变量：
```bash
export OO_INSTALL_ADDITIONAL_REGISTRIES=<registry_hostname>
export OO_INSTALL_INSECURE_REGISTRIES=<registry_hostname>
```

> 当前无法使用快速安装方法指定blocked的Docker registry。



