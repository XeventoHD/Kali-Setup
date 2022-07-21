#!/bin/bash

  local _default _response

backup_scripts () {
	cp -a ~/Scripts/. ~/backup_Scripts/
	rmdir ~/Scripts
	mkdir ~/Scripts
}

install_programs () {
	echo "[!] Trying to install kerbrute"
	{
		curl https://github.com/ropnop/kerbrute/releases/download/v1.0.3/kerbrute_linux_amd64 > ~/Scripts/kerbrute &&
		{
			chmod +x kerbrute &&
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
			echo "[-]Couldn't install dependencies"
		}
	} || {
		echo "[-] Couldn't download impacket"
	}
	echo "export PATH=$PATH:~/Scripts/">>~/.bashrc
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
      						;;
    					[Nn][Oo]|[Nn])
      						exit;;
      						;;
    					*)
      						;;
  			esac
		done
fi
