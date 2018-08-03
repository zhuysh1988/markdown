JAVA_OPTS="-server -Xms1024m -Xmx2048m -Xss512k -XX:PermSize=512m -XX:MaxPermSize=512m -XX:+AggressiveOpts 
-XX:+UseBiasedLocking 
-XX:+DisableExplicitGC 
-XX:+UseConcMarkSweepGC 
-XX:+UseParNewGC  
-XX:+CMSParallelRemarkEnabled 
-XX:+UseCMSCompactAtFullCollection 
-XX:LargePageSizeInBytes=128m  
-XX:+UseFastAccessorMethods 
-XX:+UseCMSInitiatingOccupancyOnly 
-Dfile.encoding=UTF8 
-Djava.awt.headless=true"

-------------------------------------
org.apache.coyote.http11.Http11NioProtocol
protocol="org.apache.coyote.http11.Http11NioProtocol"
URIEncoding="UTF-8"  
minSpareThreads="200" 
maxSpareThreads="1000"
enableLookups="false" 
acceptCount="500"   
maxThreads="3000"
maxProcessors="1000" 
minProcessors="20"              

===========================================================================================================
java性能优化 /bin/catalina.sh
JAVA_OPTS="-server -Xms2048m -Xmx2048m -Xss1024k -XX:PermSize=512m 
-XX:MaxPermSize=512m -XX:+AggressiveOpts 
-XX:+UseBiasedLocking 
-XX:+DisableExplicitGC 
-XX:+UseConcMarkSweepGC 
-XX:+UseParNewGC  
-XX:+CMSParallelRemarkEnabled 
-XX:+UseCMSCompactAtFullCollection 
-XX:LargePageSizeInBytes=256m  
-XX:+UseFastAccessorMethods 
-XX:+UseCMSInitiatingOccupancyOnly 
-Djava.awt.headless=true"

-------------------------------------
tomcat性能优化 /conf/server.xml
protocol="org.apache.coyote.http11.Http11NioProtocol"                  //支持超长协议
URIEncoding="UTF-8"  												//字符集设置
minSpareThreads="200" 					//线程池设置，启动200线程
maxSpareThreads="1000"					//最大线程1000
enableLookups="false" 					//禁用dns反向查询
acceptCount="500"   					//超出线程池最大的线程数的队列500
maxThreads="3000"						//最大连接数3000
maxProcessors="1000" 					//最大连接并发1000
minProcessors="20"                       //最小连接并发20   