#!/usr/bin/env bash
sudo apt install nginx -y
sudo bash -c 'cat > /etc/nginx/sites-enabled/client' << EOF
server {

		listen 80;
		listen [::]:80;
		server_name localhost;

		root /home/ubuntu/devops-class/all_in_docker/client/build;
		index index.html index.htm index.nginx-debian.html;

		location / {
		try_files $uri $uri/ =404;
		}
}
EOF


sudo rm -f /etc/nginx/sites-enabled/default
sudo chmod -R 755 /home/ubuntu/devops-class/
sudo chmod +x /home
sudo chmod +x /home/ubuntu
sudo systemctl restart nginx.service