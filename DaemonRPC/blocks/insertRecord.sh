#!/bin/bash

#Developed by Leonardo N.
#GIT::

#   VARIABLE CONFIGURATION
# _______________________________________

conf_file=$5
. ../$conf_file

#________________________________________

i_height=$2
e_height=$3
json_s=$4

url="http://$ip:$port/json_rpc -d '{\"jsonrpc\":\"2.0\",\"id\":\"0\",\"method\":\"get_block_headers_range\",\"params\":{\"start_height\":$i_height,\"end_height\":$e_height}}' -H 'Content-Type:application/json'"
command="curl ${url}"
blocks=$(eval $command)  

for (( k=0 ; $k<$json_s; k++))
do

    jq_r=".result.headers[$k]"
    block=$(echo "$blocks" | jq -r $jq_r)
    
    if [ ! -z "$block" ]; then
        block_size=$(echo "$block" | jq -r '.block_size')     
        cumulative_difficulty=$(echo "$block" | jq -r '.cumulative_difficulty')
        dpth=$(echo "$block" | jq -r '.depth')
        difficulty=$(echo "$block" | jq -r '.difficulty')
        hash=$(echo "$block" | jq -r '.hash')
        major_version=$(echo "$block" | jq -r '.major_version')
        miner_hash=$(echo "$block" | jq -r '.miner_tx_hash')
        height=$(echo "$block" | jq -r '.height')
        nonce=$(echo "$block" | jq -r '.nonce')
        num_txes=$(echo "$block" | jq -r '.num_txes')
        reward=$(echo "$block" | jq -r '.reward')
        ts=$(echo "$block" | jq -r '.timestamp')
        
        [ -z "$psql" ] && psql="psql -U $user -d $database -c \"INSERT INTO block (block_size, cumulative_difficulty, dpth, difficulty, hash, major_version, miner_hash, height, nonce, num_txes, reward, ts) VALUES ($block_size, $cumulative_difficulty, $dpth, $difficulty, '$hash', $major_version, '$miner_hash', $height, $nonce, $num_txes, $reward, $ts)\"" ||  psql_append="psql -U $user -d $database -c \"INSERT INTO block (block_size, cumulative_difficulty, dpth, difficulty, hash, major_version, miner_hash, height, nonce, num_txes, reward, ts) VALUES ($block_size, $cumulative_difficulty, $dpth, $difficulty, '$hash', $major_version, '$miner_hash', $height, $nonce, $num_txes, $reward, $ts)\"" && psql="$psql\
        $psql_append"
    fi

done

# echo $psql
eval $psql
psql=''
