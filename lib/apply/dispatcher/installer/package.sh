function process_packages() {
  packages="$@"

  echo 'Installing packages'
  sudo pacman -Sy
  sudo pacman -S $packages
}

export -f process_packages
