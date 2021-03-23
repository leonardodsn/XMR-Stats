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

function gap_size {

    gap_search="psql -U $user -d $database -c \"select series, block.height FROM generate_series(1, $dbheight, 1) series LEFT JOIN block ON series = block.height WHERE height is null ORDER BY series LIMIT 1\""
    dbgap=$(eval $gap_search)
    dbgap=$(echo ${dbgap/"(1 row)"})
    dbgap=$(echo "${dbgap//[^0-9.]/}")
    dbgap=$(expr $dbgap)
    
    echo $dbgap

}
