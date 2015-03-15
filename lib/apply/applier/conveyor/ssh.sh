function convey() {
  host="${host:=localhost}"
  command_batch="$1"

  echo $command_batch
  ssh -t $host << COMMAND_BATCH
  for command in $command_batch; do
    eval $command
  done
COMMAND_BATCH
}
