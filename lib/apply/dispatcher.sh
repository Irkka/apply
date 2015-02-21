require_relative $BASH_SOURCE 'dispatcher/configure'

require_relative $BASH_SOURCE 'dispatcher/conveyor'
require_relative $BASH_SOURCE 'dispatcher/installer'
require_relative $BASH_SOURCE 'dispatcher/mapper'

function apply_dispatch() {
  dispatcher_configure "$@"

  APPLY_TEMP_DIR=$(mktemp -d "${APPLY_TEMP_DIR_BASE}-XXXXXX")
  dispatch_skeleton $APPLY_CONVEYOR $APPLY_SKELETON

  cleanup
}

function dispatcher_dump() {
  echo "Resource directory: ${APPLY_RESOURCE_DIR}"
  echo "Skeleton directory: ${APPLY_SKELETON_DIR}"
  echo "Temporary directory: ${APPLY_TEMP_DIR}"
}

function dispatch_skeleton() {
  for file in $(find "${APPLY_SKELETON_DIR}/${APPLY_SKELETON}" -iname *.erb) ; do
    echo "Dispatching $(basename $file) to installer"
    process_file $file
  done
}

function cleanup() {
  echo 'Removing temporary files - not implemented, though'
  echo $APPLY_TEMP_DIR
}
