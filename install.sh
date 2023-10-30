#!/bin/sh
# This is installation script for my gtk theme (alias Qogir-dark + phinger-cursor-theme light and dpi scaling)

current_time=$(date +%d-%m-%Y_%H:%M)
gtk3path="$HOME/.config/gtk-3.0"
mk_backup() {
	while read -p "Would you like to backup your gtk configuration? [y/n]: " choice; do
		case $choice in 
			'y')
				mv ~/.gtkrc-2.0 ~/.gtkrc-2.0.mk_backup-$current_time
				mv ~/.config/gtk-3.0/settings.ini ~/.config/gtk-3.0/settings.ini_backup_$current_time
				break
				;;
			'n')
				echo -e "\033[1;31mThis program will overwrite you gtk configuration!!! \033[0m\n"
				echo -e "Backing up done\n"
				break
				;;
			*)
				echo -e "Wrong option!"
				continue
				;;
		esac
	done
}

program_help() {
	echo -e "This is the installation script that installs my gtk theme\n"
	echo -e "Usage: \n"
	echo -e "			./install.sh\n"
}

check_pkgs() {
	echo -e "Checking for dependencies!\n"
	if [[ $(pacman -Qqe | grep qogir-gtk-theme) == "qogir-gtk-theme" && $(pacman -Qqe | grep phinger-cursors) == "phinger-cursors" && $(pacman -Qqe | grep papirus-icon-theme) == "papirus-icon-theme" ]]; then
		echo -e "All of dependencies are installed!\n"
	else
		sudo pacman -S qogir-gtk-theme phinger-cursors papirus-icon-theme
		echo "All dependencies installed!\n"
	fi
	echo -e "Done checking for dependencies!\n"
}

theme_install() {
	echo -e "Started installing gtk theme ..."
	echo -e "Copying GTK 2 theme"
	cp ./.gtkrc-2.0 ~/.gtkrc-2.0
	echo -e "Copying GTK 3 theme"
	cp ./settings.ini $gtk3path/settings.ini
	echo -e "Done installing gtk theme"
}

main() {
	if [[ $1 == "-h" ]]; then
		program_help
		exit
	fi
	echo -e "\033[1;31mThis program will overwrite you gtk configuration, unless you type n when the program will ask you to do a backup \033[0m \n"
	mk_backup
	check_pkgs
	theme_install
	echo -e "Installation successed without errors"
}

main
