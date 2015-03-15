require_relative $BASH_SOURCE 'dispatcher/configure'

function apply_dispatch() {
  dispatcher_configure "$@"

  setup
  dispatch_skeletons $APPLY_SKELETONS
  cleanup
}

function setup() {
  APPLY_TEMP_DIR=$(mktemp -d "${APPLY_TEMP_DIR_BASE}-XXXXXX")
  export APPLY_TEMP_DIR
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
  echo "Target hosts: $TARGET_HOSTS"

  echo "Packages enabled: $PACKAGES_ENABLED"
  echo "Files enabled: $FILES_ENABLED"
  echo "Repos enabled: $REPOS_ENABLED"
}

function dispatch_hosts() {
  hosts="$@"

  for host in $hosts; do
    echo "$host"
  done
}

function dispatch_skeletons() {
  for skeleton in $APPLY_SKELETONS; do
    export skeleton
    echo "Processing $skeleton"
    process_skeleton $skeleton
  done
}

function process_skeleton() {
  skeleton=$1

  [[ $FILES_ENABLED == true ]] && dispatch_files $(find "${APPLY_SKELETON_DIR}/${skeleton}" -type f -not -regex '.*:.*'|xargs)
  [[ $PACKAGES_ENABLED == true ]] && dispatch_packages $(find "${APPLY_SKELETON_DIR}/${skeleton}" -type f -name ':packages'|xargs)
  [[ $REPOS_ENABLED == true ]] && dispatch_repo_batches $(find "${APPLY_SKELETON_DIR}/${skeleton}" -type f -name ':git'|xargs)
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

function dispatch_repo_batches() {
  repo_batches="$@"

  echo 'Dispatching repo batches'
  [[ -n "$@" ]] && echo $repo_batches|tr ' ' '\n'|parallel --no-notice process_repo_batch
}
