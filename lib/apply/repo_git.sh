function apply_repos() {
  cat "${1}/git/repositories"|sed -r -e '/#.*/d' -e '/^$/d'|parallel --no-notice clone_repo {}
}

function clone_repo() {
  repository_name="$(expand_source $(echo $1|cut -d ' ' -f 1))"
  destination_directory="$(echo $1|cut -d ' ' -f 2)"
  echo "Repository name and destination directory: $repository_name $destination_directory"

  if [[ ! -d "$destination_directory" ]]; then
    echo "Creating ${destination_directory} directory."
    mkdir -p "$destination_directory"
    echo "Executing repository cloning sequence."
    git clone $repository_name $destination_directory
  else
    echo "$destination_directory already exists. Skipping!"
  fi
}

function expand_source() {
if [[ $1 =~ ^(http|https|git):\/\/.*$ ]]; then
    echo "$1"
  else
    echo "git@github.com:${1}"
  fi
}

export -f apply_repos clone_repo expand_source
