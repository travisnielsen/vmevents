# configure and download vm events script
mkdir /opt/vmevents
curl -o /opt/vmevents/getevents.sh  https://raw.githubusercontent.com/travisnielsen/vmevents/master/script/getevents.sh
chmod +x /opt/vmevents/getevents.sh

# download systemd service and task definitions
curl -o /usr/lib/systemd/system/vmevents.service https://raw.githubusercontent.com/travisnielsen/vmevents/master/script/vmevents.service
curl -o /usr/lib/systemd/system/vmevents.timer https://raw.githubusercontent.com/travisnielsen/vmevents/master/script/vmevents.timer

# set up schecduled task
systemctl enable vmevents.timer
systemctl start vmevents.timer

# check status
systemctl is-active vmevents.timer