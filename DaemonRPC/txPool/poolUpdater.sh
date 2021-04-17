#!/bin/bash

#   VARIABLE CONFIGURATION
# _______________________________________
DIR=$(eval "dirname $(eval realpath $0)")
# cd $DIR
# echo $dir

conf_file='pullChain.conf'  # < Configuration file name

#________________________________________
#_ Pull from conf
. ../$conf_file

source ../func.sh
source ./poolFunc.sh
wait_sync

#_ GETS CURRENT BLOCKCHAIN HEIGHT
bcheight_1=$(bc_height)
poolUpdate="true"

while [[ "$poolUpdate" = "true" ]]
do
    bcheight_0=$(bc_height)
    
    [[ $bcheight_0 != $bcheight_1 ]] && wipe_tx_pool
    
    update_pool
    
    sleep 5 && bcheight_1=$(bc_height)
done
