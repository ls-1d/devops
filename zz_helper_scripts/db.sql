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
CREATE USER 'test'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON employeeSystem.* TO 'test'@'localhost';

-- Create the user and grant privileges for any IP
CREATE USER 'test'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON employeeSystem.* TO 'test'@'%';
FLUSH PRIVILEGES;

-- altering the users
-- to allow access from any ip ( don't do this in production ) 
ALTER USER 'test'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY 'password';
ALTER USER 'test'@'%' IDENTIFIED WITH 'mysql_native_password' BY 'password';
FLUSH PRIVILEGES;