# To install Flussonic, run this command in the Linux console (command line):

curl -sSf https://raw.githubusercontent.com/tobi2021lol/Flussonic/master/install.sh | sh

# Then start Flussonic Media Server:

/etc/init.d/flussonic start


# Installing Flussonic using Debian installation package (for Ubuntu 12.04 64bit and higher or Debian Wheezy 64 bit)

# Now you are ready to start Flussonic

/etc/init.d/flussonic start

#Open in browser

web interface on the page http://ip:8080
 
 The default login and password are: 

login: flussonic

password: letmein!


# Cracked flussonic license key
l4|8Ku8ypPgOUySHysCdkFHW0|r6BzpmVPpjgKpn9IunpFp6lLbCZOp3

l4|aO4RO2ZdLEzHAdH46n6iD0|r6BzpmVPpjgKpn9IunpFp6lLbCZOp3

# Updating Flussonic
To install updates, simply update the packages and install Flussonic:

apt-get update
apt-get -y install flussonic
/etc/init.d/flussonic restart


# Updating License
vim /etc/flussonic/license.txt

After successful installation of flussonic, you need to get the trial license or purchase if you wish to use it for long in production by signing up or requesting for a trial license using this LINK.

Then open the license key file using any of your command line editors and add the license key in it and close the file after saving the license key in it as shown below.

# Starting Services

To start flussonic services on Ubuntu or Linux you can use the same command.

/etc/init.d/flussonic restart

To check the status of flussonic service if its working fine or not, run the below command.

/etc/init.d/flussonic status 

You can use the below commands to stop or restart the flusonic services with the help of following commands.

/etc/init.d/flussonic stop
/etc/init.d/flussonic restart

To reconfigure with client connections live to use the below command to reload its services.

/etc/init.d/flussonic reload
 


Flussonic Version

 

You can check the currently installed version of Flussonic on Linux by using the below commands.

On CentOS

rpm -qa | grep flussonic
