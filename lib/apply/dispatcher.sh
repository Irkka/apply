require_relative $BASH_SOURCE 'dispatcher/configure'

require_relative $BASH_SOURCE 'dispatcher/conveyor'
require_relative $BASH_SOURCE 'dispatcher/installer'
require_relative $BASH_SOURCE 'dispatcher/mapper'

function apply_dispatch() {
  dispatcher_configure "$@"

  APPLY_TEMP_DIR=$(mktemp -d "${APPLY_TEMP_DIR_BASE}-XXXXXX")
  dispatch_skeleton $APPLY_CONVEYOR $APPLY_SKELETON

  #cleanup
}

function dispatcher_dump() {
  echo "Resource directory: ${APPLY_RESOURCE_DIR}"
  echo "Skeleton directory: ${APPLY_SKELETON_DIR}"
  echo "Context directory: ${APPLY_CONTEXT_DIR}"
  echo "Temporary directory: ${APPLY_TEMP_DIR}"

  echo "Skeleton: $APPLY_SKELETON"
  echo "Package manager: $APPLY_PACKAGE_MANAGER"
  echo "Conveyor: $APPLY_CONVEYOR"
  echo "Version Control System: $APPLY_VCS"
}

function dispatch_skeleton() {
  dispatch_files $(find "${APPLY_SKELETON_DIR}/${APPLY_SKELETON}" -type f -not -regex '.*:.*'|xargs) 
}

function dispatch_files() {
  files="$@"
  for file in $files ; do
    echo "Dispatching $(basename $file) to installer"
    process_file $file
  done
}

function cleanup() {
  echo "Removing temporary build directory $APPLY_TEMP_DIR"
  rm -r $APPLY_TEMP_DIR

  dispatcher_dump
}
