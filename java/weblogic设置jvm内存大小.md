## Version Weblogic 10:30
### vim domain/base_domain/bin/setDomain.sh

    sed -i 's#^MEM_ARGS=\".*#MEM_ARGS=\"-Xms1024m\ -Xmx2048m\ -XX:MaxPermSize=2048m\"#g'  



## Version Weblogic 10.3.6 
    cd /weblogic/Oracle/Middleware/user_projects/domains/base_domain/bin
    vim startWeblogic.sh
    
    125                 CLASSPATH="${MEDREC_WEBLOGIC_CLASSPATH}"
    126         fi
    127 fi
    128 
    129 MEM_ARGS="-Xms1024m -Xmx2048m -XX:MaxPermSize=2048m"
    130 export MEM_ARGS
    131 
    132 echo "."
    133 
    134 echo "."
    135 
    136 echo "JAVA Memory arguments: ${MEM_ARGS}"
