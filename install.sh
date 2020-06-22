#!/bin/bash
clear
echo "                                                                   "
echo " _|      _|            _|  _|  _|      _|  _|                      "
echo " _|_|  _|_|    _|_|_|      _|  _|_|    _|        _|_|_|    _|_|_|  "
echo " _|  _|  _|  _|    _|  _|  _|  _|  _|  _|  _|  _|        _|    _|  "
echo " _|      _|  _|    _|  _|  _|  _|    _|_|  _|  _|        _|    _|  "
echo " _|      _|    _|_|_|  _|  _|  _|      _|  _|    _|_|_|    _|_|_|  "
echo "                                                                   "
echo " "
echo " "
echo "Welcom to MailNica installer"
echo " "

echo "Do you have non root user (y/n)? If no let's create it. Default - no."
read yn_u
   if [[ $yn_u == "n" ]] || [[ $yn_u == "" ]];
     then
      echo "OK, let's create new user. Please enter user name:"
      read usern
      useradd $usern
      echo "Let's set up $usern password"
      passwd $usern
      echo " "
   fi

echo " "
echo "Let's configure SSH service"
echo "We recomend to change SSH default port"
echo "Enter new SSH port, or left blank for default (22)"
read ssh_port
echo "Disble root login (y/n). Default - yes."
read disable_rl
echo "Disable forwarding (y/n)? Default - yes."
read disable_pf
echo "Configuring SSH, default config file will be saved in /etc/ssh/sshd_config.back"
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.back

   if [[ $ssh_port != 22 ]];
      then
         sed -i "s/#Port 22/Port $ssh_port/g" /etc/ssh/sshd_config
      fi

   if [[ $disable_rl != "n" ]];
      then
         sed -i "s/PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
      fi

   if [[ $disable_pf != "n" ]];
      then
         sed -i "s/#AllowAgentForwarding yes/AllowAgentForwarding no/g" /etc/ssh/sshd_config
         sed -i "s/#AllowTcpForwarding yes/AllowTcpForwarding no/g" /etc/ssh/sshd_config
      fi


echo " "
echo "Do you wish to configure firewall (y/n)? Default - yes."
read yn_fw
   if [[ $yn_fw == "y" ]] || [[ $yn_fw == "" ]];
     then
      echo ""
      echo "Let's allow ssh access only from trusted network. Plase specify your network or IP adress e.g. 165.154.123.0/24."
      read networka
      echo "starting fw"
      systemctl start firewalld
      echo "adding SSH rules"
      firewall-cmd --zone=public --add-rich-rule='rule family="ipv4" source address="'$networka'" port protocol="tcp" port="2222" accept'
      echo " "
      echo "Now we will add some rules to enable mail service"
      firewall-cmd --zone=public --add-service=https
      firewall-cmd --zone=public --add-service=http
      firewall-cmd --zone=public --add-service=smtp
      firewall-cmd --zone=public --add-service=smtps
      firewall-cmd --zone=public --add-service=pop3
      firewall-cmd --zone=public --add-service=pop3s
      firewall-cmd --zone=public --add-service=imap
      firewall-cmd --zone=public --add-service=imaps
      firewall-cmd --zone=public --add-service=smtp-submission
   fi

echo " "
echo "Let's install some software. We will add Remi and EPEL repos for PHP 7.4 and install it with some modules."
echo "Is it OK (y/n)? Default - yes."
read yn_php 

   if [[ $yn_php == "y" ]] || [[ $yn_php == "" ]];
     then
      dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
      dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
      dnf module enable php:remi-7.4 -y
      dnf install php php-fpm php-common php-curl php-mbstring php-xmlrpc php-mysqlnd php-gd php-xml php-intl php-json php-cli php-pear php-mcrypt php-ldap php-zip php-fileinfo php-opcache php-odbc php-pdo php-pecl-apc php-pecl-memcache php-pgsql php-soap php-imap php-pspell php-imagick dovecot-pigeonhole -y
   fi

echo " "
echo "Let's install MariaDB server"
echo " "
dnf install mariadb-server -y
systemctl start mariadb
echo " "
echo "Now let's secure MariDB installation"
echo "Please set MariaDB root password and store it."
echo "Remove anonymous user, disallow root login remotely, remove test database and flush pivileges (Y,Y,Y,Y)"
mysql_secure_installation

#(re)start and enablle servies
#
#systemctl restart sshd
#firewall-cmd --runtime-to-permanent
#systemctl enable firewalld
#systemctl enable mariadb



#
#(re)start and enablle servies
#
#systemctl restart sshd

#installation summary
echo "Installation finished successfully"
echo "We recomend you to work as user $usern and if you need to perform some root actions - use su command, e.g. su ls"
echo " "
echo "You can access this serwer from network $networka , you can add more networks using command:"
echo "firewall-cmd --zone=public --add-rich-rule="
echo "'rule family="ipv4""
echo "source address="87.226.0.0/17" port protocol="tcp" port="2222" accept'"

