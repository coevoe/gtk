#!/bin/sh
# This is installation script for my GTK theme (alias Qogir-dark + phinger-cursor-theme light and dpi scaling)

current_time=$(date +%d.%m-%H:%M)
gtk3path="$HOME/.config/gtk-3.0"
make_backup() {
	while read -p "Do you want to backup your GTK configuration? [y/n]: " choice1; do
		case $choice1 in 
			'y')
				cp ~/.gtkrc-2.0 ~/.gtkrc-2.0.backup-$current_time
				cp "${gtk3path}"/settings.ini "${gtk3path}"/settings.ini.backup-$current_time
				printf "\nBacking up successed without errors\n"
				break
				;;
			'n')
				printf "\n\033[1;31mThe installation will now OVERWRITE you GTK settings!\033[0m\n"
				break
				;;
			*)
				printf "\nWrong option!\n"
				continue
				;;
		esac
	done
}

remove_backups() {
	while read -p "Do you want to remove backups of your GTK settings? [y/n]: " choice2; do 
		case $choice2 in 
			y)
				rm -f ~/.gtkrc-2.0.*
				rm -f "${gtk3path}"/settings.ini.*
				printf "Removing successed without errors\n"
				break
				;;
			n)
				printf "Exiting...\n"
				exit 1
				;;
			*)
				printf "Wrong option!\n"
				continue
				;;
		esac
	done
}

program_help() {
	printf "This is the installation script that installs my GTK theme\n"
	printf "Usage: ./setup.sh [OPTION]\n"
	printf "			./setup.sh 			-b -i automaticly\n"
	printf "			./setup.sh -h 		-h for help\n"
	printf "			./setup.sh -b 		-b for backup\n"
	printf "			./setup.sh -i 		-i for install\n"
	printf "			./setup.sh -r 		-r for removing backups\n"
}

install_theme() {
	while read -p "Do you want to install my GTK theme? [y/n]: " choice; do 
		case $choice in 
			y)
				printf "\nChecking for dependencies...\n"
				if [[ $(pacman -Qqe | grep qogir-gtk-theme) == "qogir-gtk-theme" && $(pacman -Qqe | grep phinger-cursors) == "phinger-cursors" && $(pacman -Qqe | grep papirus-icon-theme) == "papirus-icon-theme" ]]; then
					printf "All of dependencies are installed!\n"
				else
					sudo pacman -S qogir-gtk-theme phinger-cursors papirus-icon-theme
					printf "All dependencies installed!\n"
				fi
				cp -f ./.gtkrc-2.0 ~/.gtkrc-2.0
				cp -f ./settings.ini $gtk3path/settings.ini
				printf "Installation successed without errors\n"
				break
				;;
			n)
				rm -f ~/.gtkrc-2.0.backup-$current_time
				rm -f "${gtk3path}"/settings.ini.backup-$current_time
				printf "Exiting...\n"
				exit 1
				;;
			*)
				printf "Wrong option!\n"
				continue
				;;
		esac
	done
}

while getopts "hibr" option; do
	case "${option}" in
    h) 
		program_help
		exit 1
		;;
    i) 
		install_theme
		exit 1
		;;
	b) 
		make_backup
		exit 1
		;;
	r) 
		remove_backups
		exit 1
		;;
    ?) 
		printf "Unknown option -${OPTARG}\n"
		exit -1
		;;
	esac
done

printf "\033[1;31mThis program will overwrite you GTK configuration, unless you type y\033[0m\n"
make_backup
install_theme
