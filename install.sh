#!/bin/bash

backup_scripts () {
	cp -a /Scripts/. /backup_Scripts/
	rm -r /Scripts
	mkdir /Scripts
}

install_programs () {
	echo "[!] Trying to install kerbrute"
	{
		curl https://github.com/ropnop/kerbrute/releases/download/v1.0.3/kerbrute_linux_amd64 > /Scripts/kerbrute &&
		{
			chmod +x /Scripts/kerbrute &&
			echo "[+] kerbrute installed successfully"
		} || {
			echo "[-] Couldn't chmod kerbrute (are you root?)"
		}
	} || {
		echo "[-] Couldn't download kerbrute"
	}
	echo "[!] Trying to install impacket"
	{
		git clone https://github.com/SecureAuthCorp/impacket.git /opt/impacket &&
		{
			pip3 install -r /opt/impacket/requirements.txt &&
			{
				python3 /opt/impacket/setup.py install &&
				echo "[+] Installed impacket successfully"
			} || {
				echo "[-] Couldn't install impacket"
			}
		} || {
			echo "[-] Couldn't download impacket or install dependencies"
			echo "[.] Is it already installed?"
		}
	} || {
		echo "This apparently never gets called"
	}
	
	echo "[!] Adding Scripts to PATH variable"
	{
		echo "export PATH=\$PATH:/Scripts/">>~/.bashrc &&
		echo "[+] Added Scripts to PATH successfully"
		echo "[.] You may need to add it to your own user"
		echo "[.] As it is now added to roots PATH"
		echo "[.] You can add it on your own by"
		echo "[.] Pasting 'export PATH=\$PATH:/Scripts/' into ~/.bashrc"
	} || {
		echo "[-] Couldn't add Scripts to PATH"
		echo "[.] You can do it yourself"
		echo "[.] Paste 'export PATH=\$PATH:~/Scripts/' into ~/.bashrc"
	}
}

echo "Kali Setup Program by XeventoHD"
echo ""
echo "[!] Creating Scripts folder"
if [ ! -d ~/Scripts ]
	then
		{
			mkdir ~/Scripts &&
			echo "[+] Successfully created Scripts folder"
		} || {
			echo "[-] Failed to create Scripts folder"
			exit
		}
		install_programs
	else
		echo "[!] Scripts folder already exists"
		echo "[!] To install properly the program needs an empty Scripts folder."
		while true; do
  			read -r -p "[?] Backup original Scripts folder? [y/n]" yn
  				case "$yn" in
    					[Yy][Ee][Ss]|[Yy])
      						backup_scripts; install_programs; break;;
    					[Nn][Oo]|[Nn])
      						exit;;
    					*)
      						;;
  			esac
		done
fi
