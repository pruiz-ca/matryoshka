#!/bin/bash

function remove_matryoshka() {
  ./scripts/clean.sh
	sed -i _bak "/matryoshka/d" ~/.zshrc
	rm -rf ~/.matryoshka
	rm -rf ~/.matryoshkarc
  echo "Removed succesfully"
}

read -p "You are going to remove matryoshka and all its config from your computer. Are you sure (y/n)? " choice
case "$choice" in
  y|Y ) remove_matryoshka;;
  n|N ) ;;
  * ) echo "Not a valid answer";;
esac
