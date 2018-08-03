#定时清除elk索引，30天
DATE=`date -d "30 days ago" +%Y.%m.%d`
#INDEX=`curl -XGET 'http://127.0.0.1:9200/_cat/indices/?v'|awk '{print $3}'`
curl -XDELETE 'http://127.0.0.1:9200/*-$DATE'

# 查询 index 
# curl -XGET 'http://127.0.0.1:9200/_cat/indices/?v'
# curl -XDELETE 'http://127.0.0.1:9200/logstash-2017-01-01  