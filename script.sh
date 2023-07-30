#!/bin/sh
#Update Server:
sudo apt update && apt upgrade -y
#Install package Dependencies:
sudo apt install wget apt-transport-https gnupg2 libimlib2 libimlib2-dev
#use correct locales:
sudo apt install locales
sudo locale-gen en_US.UTF-8
echo "LANG=en_US.UTF-8" > /etc/default/locale
#installing Database
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
sudo apt install pgloader
sudo zammad run rake zammad:db:pgloader > /tmp/pgloader-command
#installing Apache
sudo a2enmod headers

#Setup Elastic search
sudo apt install apt-transport-https sudo wget curl gnupg
sudo echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main"| \
  tee -a /etc/apt/sources.list.d/elastic-7.x.list > /dev/null
sudo curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | \
  gpg --dearmor | tee /etc/apt/trusted.gpg.d/elasticsearch.gpg> /dev/null
sudo apt update
sudo apt install elasticsearch
 /usr/share/elasticsearch/bin/elasticsearch-plugin install ingest-attachment
sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch

#Zammad
echo "deb https://dl.packager.io/srv/deb/zammad/zammad/stable/ubuntu 22.04 main"| \
   tee /etc/apt/sources.list.d/zammad.list > /dev/null
sudo apt update
sudo apt install zammad
sudo systemctl start zammad
sudo systemctl enable zammad

