<!-- server {
    listen 80;
    server_name tesst.com;

    root /home/ubuntu/docker_course/all_in_docker/client/build;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
        expires max;
        log_not_found off;
        access_log off;
    }

    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }
} -->




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




### remove the default  
sudo rm -f /etc/nginx/sites-enabled/default
sudo chmod +x /home
sudo chmod +x /home/ubuntu
sudo chmod +x /home/vagrant


sudo systemctl restart nginx.service 

<!--  -->

### systemd service unit


file=/etc/systemd/system/backend.service
cat > $file <<EOF

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

```
Reload the service files to include the new service.
sudo systemctl daemon-reload


Start your service
sudo systemctl start your-service.service

To check the status of your service
sudo systemctl status example.service

To enable your service on every reboot
sudo systemctl enable example.service

To disable your service on every reboot
sudo systemctl disable example.service
```
