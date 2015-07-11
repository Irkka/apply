require_relative 'application_name'

APPLY_VERSION='0.0.1'

function apply_version() {
  echo $APPLY_APPLICATION_NAME $APPLY_VERSION
}

export APPLY_VERSION
export -f apply_version
