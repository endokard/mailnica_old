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
echo "configuring SSH, default config file will be saved in /etc/ssh/sshd_config.back"
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


#echo " "
#echo "Do you wish to configure firewall (y/n)? We recommend to restrict SSH access to this machine. Default - yes."
#read yn_fw
#   if [[ $yn_fw == "n" ]] || [[ $yn_fw == "" ]];
#     then
#      echo ""
#      echo "Plase specify your network or IP adress e.g. 165.154.123.0/24."
#      read networka
#      echo "adding rules"

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

