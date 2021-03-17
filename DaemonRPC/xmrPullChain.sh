#!/bin/bash

#   VARIABLE CONFIGURATION
# _______________________________________

conf_file='pullChain.conf'  # < Configuration file name

#________________________________________
#_ Pull from conf
. ./$conf_file

#_ GETS CURRENT POSTGRESQL DBHEIGHT
dbheight_command="psql -U $user -d $database -c \"SELECT MAX(height) FROM block\""
dbheight=$(eval $dbheight_command)               # < current db_height
dbheight=$(echo ${dbheight/"(1 row)"})
dbheight=$(echo "${dbheight//[^0-9.]/}")
dbheight=$(expr $dbheight - 1)

#_ GETS CURRENT BLOCKCHAIN HEIGHT
bc_height_url="curl http://127.0.0.1:18081/get_height -H 'Content-Type: application/json'"
bc_height_url="http://$ip:$port/get_height -H 'Content-Type: application/json'"
bc_height_command="curl ${bc_height_url}"
bc_height=$(eval $bc_height_command)
bc_height=$(echo "$bc_height" | jq -r '.height')

loop_s=$(expr $json_s \* $cpu_t)
left=$(expr $bc_height - $dbheight)

if [ $(expr $left % $loop_s) = 0 ]; then
    loops=$(expr $left / $loop_s)
else
    loops=$(expr $left / $loop_s + 1 )
fi

for (( i=0 ; $i<=$loops; i++))
do
    aux=$(expr $i \* $loop_s)
    init=$(expr $dbheight + $aux + 1)
    end=$(expr $init + $loop_s)
           
    bash ./createProcesses.sh $init $end $cpu_t $json_s
done

