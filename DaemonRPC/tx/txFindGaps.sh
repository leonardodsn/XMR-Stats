#!/bin/bash
# Search for gaps in block sequence height to guarantee all blocks have been recorded

#   VARIABLE CONFIGURATION
# _______________________________________

conf_file='pullChain.conf'  # < Configuration file name

#________________________________________
#_ Pull from conf
. ../$conf_file

gap_s=$1

#_ GETS CURRENT POSTGRESQL DBHEIGHT
dbheight_command="psql -U $user -d $database -c \"SELECT MAX(height) FROM block\""
dbheight=$(eval $dbheight_command)              
dbheight=$(echo ${dbheight/"(1 row)"})
dbheight=$(echo "${dbheight//[^0-9.]/}")
dbheight=$(expr $dbheight - 1)

gap="true"

while [ "$gap" = "true" ]
do
    gap_search="psql -U $user -d $database -c \"select series, tx.height from generate_series(1, $dbheight, 1) series left join tx on series = tx.height where height is null order by series LIMIT 1\""
    dbgap=$(eval $gap_search)
    dbgap=$(echo ${dbgap/"(1 row)"})
    dbgap=$(echo "${dbgap//[^0-9.]/}")
    dbgap=$(expr $dbgap)

    [[ $dbgap = 0 ]] && gap="false" && echo "no gaps" || ([[ $gap_s < $json_tx_s && $dbgap != 0 ]] && bash ./insertTxRecord.sh $gap $dbgap $(expr $dbgap + 9) 10 $conf_file ) || (bash ./createTxProcesses.sh $dbgap $(expr $dbgap + $(expr $json_s \* $cpu_t ) ) $cpu_t $json_tx_s $conf_file)
done
