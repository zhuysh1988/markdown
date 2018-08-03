## es简易指南
### 1.查看所有index：

	GET _cat/indices
### 2.查看索引的type、mapping：

	GET  [indexName]/_mapping
	GET  [indexName]/_mappings
	GET  [indexName]/_mapping/[type]
### 3.查看某索引的某类型的数据：

	GET [indexName]/[type]/_search
### 4.过滤：

	GET [indexName]/[type]/_search
	{
	    "query": {
	        "filtered": {
	            "query":  { "match": { "email": "business opportunity" }},
	            "filter": { "term": { "folder": "inbox" }}
	        }
	    }
	}
### 5.查看分词器分词：

#####常用分词器：
	standard whitespace simple english pinyin ik
	GET /_analyze?analyzer=ik
	{
	  "text":"ahaha傻笑high"
	}
	GET /_analyze
	{
	  "analyzer":"ik",
	  "text":"ahaha傻笑high"
	}
### 6.查询指定的部分字段：

#####通过限定 _source 字段来请求指定字段
	GET [indexName]/[type]/_search
	{
	    "query":   { "match_all": {}},
	    "_source": [ "title", "created" ]
	}
### 7.范围查询：

	GET [indexName]/[type]/_search
	{
	  "query":{
	  "字段名"：{//范围[148,200)
	      "gte":148,
	      "lt":200
	    }
	  }
	}
### 8.重建索引：

>使用【scan-scoll】来批量读取旧索引的文档，然后将通过【bulk API】来将它们推送给新的索引。

	GET /old_index/_search?search_type=scan&scroll=1m
	{
	  //获取数据应该通过范围查询进行
	  //scan-scoll性能比通过范围在各个分片排序再获取好
	    "query": {
	        "range": {
	            "date": {
	                "gte":  "2014-01-01",
	                "lt":   "2014-02-01"
	            }
	        }
	    },
	    "size":  1000
	}
###### POST _bulk//批量操作
	{ "index" : { "_index" : "test", "_type" : "type1", "_id" : "1" } }
	{ "field1" : "value1" }
	{ "delete" : { "_index" : "test", "_type" : "type1", "_id" : "2" } }
	{ "create" : { "_index" : "test", "_type" : "type1", "_id" : "3" } }
	{ "field1" : "value3" }
	{ "update" : {"_id" : "1", "_type" : "type1", "_index" : "test"} }
	{ "doc" : {"field2" : "value2"} }
### 9.索引别名alias aliases：

##### 检测这个别名指向哪个索引：
	GET /*/_alias/my_index
##### 检测哪些别名指向这个索引：
	GET /my_index_v1/_alias/*
>新索引中添加别名的同时从旧索引中删除它。这个操作需要原子化，所以我们需要用 _aliases ：

	POST /_aliases
	{
	    "actions": [
	        { "remove": { "index": "my_index_v1", "alias": "my_index" }},
	        { "add":    { "index": "my_index_v2", "alias": "my_index" }}
	    ]
	}
### 10.范围查询并排序：

	GET [indexName]/[type]/_search
	{
	     "query": {
	        "range": {
	            "date": {
	                "gte":  "2014-01-01",
	                "lt":   "2014-02-01"
	            }
	        }
	    },
	    "sort":  [
	        {
	          "createTime":"desc"
	        }
	      ]
	}
### 11.排序

	GET mcms_iflow/tbl_news_iflow/_search
	{
	    "_source": ["abstract_desc","title","channel_id"],
	  "query":{
	    "match_phrase": {
	      "abstract_desc":"可爱"
	    }
	  },
	  "sort": [
	    {
	      "channel_id": {//一级
	        "order": "asc",
	        "missing":"_last"//该字段缺省的文档排到最后
	      }
	    },
	        {
	      "add_time": {//二级
	        "order": "desc"
	      }
	    }
	  ]
	}
### 12.验证查询语句：

	GET [indexName]/[type]/_validate/query?explain
	{//能够查看es对查询语句的解释
	     "query": {
	         ...
	    }
	}
### 13.查询结果数量、分页：

> 如果无from、size设置，from默认为0，size默认为10，默认查询出前10个

	GET mcms_iflow/tbl_news_iflow/_search
	{
	  "query":{
	    "match_all": {}
	  },
	    "size":20//查前20条
	}
> 查询出从第10条开始，取20条

	GET mcms_iflow/tbl_news_iflow/_search
	{
	  "query":{
	    "match_all": {}
	  },
	    "from":10,
	    "size":20
	}
> 如果搜索size大于10000，需要设置index.max_result_window参数
> 注意：size的大小不能超过index.max_result_window这个参数的设置，默认为10,000。

	PUT _settings
	{
	    "index": {
	        "max_result_window": "10000000"
	    }
	}

### 14.搜索 实例：

> (标题含k或摘要含k)&&(范围[a,b])&&(品类为x&&文本类型为y)
> bool可以嵌套，match_phrase精确匹配，范围可lt lte gt gte，

	GET mcms_iflow/tbl_news_iflow/_search
	{
	  "query":{
	    "bool":{
	      "must":[{
	        "bool":{
	          "should":[{
	            "match":{
	              "title":{
	                "query":"樱子",
	                "type":"phrase"
	              }
	            }
	          },{
	            "match_phrase":{
	              "abstract_desc":"樱子"
	            }
	          }]
	        }
	      },{
	        "range":{
	          "add_time": {
	            "from": "1487927871500",
	            "to": "1492185599999",
	            "include_lower":true,
	            "include_upper":true
	          }
	        }
	      },{
	        "bool":{
	          "must":[{
	            "term":{
	              "variety_type": "1"
	            }
	          },{
	            "term":{
	              "articletype": "1"
	            }
	          }]
	        }
	      }  ]
	    }
	  }
	}
### 15.聚合-高级统计

	POST mcms_iflow/tbl_news_iflow/_search
	{
	  "size":0,
	  "aggs":{
	    "grades_stats":{
	      "extended_stats": {
	        "field": "add_time"
	      }
	    }
	  }
	}

### 16.短语匹配 match_phrase

	GET mcms_iflow/tbl_news_iflow/_search
	{
	  "_source": ["abstract_desc","title"],//只显示指定字段
	  "query":{
	    "match_phrase": {//短语匹配
	      "abstract_desc":"可爱"
	    }
	  }
	}
