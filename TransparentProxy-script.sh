#!/bin/bash
echo "Executing the script..."
echo -e "Copying redsocks executable to /usr/local/sbin/"
chmod +x redsocks
sudo cp ./redsocks /usr/local/sbin/redsocks
echo -e "Installing of redsocks completed"
echo -e "\nConfiguring redsocks.conf file..Please enter your credentials when prompted\n"
read -p "Enter LDAP username:" user
stty -echo
read -p "Enter LDAP Password:" pass
stty echo
redsocks_conf_set(){
	
	sed -i "s|USERNAME|$user|g" redsocks.conf          #Doesn't work if ur username or password has "\" as character :(
	sed -i "s|PASSWORD|$pass|g" redsocks.conf
	sudo cp redsocks.conf /etc/redsocks.conf
}

redsocks_conf_set

sudo cp redsocks.default /etc/default/redsocks
sudo cp redsocks.init /etc/init.d/redsocks
###########setting iptables rules
chmod +x ./redirect.rules
sudo iptables-restore ./redirect.rules
########## end setting iptables rules

echo -e "Installing iptables-persistent.."
echo -e "\nPress yes whenever asked from here\n"
sudo apt-get install iptables-persistent
echo -e "\nStarting redsocks redirector\n"
sudo service redsocks start
echo -e "\nFinished...\n "

