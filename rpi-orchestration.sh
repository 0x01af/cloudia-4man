#!/bin/bash
# Arguments
# based on: https://www.baeldung.com/linux/use-command-line-arguments-in-bash-script
while getopts ":u:p:h:" flag; do
  case "${flag}" in
    u) username=${OPTARG};;
    p) password=${OPTARG};;
    h) hosts=${OPTARG};;
  esac
done

[ "$username" == "" ] && [ "$password" == "" ] && [ "$hosts" == "" ] && { echo "ERROR - You have to define each parameter.\n\nUsage: $0 -u username -p password -hl host2,host3,hostN"; exit 1; }

maindir = $(pwd)

for host in hosts 
do

  if [ ! -d "$maindir/rpi-configs/$host" ]; then
    echo "ERROR - Configuration is missing: $host\n";
	# based on: https://linuxize.com/post/bash-break-continue/
    continue
  fi
  
  cd "$maindir/rpi-configs/$host"

  # (Re-)Initialize terraform job
  terraform init -input=false

  # Plan terraform job
  terraform plan -out=$host.tfplan -input=false

  # Apply terraform job
  # terraform apply -var 'host=$host' -var 'ip=$ip' -input=false $host.tfplan
  
  cd "$maindir"

done


