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
wait_sync

#_ GETS SIZE OF THE GAP BETWEEN BLOCK HEIGHTS IN DB 
# gap_s=$(gap_size)
# bash ./findGaps.sh $gap_s

#_ GETS CURRENT POSTGRESQL TRANSACTION DBHEIGHT
txheight=$(tx_height)

#_ GETS CURRENT BLOCKCHAIN HEIGHT
bcheight=$(bc_height)

loop_s=$(expr $json_tx_s \* $cpu_t)
left=$(expr $bcheight - $txheight)

[[ $(expr $left % $loop_s) = 0 ]] && loops=$(expr $left / $loop_s) || loops=$(expr $left / $loop_s + 1 )

for (( i=0 ; $i<=$loops; i++))
do
    aux=$(expr $i \* $loop_s)
    init=$(expr $txheight + $aux + 1)
    end=$(expr $init + $loop_s)
           
    bash ./createTxProcesses.sh $init $end $cpu_t $json_tx_s $conf_file
done

bash ./blockUpdater.sh $conf_file
