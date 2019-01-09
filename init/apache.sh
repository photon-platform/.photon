# install apache
sudo apt -y update
sudo apt install -y apache2
sudo systemctl status apache2

# apache www folders
sudo usermod -a -G www-data phi
