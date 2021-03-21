#!/bin/bash
# Search for gaps in block sequence height to guarantee all blocks have been recorded

#   VARIABLE CONFIGURATION
# _______________________________________

conf_file='pullChain.conf'  # < Configuration file name

#________________________________________
#_ Pull from conf
. ../$conf_file

#_ GETS CURRENT POSTGRESQL DBHEIGHT
dbheight_command="psql -U $user -d $database -c \"SELECT MAX(height) FROM block\""
dbheight=$(eval $dbheight_command)              
dbheight=$(echo ${dbheight/"(1 row)"})
dbheight=$(echo "${dbheight//[^0-9.]/}")
dbheight=$(expr $dbheight - 1)

gap="true"

while [ "$gap" = "true" ]
do
    gap_search="psql -U $user -d $database -c \"select series, block.height FROM generate_series(1, $dbheight, 1) series LEFT JOIN block ON series = block.height WHERE height is null ORDER BY series LIMIT 1\""
    dbgap=$(eval $gap_search)
    dbgap=$(echo ${dbgap/"(1 row)"})
    dbgap=$(echo "${dbgap//[^0-9.]/}")
    dbgap=$(expr $dbgap)

    [[ $dbgap = 0 ]] && gap="false" && echo "end of gap" || bash ./insertRecord.sh $gap $dbgap $dbgap 1 $conf_file
done
