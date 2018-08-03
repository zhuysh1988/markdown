OCP_USER='admin'
OCP_PASSWORD='onceas'
OCP_AUTH_FILE_B='/root/htpasswd'
OCP_AUTH_FILE='/etc/origin/master/htpasswd'
htpasswd -cb $OCP_AUTH_FILE_B $OCP_USER $OCP_PASSWORD ; 
 #用户名 密码
cp $OCP_AUTH_FILE_B ${OCP_AUTH_FILE_B}.bak.$(date "+%Y%m%d%H%M%S");  



ansible masters -m copy -a "src=${OCP_AUTH_FILE_B} dest=${OCP_AUTH_FILE}"


OCP_USER='admin'
oc adm policy add-cluster-role-to-user admin $OCP_USER     #对admin用户赋权
oc adm policy add-cluster-role-to-user cluster-admin $OCP_USER   #对admin用户赋权




