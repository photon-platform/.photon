# install apache
sudo apt update
sudo apt install apache2
sudo systemctl status apache2

# apache www folders
sudo usermod -a -G www-data phi
