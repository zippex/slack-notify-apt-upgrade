#!/bin/bash

# #############
# CONFIGURATION

# your slack webhook url
webhook_url="https://hooks.slack.com/services/ABC/123/EXAMPLE"

# the slack channel to which the notification should be sent to
channel="channelname"

# use your servers hostname for the username
# or set a custom username
# username="yourcustomname"
username=$(hostname)

# CONFIGURATION
###############

if [ $(whoami) != "root" ]
then
        text="Could not check server status. Need to run as root."
else
        apt-get update

        check=$(apt-get upgrade --simulate)

        if [[ $check == *"0 upgraded"* ]]
        then
                echo "Nothing to do for today."
                exit
        fi

        text="Please upgrade your server! \n$check"
fi

escapedText=$(echo $text | sed 's/"/\"/g' | sed "s/'/\'/g" )

json="{\"channel\": \"$channel\", \"username\":\"$username\", \"attachments\":[{\"color\":\"danger\" , \"text\": \"$escapedText\"}]}"

curl -s -d "payload=$json" "$webhook_url"