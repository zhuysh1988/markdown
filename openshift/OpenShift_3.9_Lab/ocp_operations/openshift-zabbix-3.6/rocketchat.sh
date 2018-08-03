#!/bin/bash

# Rocket.Chat Alerting
# Author: Wolfgang Kulhanek
#         WolfgangKulhanek@gmail.com
# Forked and enhanced from https://github.com/Open-Future-Belgium/zabbix-Rocket.Chat

# Rocket.Chat incoming web-hook URL and user name
#url='http://rocketchat-rocketchat.apps.mon.example.opentlc.com/hooks/GEomjxsuxCMwszhKx/c4uakRKZXS7iC78fCiZsxjfwvLG7cnRv7i3ecjk6ei82p2Ku'
LOGFILE="/var/log/zabbix/zabbix-rocketchat.log"

## Values received by this script:
# webhook = $1 The WebHook URL for the Rocket.Chat Channel
# Subject = $2 usually either OK or PROBLEM
# Message = $3 whatever message the Zabbix action sends,
#              preferably something like "Zabbix server is
#              unreachable for 5 minutes - Zabbix
#              server (127.0.0.1)"
webhook=$1
subject=$2
message=$3

echo "****** New Alert received ******" >>${LOGFILE}
echo "Sending Rocket.Chat Alert: Subject=${subject}; Message=${message}" >>${LOGFILE}
echo "  WebHook: ${webhook}" >>${LOGFILE}

# Set default values for emoji and color
icon_emoji=":interrobang:"   # Exclamatin/Question Mark
color="#555555"              # Gray

# Change color emoji depending on the subject
# Green (RECOVERY), Red (PROBLEM)
if [[ "$subject" == *"OK"* ]]; then
  color="#00ff33" # green
  icon_emoji=":grinning:"
elif [[ "$subject" == *"PROBLEM"* ]]; then
  color="#ff2a00" # red
  icon_emoji=":slight_frown:"
fi

# Build our JSON payload and send it as a POST request to
# the Rocket.Chat incoming web-hook URL
# Could add additional fields (inside "attachments"):
#   "title_link": "https://rocket.chat"
#   "image_url": "https://rocket.chat/images/mockup.png"
payload="{\"text\": \"Zabbix Alert\", \"emoji\": \"${icon_emoji}\", \"attachments\": [{\"title\": \"${subject}\", \"text\": \"${message}\", \"color\": \"${color}\" }]}"

# Log alert
echo "Sending Request to Rocket.Chat:" >>${LOGFILE}
echo "  curl -X POST -H 'Content-Type: application/json' --data \"${payload}\" $webhook" >>${LOGFILE}

# Send Payload to the Rocket.Chat Server
curl -X POST -H 'Content-Type: application/json' --data "${payload}" $webhook 2>&1 >>${LOGFILE}

echo "\n****** Alert sent ******" >>${LOGFILE}
