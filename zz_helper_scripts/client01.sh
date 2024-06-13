#!/usr/bin/env bash

sudo apt update -y

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash      

if [ -d "$HOME/.nvm" ]; then
			export NVM_DIR="$HOME/.nvm"
			[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
			[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"       
fi

nvm install 14

git clone https://github.com/pragash8/devops-class.git

env=/home/ubuntu/devops-class/all_in_docker/client/.env

cat > $env <<EOF
REACT_APP_API_URL = http://54.144.136.209:3001
EOF

cd /home/ubuntu/devops-class/all_in_docker/client/ || exit; npm install; npm run build ;
