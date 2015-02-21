function process_file() {
  file=$(basename $1)
  file_name="${file%.*}"
  file_extension="${file##*.}"

  if [[ -n $file_extension ]]; then
    build_file $1
  else
    #install_file $1
    echo 'No file extension'
  fi
}

function build_file() {
  file=$(basename $1)
  file_name="${file%.*}"
  file_extension="${file##*.}"
  file_dir=$(dirname $1)
  file_target_directory="${file_dir##${APPLY_SKELETON_DIR}/${APPLY_SKELETON}}"
  file_target="${file_target_directory}/${file_name}"

  temp_file="${APPLY_TEMP_DIR}/${file_name}"
  echo $1
  echo $temp_file
  echo $file_target_directory
  erubis ${1} > "${temp_file}"

  install_file $temp_file $file_target
}

function install_file() {
  if [[ -f $2 ]]; then
    echo 'File exists. Rewrite?'
    read switch

    if [[ $switch =~ 'n' ]]; then
      echo 'Not rewriting.'
      exit 1
    fi
  fi

  mv $temp_file $file_target || sudo mv $temp_file $file_target
}
