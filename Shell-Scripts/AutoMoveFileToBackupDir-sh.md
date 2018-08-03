＃查找文件OR日志，并移至另一目录，而且产生日志
    

    #!/bin/bash
    # jihongrui@jsqix.com
    
    # 由于/opt/tomcat7/logs 在 / 目录 ,空间不大,所以把打包的文件移至 /data/opt_tomcat7_logs_dir_bak
    mv_dir='/data/opt_tomcat7_logs_dir_bak'
    
    s_dir='/opt/tomcat7/logs'
    
    logfile=${0}.log
    
    echo "`date +%F_%R` start " >> $logfile
    
    find ${s_dir} -type f -mtime +150 -print0 |xargs -0 -l1 -t mv -t ${mv_dir} &>> $logfile
    
    echo "`date +%F_%R` end " >> $logfile
    
