# slack-notify-apt-upgrade
Bash script to notify available apt upgrades via slack.

## How it works
The bash script simply retrieve new lists of packages via `apt-get update` and then calls `apt-get upgrade --simulate` to check for available upgrades.

If the result of the simulation looks like
```
Reading package lists... Done
Building dependency tree
Reading state information... Done
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
```
we are done. If there would be more than "0 upgraded" packages, we'll send the Slack notification.

**Note:** You need to be `root` on your server because `apt-get update` must run as root.

## Installation
1. Save `slack-notify-apt-upgrade.sh` to your server, for example within `/root/scripts/`
2. `chmod u+x slack-notify-apt-upgrade.sh`
3. Create an incoming webhook for Slack (see https://api.slack.com/incoming-webhooks)
4. Open the script with your editor and update the configuration section:
    - your Slack webhook url
    - the slack channel to which the notification should be sent to
    - (optional) a username
5. As `root` user edit your cronjobs with `crontab -e` and add a line like this to call the script twice a day:

   `0 6,20 * * * /root/scripts/slack-notify-apt-upgrade.sh > /dev/null 2>&1`
   
That's it.

## Imaginable Extensions
- Modify the `color` attribute of the Slack message due to the existence of security related upgrades (at the moment it's always "danger").
- Cache the result of the simulation in a file to avoid resending the identical message over and over.
- ...