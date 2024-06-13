#!/usr/bin/env bash

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
