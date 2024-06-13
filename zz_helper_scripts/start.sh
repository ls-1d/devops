#!/usr/bin/env bash
paddr=http://54.208.128.228:3001

sudo apt update -y

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash      

if [ -d "$HOME/.nvm" ]; then
			export NVM_DIR="$HOME/.nvm"
			[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
			[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"       
fi

nvm install 14

git clone https://github.com/pragash8/devops-class.git

cat > /home/ubuntu/devops-class/all_in_docker/client/.env <<EOF
REACT_APP_API_URL = $paddr
EOF

cd /home/ubuntu/devops-class/all_in_docker/client/ || exit; npm install; npm run build ;

# mysql
sudo apt update -y
sudo apt install mysql-server -y
sleep 1

sudo sed -i -e '0,/127.0.0.1/ s/127.0.0.1/0.0.0.0/1 p' /etc/mysql/mysql.conf.d/mysqld.cnf
sleep 1

sudo mysql -u root <<EOF
-- creating database named employeeSystem
CREATE DATABASE IF NOT EXISTS employeeSystem;
USE employeeSystem;
CREATE TABLE IF NOT EXISTS employees
(
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	age INT unsigned,
	country VARCHAR(50),
	position VARCHAR(50),
	wage FLOAT NOT NULL
);

-- creating user for the localhost
CREATE USER 'test'@'localhost' IDENTIFIED BY 'mauFJcuf5dhRMQrjj';
GRANT ALL PRIVILEGES ON employeeSystem.* TO 'test'@'localhost';

-- Create the user and grant privileges for any IP
CREATE USER 'test'@'%' IDENTIFIED BY 'mauFJcuf5dhRMQrjj';
GRANT ALL PRIVILEGES ON employeeSystem.* TO 'test'@'%';
FLUSH PRIVILEGES;

-- altering the users
-- to allow access from any ip ( don't do this in production ) 
ALTER USER 'test'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY 'mauFJcuf5dhRMQrjj';
ALTER USER 'test'@'%' IDENTIFIED WITH 'mysql_native_password' BY 'mauFJcuf5dhRMQrjj';
FLUSH PRIVILEGES;
EOF

sleep 1

sudo systemctl restart mysql

# backend

index=/home/ubuntu/devops-class/all_in_docker/server/index.js
sed -i 's/07b5658e6257/localhost/' $index
sed -i 's/root/test/' $index

cd /home/ubuntu/devops-class/all_in_docker/server/ || exit; npm install;


sudo bash -c 'cat > /etc/systemd/system/backend.service' << EOF
[Unit]
Description=Your Node.js Backend
After=network.target

[Service]
Environment=NODE_ENV=production
ExecStart=/home/ubuntu/.nvm/versions/node/v14.21.3/bin/node index.js
WorkingDirectory=/home/ubuntu/devops-class/all_in_docker/server
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

# nginx

sudo apt install nginx -y

sudo bash -c 'cp /home/ubuntu/client.conf /etc/nginx/conf.d/'
sudo bash -c 'cp /home/ubuntu/backend.conf /etc/nginx/conf.d/'

sudo rm -f /etc/nginx/sites-enabled/default
sudo chmod +x /home
sudo chmod +x /home/ubuntu
sudo systemctl restart nginx.service