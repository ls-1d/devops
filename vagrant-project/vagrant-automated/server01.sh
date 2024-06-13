#!/usr/bin/env bash

sudo apt update

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash      

if [ -d "$HOME/.nvm" ]; then
            export NVM_DIR="$HOME/.nvm"
            [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
            [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"       
fi

nvm install 14

git clone https://github.com/pragash8/devops-class.git

file=/home/vagrant/devops-class/all_in_docker/server/index.js
sed -i 's/07b5658e6257/mysql01/' $file
sed -i 's/root/test/' $file

cd /home/vagrant/devops-class/all_in_docker/server/ || exit; npm install;


sudo bash -c 'cat > /etc/systemd/system/backend.service' << EOF
[Unit]
Description=Your Node.js Backend
After=network.target

[Service]
Environment=NODE_ENV=production
ExecStart=/home/vagrant/.nvm/versions/node/v14.21.3/bin/node index.js
WorkingDirectory=/home/vagrant/devops-class/all_in_docker/server
Restart=always
RestartSec=10
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=client

[Install]
WantedBy=multi-user.target
EOF



sudo systemctl daemon-reload
sudo systemctl enable backend.service --now
