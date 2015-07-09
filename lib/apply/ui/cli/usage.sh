require_relative '../../meta'

function apply_usage() {
  apply_version
  cat << USAGE
Usage: apply <command> <options> <hosts>
USAGE
  exit 1
}

export -f apply_usage
