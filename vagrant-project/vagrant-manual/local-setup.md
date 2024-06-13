## mysql01

```
sudo apt update && sudo apt upgrade
sudo apt install mysql-server

```

```
sudo mysql -u root

```

```
mysql> CREATE DATABASE IF NOT EXISTS employeeSystem;
mysql> USE employeeSystem;
mysql> CREATE TABLE IF NOT EXISTS employees(
         id INT AUTO_INCREMENT PRIMARY KEY,
         name VARCHAR(50) NOT NULL,
         age INT unsigned,
         country VARCHAR(50),
         position VARCHAR(50),
         wage FLOAT NOT NULL
    );

mysql> CREATE USER 'test'@'localhost' IDENTIFIED BY 'password';
mysql> GRANT ALL PRIVILEGES ON employeeSystem.* TO 'test'@'localhost';

-- Create the user and grant privileges for any IP
mysql> CREATE USER 'test'@'%' IDENTIFIED BY 'password';
mysql> GRANT ALL PRIVILEGES ON employeeSystem.* TO 'test'@'%';

FLUSH PRIVILEGES;

<!-- altering the users -->
<!-- to allow access from any ip ( don't do this in production ) -->
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
```
bind-address           = 0.0.0.0

```

ALTER USER 'test'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY 'password';
ALTER USER 'test'@'%' IDENTIFIED WITH 'mysql_native_password' BY 'password';

FLUSH PRIVILEGES;


```

## client01

```
sudo apt update
<!-- install nvm -->
`curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash`
source ~/.bashrc
nvm install 14
<!--  -->
<!-- clone the project repo -->
git clone https://github.com/pragash8/devops-class.git
cd ~/devops-class/all_in_docker/client/
npm i
npm run start

```

<!--  -->

## server01

<!--  -->

```


sudo apt update && sudo apt upgrade
git clone https://github.com/pragash8/devops-class.git
cd ~/devops-class/all_in_docker/server/
npm i
<!--  -->
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
<!--  -->
source ~/.bashrc

nvm install 14
npm i
node index.js


```
