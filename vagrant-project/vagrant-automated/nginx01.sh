#!/usr/bin/env bash
sudo apt install nginx -y


sudo bash -c 'cat >/etc/nginx/sites-enabled/nginxconf' << EOF

server {
	listen 80;
	server_name localhost;

	root /home/ubuntu/devops-class/all_in_docker/client/build;
	index index.html;

	access_log /var/log/nginx/localhost_access.log;
	error_log /var/log/nginx/localhost_error.log;

	location / {
	try_files $uri $uri/ =404;
	}
}

EOF

sudo rm -f /etc/nginx/sites-enabled/default
sudo chmod +x /home
sudo chmod +x /home/vagrant
sudo systemctl restart nginx.service