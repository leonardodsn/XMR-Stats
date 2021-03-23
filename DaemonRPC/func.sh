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

    dbheight_command="psql -U $user -d $database -c \"SELECT MAX(height) FROM block\""
    dbheight=$(eval $dbheight_command)              
    dbheight=$(echo ${dbheight/"(1 row)"})
    dbheight=$(echo "${dbheight//[^0-9.]/}")
    dbheight=$(expr $dbheight - 1)

    gap_search="psql -U $user -d $database -c \"select COUNT(*) FROM ( SELECT series, block.height from generate_series(1, $dbheight, 1) series left join block on series = block.height where height is null ) AS countz\""
    dbgap_size=$(eval $gap_search)
    dbgap_size=$(echo ${dbgap_size/"(1 row)"})
    dbgap_size=$(echo "${dbgap_size//[^0-9.]/}")
    dbgap_size=$(expr $dbgap_size)
    
    echo $dbgap_size

}

function db_height {
    dbheight_command="psql -U $user -d $database -c \"SELECT MAX(height) FROM block\""
    dbheight=$(eval $dbheight_command)              
    dbheight=$(echo ${dbheight/"(1 row)"})
    dbheight=$(echo "${dbheight//[^0-9.]/}")
    dbheight=$(expr $dbheight - 1)
    
    echo $dbheight
}
