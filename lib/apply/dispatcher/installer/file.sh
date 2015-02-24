function process_file() {
  source_file="$1"

  file=$(basename $source_file)
  file_name="${file%.*}"
  file_extension="${file##*.}"
  file_dir=$(dirname $1)

  file_target_directory="${file_dir##${APPLY_SKELETON_DIR}/${skeleton}}"
  file_target="${file_target_directory}/${file_name}"

  temp_target_directory="${APPLY_TEMP_DIR}/${skeleton}/${file_target_directory#/}"
  temp_file="${temp_target_directory}/${file_name}"

  mkdir -p $temp_target_directory

  if [[ -n $file_extension ]]; then
    echo "Building $source_file to staging area"
    build_file $source_file $temp_file
  else
    echo 'Staging static file'
    cp $source_file $temp_file
  fi
}

function build_file() {
  source_file="$1"
  temp_file="$2"

  erubis ${source_file} > "${temp_file}"
}

export -f process_file build_file
