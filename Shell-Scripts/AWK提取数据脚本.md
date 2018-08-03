#!/bin/bash
    # jihongrui@jsqix.com
    
    # /data/www/fx_8080/logs  
    
    # 按年月新建目录
    data_dir="`date +%Y%m`"
    
    # 检测目录,如没有,则新建
    if [[ ! -d $data_dir ]];then mkdir $data_dir; fi
    
    # 定义输出文件名 当前日期 -1 day
    data_file="${data_dir}/data_www_fx_8080_log_by_`date -d "-1 day" +%F`"
    
    # 新建文件 OR 清空文件
    > $data_file
    
    # 定义数据来源文件
    sfile="/data/www/fx_8080/logs/catalina.`date -d "-1 day" +%F`"
    
    #files=(
    #`find /data/www/fx_8080/logs -type f -name "catalina?2017-??-??"`
    #)
    #
    #for file in ${files[@]} 
    #do
    #       egrep -o '\{returnCode=.*\}$' $file|tr '{}' ' ' | awk -F \, '{if ($11 ~/message.*/)t2=$12;else t2=$11;split(t2,tt,"=");split($4,t1,"=");split($13,t3,"=");split($18,t4,"=");split($19,t5,"=");split($20,t6,"=");print t1[2],tt[2],t3[2],t4[2],substr(t5[2],16,11),t6[2
    ]}' >> $data_file#done
    
    # GET DATE 输出至文件  
    egrep -o '\{returnCode=.*\}$' $sfile|tr '{}' ' ' | awk -F \, '{if ($11 ~/message.*/)t2=$12;else t2=$11;split(t2,tt,"=");split($4,t1,"=");split($13,t3,"=");split($18,t4,"=");split($19,t5,"=");split($20,t6,"=");print t1[2],tt[2],t3[2],t4[2],substr(t5[2],16,11),t6[2]}' >> 
    $data_file
    
    # 调用python 脚本发送
    #/usr/bin/python senddate.py $data_file
