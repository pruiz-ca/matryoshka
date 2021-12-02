# 🪆 Matryoshka
Autoinstall and run a Linux environment on your Mac with one command in less than 45 secs.

I'm starting ft_transcendence and Docker does not work anymore on 42 Madrid, so this image has been made as a workaround to get docker running painlessly.

### Installation
- Install VirtualBox
- Run this command on your terminal:

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/pruiz-ca/Matryoshka/main/install.sh)"

### Usage
After installing, reload your terminal and run ```matryohska``` to see what commands are available.

Available commands:
 - ```run```: starts matryoshka
 - ```stop```: stops the VM running in the background
 - ```clean```: removes ONLY the VM files, not matryoshka
 - ```update```: updates matryoshka
 - ```reset```: same as performing ```clean && run```
 - ```uninstall```: removes ALL associated files (matryoshka and VM)

### Features
 - From 0 to Linux with one command and 45 seconds.
 - Mounts your Mac home automatically and cd to your current directory. Files are shared so everything you modify through this linux VM will affect your real files in real time and viceversa.
 - Uses goinfre if using it in 42, otherwise uses VBox default folder
 - Edit which packages you want to install by default
 - Autoexpands the VM disk to your desired partition size. If you are in 42 the default size is 20gb, if not 8gb.
 - Uses Alpine Linux because of its low weight
 - Defaults ssh to localhost port 42

### Why use this?
 - You need a linux environment to try your projects
 - fsanitize on linux
 - valgrind
 - Can't use docker on your campus
