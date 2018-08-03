
mysql registry:

alitag='registry.cn-hangzhou.aliyuncs.com/jihongrui/mysql:'

docker tag mysql:v5.6 ${alitag}v5.6
docker push ${alitag}v5.6
docker pull ${alitag}v5.6 


docker tag mysql:v5.7 ${alitag}v5.7
docker push ${alitag}v5.7
docker pull ${alitag}v5.7 

tomcat 


password: -pl,0okm