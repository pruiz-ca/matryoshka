# 🪆 Matryoshka
Image made to help 42 students run linux natively on MacOS using only one command. Use it only on your campus iMac.
It comes with all packages necessary for 42 projects.

### Features
 - Valgrind
 - Norminette v3
 - Ohmyzsh! with spaceship theme
 - gcc, clang, nasm, lldb
 - vim

### Reasons to use this tool
 - You want to run Valgrind easily
 - To test projects on linux
 - Runs docker on goinfre thanks to https://github.com/alexandregv/42toolbox

### How to install
Run this command on your terminal:
    
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/pruiz-ca/Matryoshka/main/install.sh)"

### How to use
Run 'matryoshka' to open a linux terminal using your current directory as root
Run 'dockerclean' to remove all docker related info (including other containers)
