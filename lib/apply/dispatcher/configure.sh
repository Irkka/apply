function dispatcher_configure() {
  DEFAULT_CONFIG_DIR="${XDG_CONFIG_HOME}/apply"
  APPLY_TEMP_DIR_BASE="/tmp/apply"

  parse_cli_options "$@"

  APPLY_RESOURCE_DIR="${APPLY_RESOURCE_DIR:-${DEFAULT_CONFIG_DIR}/resources}"
  APPLY_SKELETON_DIR="${APPLY_RESOURCE_DIR}/skeletons"
  APPLY_CONTEXT_DIR="${APPLY_RESOURCE_DIR}/contexts"

  APPLY_SKELETONS="${APPLY_SKELETONS:-desktop}"
  APPLY_PACKAGE_MANAGER="${APPLY_PACKAGE_MANAGER:-pacman}"
  APPLY_CONVEYOR="${APPLY_CONVEYOR:-local}"
  APPLY_VCS="${APPLY_VCS:-git}"

  FILES_ENABLED="${FILES_ENABLED:-true}"
  PACKAGES_ENABLED="${PACKAGES_ENABLED:-true}"
  REPOS_ENABLED="${REPOS_ENABLED:-true}"

  TARGET_HOSTS="${TARGET_HOSTS:-}"

  export APPLY_RESOURCE_DIR APPLY_SKELETON_DIR APPLY_CONTEXT_DIR APPLY_PACKAGE_MANAGER APPLY_VCS APPLY_CONVEYOR APPLY_SKELETONS TARGET_HOSTS
}

function parse_cli_options() {
  options=$(getopt -qu -o 'h?vn:D:C:P:V:S:H:' -l 'help,version,no-packages,no-files,no-repos,resource-dir:,skeletons:,conveyor:,package-manager:,vcs:,target-hosts:' -- "$@")
  set -- $options
  if [[ "$#" -eq 1 ]]; then
    usage
    exit 1
  fi

  while [[ -n "$1" ]]; do
    case "$1" in
      -v|--version )
        version
        exit 0
        ;;
      -h|--help )
        usage
        ;;
      -D|--resource-dir )
        APPLY_RESOURCE_DIR=$(realpath "$2")
        shift 2
        ;;
      -S|--skeletons )
        APPLY_SKELETONS="$(echo $2|tr ',' ' ')"
        shift 2
        ;;
      -C|--conveyor )
        APPLY_CONVEYOR="$2"
        shift 2
        ;;
      -P|--package-manager )
        APPLY_PACKAGE_MANAGER="$2"
        shift 2
        ;;
      -V|--vcs )
        APPLY_VCS="$2"
        shift 2
        ;;
      -H|--target-hosts )
        TARGET_HOSTS="$(echo $2|tr ',' ' ')"
        shift 2
        ;;
      -n )
        DISABLED_RESOURCES="$(echo $2|tr ',' ' ')"
        toggle_disabled_resources $DISABLED_RESOURCES
        shift 2
        ;;
      --no-packages )
        PACKAGES_ENABLED=false
        shift
        ;;
      --no-repos )
        REPOS_ENABLED=false
        shift
        ;;
      --no-files )
        FILES_ENABLED=false
        shift
        ;;
      -- )
        shift
        break
        ;;
      * )
        echo 'Internal error.'
        exit 1
        ;;
    esac
  done
}

function toggle_disabled_resources() {
  while [[ -n $1 ]]; do
    case $1 in
      packages )
        PACKAGES_ENABLED=false
        shift
        ;;
      files )
        FILES_ENABLED=false
        shift
        ;;
      repos )
        REPOS_ENABLED=false
        shift
        ;;
      * )
        echo 'Invalid resource type.'
        shift
    esac
  done
}
