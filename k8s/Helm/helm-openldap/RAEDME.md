
```yaml
      - hostPath:
          path: {{ .Values.path.ldap.ldap_config }}
        name: ldap-config
      - hostPath:
          path: {{ .Values.path.ldap.ldap_certs }}  # 这个变量中不能使用'-'
        name: ldap-certs  # k8s 这种变量中不能使用 '_' , 

```

 
 
helm package openldap
helm repo index `pwd`
helm searhc openldap

kubectl lable node node_name ldap=enabled phpldapadmin=enabled 


helm install --name bocloud-ldap --set "namespace=ldap" local/openldap --version 1.1.0 --dry-run --debug
helm install --name bocloud-ldap --set "namespace=ldap" local/openldap --version 1.1.0 


helm delete --purge bocloud-ldap