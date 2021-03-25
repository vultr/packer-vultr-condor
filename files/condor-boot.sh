#!/usr/bin/env bash

set -euxo pipefail

METADATA=$(curl --silent 169.254.169.254/v1.json)
MD_PUBLIC_KEYS=$(echo $METADATA | jq '."public-keys"')

ssh_keys(){
    if [[ $(echo $MD_PUBLIC_KEYS | jq '.|length') -gt 0 ]]; then
        echo $MD_PUBLIC_KEYS | jq -r '.[]' > /root/.ssh/authorized_keys
    else
        echo "No SSH Public keys to add."
    fi
}

main(){
    ssh_keys
}

main
