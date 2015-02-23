require_relative $BASH_SOURCE 'dispatcher/configure'

require_relative $BASH_SOURCE 'dispatcher/conveyor'
require_relative $BASH_SOURCE 'dispatcher/installer'
require_relative $BASH_SOURCE 'dispatcher/mapper'

function apply_dispatch() {
  dispatcher_configure "$@"

  APPLY_TEMP_DIR=$(mktemp -d "${APPLY_TEMP_DIR_BASE}-XXXXXX")
  export APPLY_TEMP_DIR APPLY_SKELETON_DIR APPLY_RESOURCE_DIR APPLY_PACKAGE_MANAGER APPLY_VCS APPLY_CONVEYOR APPLY_SKELETONS APPLY_CONTEXT_DIR

  for skeleton in $APPLY_SKELETONS; do
    echo "Processing $skeleton"
    process_skeleton $skeleton
  done

  cleanup
}

function process_skeleton() {
skeleton=$1
[[ $FILES_ENABLED == true ]] && dispatch_files $(find "${APPLY_SKELETON_DIR}/${skeleton}" -type f -not -regex '.*:.*'|xargs) 
[[ $PACKAGES_ENABLED == true ]] && dispatch_packages $(find "${APPLY_SKELETON_DIR}/${skeleton}" -type f -name ':packages'|xargs)
[[ $REPOS_ENABLED == true ]] && dispatch_repos $(find "${APPLY_SKELETON_DIR}/${skeleton}" -type f -name ':git'|xargs)
}

function dispatch_files() {
files="$@"
echo 'Dispatching configuration files to be processed'
echo $files|tr ' ' '\n'|parallel --no-notice process_file

sync_target_system
}

function dispatch_packages() {
packages="$@"

echo 'Dispatching packages to the installer'
process_packages $(cat $packages|xargs)
}

function dispatch_repos() {
repos="$@"

echo 'Dispatching repos'
[[ -n "$@" ]] && cat $repos
}

function cleanup() {
echo "Removing temporary build directory $APPLY_TEMP_DIR"
rm -r $APPLY_TEMP_DIR

dispatcher_dump
}

function dispatcher_dump() {
echo "Resource directory: ${APPLY_RESOURCE_DIR}"
echo "Skeleton directory: ${APPLY_SKELETON_DIR}"
echo "Context directory: ${APPLY_CONTEXT_DIR}"
echo "Temporary directory: ${APPLY_TEMP_DIR}"

echo "Skeletons: $APPLY_SKELETONS"
echo "Package manager: $APPLY_PACKAGE_MANAGER"
echo "Conveyor: $APPLY_CONVEYOR"
echo "Version Control System: $APPLY_VCS"

echo "Packages enabled: $PACKAGES_ENABLED"
echo "Files enabled: $FILES_ENABLED"
echo "Repos enabled: $REPOS_ENABLED"
}

function sync_target_system() {
  skeleton=$1
  sudo rsync --suffix='.apply.bak' -bvr ${APPLY_TEMP_DIR}/${skeleton}/ /
}
