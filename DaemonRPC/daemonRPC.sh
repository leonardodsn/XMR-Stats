#!/bin/bash

#Init all processes

source ./cli.sh
source ./func.sh

bash ./blocks/xmrPullChain.sh &
bash ./tx/xmrPullTx.sh &
bash ./txPool/poolUpdater.sh &
bash ./logs/registerLogs.sh &


#UPDATE FOR FUTURE CLI CLIENT
echo "done"

cli="true"

while [ $cli="true" ]
do

    sleep 60

done
