#!/bin/sh
#Update Server:
sudo apt update && apt upgrade -y
#Install package Dependencies:
sudo apt install wget apt-transport-https gnupg2 libimlib2 libimlib2-dev -y
#use correct locales:
sudo apt install locales
sudo locale-gen en_US.UTF-8
echo "LANG=en_US.UTF-8" |sudo tee /etc/default/locale
#Add users
sudo useradd zammad -m -d /opt/zammad -s /bin/bash
sudo groupadd zammad
#Get the source
cd /opt
sudo wget https://ftp.zammad.com/zammad-latest.tar.gz
sudo opt$ sudo tar -xzf zammad-latest.tar.gz --strip-components 1 -C zammad
sudo chown -R zammad:zammad zammad/
sudo rm -f zammad-latest.tar.gz
#Install Dependencies
sudo apt update
sudo apt install postgresql postgresql-contrib -y
sudo systemctl start postgresql
sudo systemctl enable postgresql
#Install Node.js
sudo apt update
sudo apt install curl
sudo curl -fsSL https://deb.nodesource.com/setup_lts.x |sudo bash -
sudo apt install nodejs
sudo apt install curl git patch build-essential bison zlib1g-dev libssl-dev libxml2-dev libxml2-dev autotools-dev\
  libxslt1-dev libyaml-0-2 autoconf automake libreadline-dev libyaml-dev libtool libgmp-dev libgdbm-dev libncurses5-dev\
  pkg-config libffi-dev libimlib2-dev gawk libsqlite3-dev sqlite3 software-properties-common -y
sudo apt-add-repository -y ppa:rael-gc/rvm
sudo apt update
sudo apt install rvm
#Set Relevent Environment variables
echo "export RAILS_ENV=production" |sudo tee -a /opt/zammad/.bashrc
echo "export RAILS_SERVE_STATIC_FILES=true" |sudo tee -a  /opt/zammad/.bashrc
echo "rvm --default use 3.1.3" |sudo tee -a /opt/zammad/.bashrc
echo "source /usr/share/rvm/scripts/rvm" |sudo tee -a /opt/zammad/.bashrc
#Install Ruby Environment
#Postgresql depency
sudo apt install libpq-dev
# Add zammad user to RVM group
sudo usermod -a -G rvm zammad
# Install Ruby 3.1.3
sudo su - zammad
rvm install "ruby-3.1.3"
# Install bundler, rake and rails
rvm use 3.1.3
gem install bundler rake rails
#Install Gems for Zammad
bundle config set without "test development mysql"
bundle install
#Configure database settings
cp config/database/database.yml config/database.yml
sudo sed -i -e "s/^password=.*$/password=Zammad_password@1!2" -e "s/^POSTGRES_HOST=.*$/POSTGRES_HOST=zammadpostgresql.postgres.database.azure.com/" -e "s/^usernameR=.*$/username=zaamaduser@zammadpostgresql/" config/database.yml
chmod 600 /opt/zammad/config/database.yml
chown zammad:zammad /opt/zammad/config/database.yml
#Initialize your database
su - zammad
rake db:create
rake db:migrate
rake db:seed
rails r "Locale.sync"
rails r "Translation.sync"
rake assets:precompile
sudo -i 
./install-zammad-systemd-services.sh
cd /opt/zammad/script/systemd
sudo systemctl start zammad

