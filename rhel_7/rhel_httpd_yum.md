# rhel 使用httpd 配置yum

## 配置 cdrom local.repo
mkdir /media/cdrom
mount /dev/cdrom /media/cdrom

cat <<EOF >/etc/yum.repos.d/local.repo
[local]
name=rhel
baseurl=file:///media/cdrom
gpgcheck=1
enabled=1
gpgkey=file:///media/cdrom/RPM-GPG-KEY-redhat-release
EOF

## 安装httpd
yum install httpd -y && \
systemctl enable httpd
- ### 配置Httpd

cat << EOF > /etc/httpd/conf.d/yum.conf
Alias /repo "/var/www/repo"
<Directory "/var/www/repo">
  Options +Indexes +FollowSymLinks
Require all granted
</Directory>
<Location /repo>
SetHandler None
</Location>
EOF

systemctl restart httpd

- ### 配置 http yum.example.com.repo供其它服务器使用
cat <<EOF >/etc/yum.repos.d/yum.example.com.repo
[rhel7]
name=rhel7
baseurl=http://10.0.1.10/repo
gpgcheck=1
enabled=1
EOF

yum clean all && yum makecache
