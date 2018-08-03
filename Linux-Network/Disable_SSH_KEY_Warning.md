ssh-copy-id -o StrictHostKeyChecking=false 

yes |./vmware-install.pl --default 

 sed -i '$aStrictHostKeyChecking false' /etc/ssh/ssh_conf && \
 systemctl restart sshd