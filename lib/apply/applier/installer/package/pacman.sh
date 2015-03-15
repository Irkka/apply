function apply_packages() {
  install_packages $(cat "${1}/pacman"|xargs)
}

function install_packages() {
  echo 'Installing packages'
  #convey "sudo pacman --noconfirm -S \"$@\""
  #echo "sudo pacman --noconfirm -S \"$@\""
  #ssh -t 1.1.1.2 "sudo pacman --noconfirm -S \"$@\""
}
