#!/bin/bash

#Init all processes


bash ./blocks/xmrPullChain.sh &
bash ./tx/xmrPullTx.sh &
bash ./txPool/poolUpdater.sh &
bash ./logs/registerLogs.sh &


#UPDATE FOR FUTURE CLI CLIENT
echo "done"
