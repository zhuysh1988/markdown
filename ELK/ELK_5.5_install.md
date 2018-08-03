## ELK 5.5 安装
### 下载rpm 包 并安装
    jdk-8u65-linux-x64.rpm  
    elasticsearch-5.5.0.rpm  
    kibana-5.5.0-x86_64.rpm  
    logstash-5.5.0.rpm
    rpm -ivh jdk....

### ELK 目录
- ##### elasticsearch
    Bin_dir: /usr/share/elasticsearch
    Config_dir: /etc/elasticsearch
    Date_dir: /var/lib/elasticsearch
    start_command:
        systemctl daemon-reload
        systemctl enable elasticsearch.service
    Config_show:
    egrep -v '^$|^#' ../../elasticsearch/elasticsearch.yml
    cluster.name: bocloud
    node.name: node-114
    path.data: /var/lib/elasticsearch/data
    path.logs: /var/lib/elasticsearch/logs
    network.host: 0.0.0.0
    http.port: 9200

- ##### kibana
    Bin_dir: /usr/share/kibana
    Config_dir: /etc/kibana
    start_command:
        systemctl enable kibana
    Config_show:
    egrep -v '^$|^#' ../../kibana/kibana.yml
    server.port: 5601
    server.host: "0.0.0.0"
    elasticsearch.url: "http://localhost:9200"

- ##### logstash
    Bin_dir: /usr/share/logstash
    Config_dir: /etc/logstash
    start_command:
        systemctl enable logstash
