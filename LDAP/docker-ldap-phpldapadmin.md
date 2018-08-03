# ldap start
```bash
docker run \
--net host \
--name bocloud-ldap \
--env LDAP_ORGANISATION="bocloud" \
--env LDAP_DOMAIN="bocloud.com.cn" \
--env LDAP_ADMIN_PASSWORD="Beyond#11" \
--detach osixia/openldap:1.2.1
```

# phpldap-admin start
```bash
docker run   \
--net host   \
--name phpldapadmin-service   \
--env PHPLDAPADMIN_LDAP_HOSTS=localhost   \
--detach osixia/phpldapadmin:0.7.1
```

# web access 
``` txt 
user: cn=admin,dc=bocloud,dc=com,dc=cn
passsword: Beyond#11
```

