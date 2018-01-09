# configure and download vm events script
sudo mkdir /opt/vmevents
cd vmevents
sudo curl -o getevents.sh  https://raw.githubusercontent.com/travisnielsen/vmevents/master/script/getevents.sh
sudo chmod +x /opt/vmevents/getevents.sh

# download systemd service and task definitions
sudo curl -o /usr/lib/systemd/system/ vmevents.service https://raw.githubusercontent.com/travisnielsen/vmevents/master/script/vmevents.service
sudo curl -o /usr/lib/systemd/system/ vmevents.timer https://raw.githubusercontent.com/travisnielsen/vmevents/master/script/vmevents.timer

# set up schecduled task
systemctl enable vmevents.timer
systemctl start vmevents.timer