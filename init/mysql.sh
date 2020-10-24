#!/usr/bin/env bash

sudo apt install -y mysql-server
sudo mysql_secure_installation
sudo systemctl enable --now mysql.service
systemctl status mysql.service
echo run 'sudo mysql'
echo then
echo ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'insert_password';

