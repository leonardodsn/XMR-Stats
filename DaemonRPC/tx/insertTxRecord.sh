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
json_tx_s=$4

for (( b=$i_height; b<=$e_height ; b++)); do

    url="http://$ip:$port/json_rpc -d '{\"jsonrpc\":\"2.0\",\"id\":\"0\",\"method\":\"get_block\",\"params\":{\"height\":$b}}' -H 'Content-Type: application/json'"
    command="curl ${url}"
    block=$(eval $command)

    #_ REGISTER COINBASE TRANSACTION
    
    coinbase_tx=$(echo $block | jq -r '.result.json' | jq -r '.miner_tx')
    miner_hash=$(echo $block | jq -r '.result.miner_tx_hash')
    
    if [ ! -z "$coinbase_tx" ]; then
    
        tx_version=$(echo $coinbase_tx | jq -r '.version')
        height=$(echo $coinbase_tx | jq -r '.vin[0].gen.height')
        amount=$(echo $coinbase_tx | jq -r '.vout[0].amount')
        rct_type=$(echo $coinbase_tx | jq -r '.rct_signatures.type')
        
        [ -z "$psql" ] && psql="psql -U $user -d $database -c \"INSERT INTO tx (height, hash,  tx_version,amount, rct_type) VALUES ($height, '$miner_hash', $tx_version, $amount, $rct_type)\"" || psql_append="psql -U $user -d $database -c \"INSERT INTO tx (height, hash,  tx_version,amount, rct_type) VALUES ($height, '$miner_hash', $tx_version, $amount, $rct_type)\""  && psql="$psql\
        $psql_append"
        
        coinbase_tx=''
    
    fi

    #REGISTER OTHER TRANSACTIONS
    tx_hashes=$(echo $block | jq -r ".result.tx_hashes")
    txs_s=$(echo $tx_hashes | jq 'length')
    
    txs_url="http://$ip:$port/get_transactions -d '{\"txs_hashes\":$tx_hashes,\"decode_as_json\":true}' -H 'Content-Type: application/json'"
    
#     echo $txs_url
    
    txs_command="curl ${txs_url}"
    txs=$(eval $txs_command)
    
    for (( t=0 ; $t<$txs_s; t++))
    do

        jq_r=".txs[$t]"
        tx=$(echo "$txs" | jq -r $jq_r)
        tx_asjson=$(echo "$tx" | jq -r '.as_json')
        
        if [ ! -z "$tx" ]; then
            height=$(echo "$tx" | jq -r '.block_height')
            hash=$(echo "$tx" | jq -r '.tx_hash')
            ins=$(echo "$tx_asjson" | jq -r '.vin | length')
            outs=$(echo "$tx_asjson" | jq -r '.vout | length')
            
            tx_hex=$(echo "$tx" | jq -r '.as_hex')
            tx_size=$(echo $tx_hex | tr -d '\n' | wc -c)
            tx_size=$(expr $tx_size / 2)
            
            fee=$(echo "$tx_asjson" | jq -r '.rct_signatures.txnFee')
            tx_version=$(echo "$tx_asjson" | jq -r '.version')
            rct_type=$(echo "$tx_asjson" | jq -r '.rct_signatures.type')
            
            [ -z "$psql" ] && psql="psql -U $user -d $database -c \"INSERT INTO tx (height, hash, ins, outs, tx_size, fee, tx_version, rct_type) VALUES ($height,'$hash',$ins,$outs,$tx_size,$fee,$tx_version,$rct_type)\"" || psql_append="psql -U $user -d $database -c \"INSERT INTO tx (height, hash, ins, outs, tx_size, fee, tx_version, rct_type) VALUES ($height,'$hash',$ins,$outs,$tx_size,$fee,$tx_version,$rct_type)\""  && psql="$psql\
            $psql_append"
        fi
        
        tx=''
        tx_asjson=''
    done
    
done

eval $psql
psql=''
