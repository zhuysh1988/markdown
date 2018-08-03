#!/usr/bin/env python
# -*- coding:utf-8 -*-

__author__ = "jihongrui@hotmail.com"
'''

nginx config

log_format json
                 '"host":"$server_addr",'
                 '"clientip":"$remote_addr",'
                 '"http_host":"$host",'
                 '"url":"$uri",'
                 '"agent":"$http_user_agent",'
                 '"xff":"$http_x_forwarded_for",'
                 '"status":"$status",';

access_log syslog:server=192.168.1.6:20514,facility=local7,tag=nginx,severity=info json;
'''

import time
import socket, traceback


if __name__ == '__main__':
    'test port'
    host = ''
    port = 20514
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind((host, port))
    Lists = list()

    while True:
        message, address = s.recvfrom(8192)
        print message
