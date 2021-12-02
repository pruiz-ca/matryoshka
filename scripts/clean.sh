#!/bin/bash
source scripts/run.sh

VBoxManage controlvm $VM_NAME poweroff > /dev/null 2>&1
VBoxManage unregistervm --delete $VM_NAME > /dev/null 2>&1

echo "$VM_NAME deleted"
