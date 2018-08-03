# NTP 设置
## NTP Server
yum install chrony -y 
sed -i '10aallow 0.0.0.0/0' /etc/chrony.conf
systemctl enable chronyd && systemctl restart chronyd

## NTP Client
yum install chrony -y && sed -i '/^server/d' /etc/chrony.conf
sed -i '1aserver ntp.example.com iburst' /etc/chrony.conf
systemctl enable chronyd && systemctl restart chronyd

# DNS 设置
## DNS Server
yum install dnsmasq -y
mkdir /etc/dns_domain

cat <<EOF > /etc/dnsmasq.conf
resolv-file=/etc/dns_domain/resolv.conf
strict-order
listen-address=127.0.0.1,10.0.0.10,10.0.1.10
no-hosts
addn-hosts=/etc/dns_domain/hosts
EOF

cat <<EOF >/etc/dns_domain/hosts
10.0.0.10  ntp.example.com
10.0.1.10  ntp.example.com
10.0.0.10  yum.example.com
10.0.1.10  yum.example.com
EOF

cat <<EOF >/etc/dns_domain/resolv.conf
nameserver 223.5.5.5
nameserver 180.76.76.76
nameserver 119.29.29.29
EOF

## DNS Clinet
echo "nameserver 10.0.1.10" > /etc/resolv.conf
echo "nameserver 10.0.0.10" >> /etc/resolv.conf
chattr +i /etc/resolv.conf
