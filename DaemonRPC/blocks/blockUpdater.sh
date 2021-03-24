#!/bin/bash
#Pulls from Daemon every 10 second to update for new blocks

conf_file=$1
#________________________________________
#_ Pull from conf
. ../$conf_file

source ../func.sh

while [ "$update" = "true" ]
do
    dbheight=$(db_height)
    bcheight=$(bc_height)
    
    [[ $bcheight > $(expr $dbheight + 1) ]] && new_height=$(expr $dbheight + 1) && bash ./insertRecord.sh 1 $new_height $new_height 1 $conf_file && echo "New block found" || sleep 20
    
done
