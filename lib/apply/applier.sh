require_relative $BASH_SOURCE 'applier/conveyor'
require_relative $BASH_SOURCE 'applier/installer'

function sync_target_system() {
  skeleton=$1

  sudo rsync --suffix='.apply.bak' -bvr ${APPLY_TEMP_DIR}/${skeleton}/ /
}
