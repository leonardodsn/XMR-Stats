#!/bin/bash 

function wait_sync {
    syncing="true"
    
    while [ "$syncing" = "true" ]
    do
        status="curl http://$ip:$port/json_rpc -d '{\"jsonrpc\":\"2.0\",\"id\":\"0\",\"method\":\"get_info\"}' -H 'Content-Type: application/json'"
        
        status_json=$(eval $status)
        syncing_result=$(echo "$status_json" | jq -r '.result.busy_syncing')
        
        [[ "$syncing_result" = "false" ]] && syncing="false" && echo synced || (echo "Waiting for Daemon to finish syncing" && sleep 1m)

    done
}
