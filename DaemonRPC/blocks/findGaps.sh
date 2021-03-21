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
dbheight=$(eval $dbheight_command)               # < current db_height
dbheight=$(echo ${dbheight/"(1 row)"})
dbheight=$(echo "${dbheight//[^0-9.]/}")
dbheight=$(expr $dbheight - 1)

#_ GETS CURRENT BLOCKCHAIN HEIGHT
bc_height_url="http://$ip:$port/get_height -H 'Content-Type: application/json'"
bc_height_command="curl ${bc_height_url}"
bc_height=$(eval $bc_height_command)
bc_height=$(echo "$bc_height" | jq -r '.height')

gap_search="psql -U $user -d $database -c \"select series, block.height FROM generate_series(1, $dbheight, 1) series LEFT JOIN block ON series = block.height WHERE height is null ORDER BY series LIMIT 1\""
dbgap=$(eval $gap_search)

echo $dbgap
