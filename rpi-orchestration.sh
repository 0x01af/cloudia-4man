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

[ "$username" == "" ] && [ "$password" == "" ] && [ "$hosts" == "" ] && { printf "ERROR - You have to define each parameter.\n\nUsage: $0 -u username -p password -h host2,host3,hostN\n\n"; exit 1; }

maindir=$(pwd)

# Iterate each host
# based on: https://stackoverflow.com/questions/10586153/how-to-split-a-string-into-an-array-in-bash
IFS=',' read -r -a hosta <<< "$hosts"
for host in "${hosta[@]}"
do

  if [ ! -d "$maindir/rpi-configs/$host" ]; then
    printf "ERROR - Configuration is missing: $host\n";
	# based on: https://linuxize.com/post/bash-break-continue/
    continue
  fi
  
  cd "$maindir/rpi-configs/$host"

  # (Re-)Initialize terraform job
  terraform init -input=false

  # Plan terraform job
  terraform plan -var "su_username=$username" -var "su_password=$password" -out=$host.tfplan -input=false

  # Apply terraform job
  terraform apply -input=false $host.tfplan
  
  cd "$maindir"

done


