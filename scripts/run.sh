#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PINK='\033[0;35m'
BLUE='\033[0;36m'
NOCOLOR='\033[0m'

source ~/.matryoshkarc

#####
# VM CONFIG
#####
SSH_PUBKEY_PATH=~/.ssh/id_rsa.pub
SSH_PORT=42

VM_NAME=Alpine42 # Don't change
VM_IP=localhost
VM_USER=root
VM_PATH=~/VirtualBox\ VMs/$VM_NAME; [[ -d "/goinfre" ]] && VM_PATH=/goinfre/$(whoami)/$VM_NAME
VM_VBOX_PATH=$VM_PATH/$VM_NAME.vbox
VM_VDI_PATH=$VM_PATH/$VM_NAME.vdi
PARTITION_SIZE=$SIZE_ELSEWHERE; [[ -d "/goinfre" ]] && PARTITION_SIZE=$SIZE_42IMAC # Defaults to 8gb but if /goinfre exists increase it to 20gb


#####
# FUNCTIONS
#####
CURRENT_FOLDER=$(echo "${PWD/#$HOME/}")
HOST="-p $SSH_PORT $VM_USER@$VM_IP"
VBOX_GDRIVE_ID="1iOhsgYCa-aXRJFvdZd2SHiMwHcholfZO"
VDI_GDRIVE_ID="1bSviLU9863aJjrI9KCFwmhZv-BO6MBEt"

function download_config_file_gdrive() {
	echo -e $PINK"Downloading Alpine42.vbox:"
	file_name=$VM_PATH/$VM_NAME.vbox
	echo -en $NOCOLOR
	curl -#L "https://drive.google.com/uc?export=download&id=$VBOX_GDRIVE_ID" -o "$file_name"
}

function download_disk_file_gdrive() {
	echo -e $PINK"Downloading Alpine42.vdi:"
	file_name=$VM_PATH/$VM_NAME.vdi
	curl -sc .cookie "https://drive.google.com/uc?export=download&id=$VDI_GDRIVE_ID" > /dev/null
	code="$(awk '/_warning_/ {print $NF}' .cookie)"
	echo -en $NOCOLOR
	curl -#Lb .cookie "https://drive.google.com/uc?export=download&confirm=$code&id=$VDI_GDRIVE_ID" -o "$file_name"
	rm -f .cookie
}

function download_vm() {
	mkdir -p "$VM_PATH"
	if [[ ! -f "$VM_VDI_PATH" ]]; then
		download_config_file_gdrive
		download_disk_file_gdrive
		check_vdi_size=$(stat -f="%z" "$VM_VDI_PATH")
		if [[ ! $check_vdi_size == "=140509184" ]]; then
			echo -e $RED"Download failed :("$NOCOLOR
			rm -rf "$VM_PATH"
			exit
		fi
	fi
}

function check_error() {
	if [[ ! $? -eq 0 ]]; then
		echo -e $PINK$1$NOCOLOR
	fi
}

function add_vm_to_virtualbox() {
	echo -en $YELLOW
	VBoxManage registervm "$VM_VBOX_PATH" 2> /dev/null
	check_error "Machine already registered"
	VBoxManage storageattach $VM_NAME --storagectl "IDE" --device 0 --port 0 --type hdd --medium "$VM_VDI_PATH" > /dev/null 2>&1
	check_error "Storage already attached"
}

function resize_partition() {
	actual_size=$(VBoxManage showmediuminfo 247286a6-b7cd-489a-bb8e-18ea5f739324 | grep "Capacity" | awk '{print $2$3}')
	is_first_start=false; [[ $actual_size == '220MBytes' ]] && is_first_start=true
	if [[ $is_first_start == true ]]; then
		VBoxManage modifyhd "$VM_VDI_PATH" --resize $PARTITION_SIZE > /dev/null 2>&1
	fi
}

function start_vm() {
	is_running=$(VBoxManage list runningvms | grep $VM_NAME | wc -l | bc)
	if [[ $is_running == 0 ]]; then
		VBoxManage startvm "$VM_NAME" --type headless
	fi
	echo -en $NOCOLOR
}

function copy_sshkey_to_vm() {
	time_passed=0
	echo -en $BLUE
	echo "Wait a minute until ssh service starts"
	echo -e "If asked, enter password ->$GREEN alpine"
	echo -en $NOCOLOR
	until ssh-copy-id -i $SSH_PUBKEY_PATH $HOST 2> /dev/null; do
		sleep 2
	done
}

function update_os() {
	echo -en $BLUE
	if [[ $is_first_start == true ]]; then
		ssh $HOST "sudo growpart /dev/sda 2 && sudo resize2fs /dev/sda2"
	fi
	clear -x
	echo "> Updating OS and installing packages"
	ssh $HOST "sudo apk update && sudo apk upgrade"
}

function install_packages() {
	if [[ ! -z ${PACKAGES+x} ]]; then
		ssh $HOST sudo apk add "$PACKAGES"
	fi
	echo -en $NOCOLOR
}

function shared_folder() {
	VBoxManage sharedfolder add $VM_NAME --name mac_home -hostpath ~/ 2> /dev/null
}

function install_norminette() {
	if [[ $NORMINETTE == true ]]; then
		echo -en $BLUE
		ssh $HOST "sudo apk add py3-pip && sudo python3 -m pip install --upgrade pip setuptools && sudo python3 -m pip install norminette"
		echo -en $NOCOLOR
	fi
}

function clean_apk_cache() {
	ssh $HOST sudo rm -rf /var/cache/apk/* 2> /dev/null
}

function ssh_to_vm() {
	mount_shared_folder="sudo mount -t vboxsf mac_home /mnt/mac"
	clear -x
	ssh -t $HOST "$mount_shared_folder && cd /mnt/mac$CURRENT_FOLDER; service docker start > /dev/null 2>&1; exec $SHELL -l"
}


#####
# SCRIPT
#####
if [[ $0 == $BASH_SOURCE ]]; then
	download_vm
	add_vm_to_virtualbox
	resize_partition
	shared_folder
	start_vm
	copy_sshkey_to_vm
	update_os
	install_packages
	install_norminette
	clean_apk_cache
	ssh_to_vm
fi
