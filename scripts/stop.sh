#!/bin/bash
source scripts/run.sh

VBoxManage controlvm $VM_NAME acpipowerbutton > /dev/null 2>&1

echo "$VM_NAME stopped"
