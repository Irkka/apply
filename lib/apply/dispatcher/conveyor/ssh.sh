function convey() {
  host="${host:=localhost}"
  command_batch="$1"

  echo $command_batch
  #ssh -t $host $command_batch
}
