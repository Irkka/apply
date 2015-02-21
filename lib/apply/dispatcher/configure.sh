function dispatcher_configure() {
  DEFAULT_CONFIG_DIR="${XDG_CONFIG_HOME}/apply"
  APPLY_TEMP_DIR_BASE="/tmp/apply"

  parse_cli_options "$@"
  APPLY_RESOURCE_DIR="${APPLY_RESOURCE_DIR:-${DEFAULT_CONFIG_DIR}/resources}"
  APPLY_SKELETON_DIR="${APPLY_RESOURCE_DIR}/skeletons"
  APPLY_PACKAGES_DIR="${APPLY_RESOURCE_DIR}/packages"
  APPLY_FILES_DIR="${APPLY_RESOURCE_DIR}/files"
  APPLY_REPOS_DIR="${APPLY_RESOURCE_DIR}/repos"

  APPLY_SKELETON="${APPLY_SKELETON:-desktop}"
  APPLY_PACKAGE_MANAGER="${APPLY_PACKAGE_MANAGER:-pacman}"
  APPLY_CONVEYOR="${APPLY_CONVEYOR:-local}"
  APPLY_VCS="$APPLY_VCS:-git"
}

function parse_cli_options() {
  options=$(getopt -qu -o 'h?vD:C:P:V:S:' -l 'help,version,resource-dir:,skeleton:,conveyor:,package-manager:,vcs:' -- "$@")
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
      -S|--skeleton )
        APPLY_SKELETON="$2"
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
