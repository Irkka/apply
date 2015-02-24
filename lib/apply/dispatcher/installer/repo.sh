function process_repo_batch() {
  repo_batch_file=$1
  target_directory=${repo_batch_file##${APPLY_SKELETON_DIR}/${skeleton}}
  target_directory=${target_directory%\/:git}

  echo 'Cloning repos'
  cat $repo_batch_file|parallel --no-notice clone_repo $target_directory {}
}

function clone_repo() {
  target_directory="$1"
  repo=$(echo $2|awk -F ' ' '{ print $1 }')
  custom_directory=$(echo $2|awk -F ' ' '{ print $2 }')

  if [[ -n $custom_directory ]]; then
    echo "git clone $(expand_source "$repo") ${target_directory}/${custom_directory}"
  else
    echo "git clone $(expand_source "$repo") ${target_directory}/${repo##*/}"
  fi
}

function expand_source() {
if [[ $1 =~ ^(http|https|git):\/\/.*$ ]]; then
  echo "$1"
else
  echo "git@github.com:${1}"
fi
}

export -f process_repo_batch clone_repo expand_source
