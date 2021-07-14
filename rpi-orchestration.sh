#!/bin/bash

# Arguments
while getopts ip:host: flag
do
  case "${flag}" in
    ip) ip=${OPTARG};;
    host) host=${OPTARG};;
  esac
done

[ "$ip" == "" ] && { echo "Usage: $0 -ip 192.158.0.1 -host hostname"; exit 1; }
[ "$host" == "" ] && { echo "Usage: $0 -ip 192.158.0.1 -host hostname"; exit 1; }

# Prepare working directory for current Raspberry PI
# based on: https://www.cyberciti.biz/faq/check-if-a-directory-exists-in-linux-or-unix-shell/
if [ ! -d "./rpi-configs/$host" ]; then
  # creating working directory for current Raspberry PI
  mkdir -p "./rpi-configs/$host"
fi
cd "./rpi-configs/$host"

# (Re-)Initialize terraform job
terraform init -input=false

# Plan terraform job
terraform plan -out=$host.tfplan -input=false

# Apply terraform job
# terraform apply -var 'host=$host' -var 'ip=$ip' -input=false $host.tfplan