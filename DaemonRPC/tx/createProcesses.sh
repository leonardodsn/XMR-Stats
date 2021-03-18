#!/bin/bash

cpu_t=$3
json_s=$4
init=$1
end=$2
conf_file=$5

# echo $cpu_t, $json_s, $init, $end

pids=""

for (( h=0 ; $h < $cpu_t ; h++))
do
    i_height=$(expr $(expr $h \* $json_s) + $init)
    aux=$(expr $h + 1)
    e_height=$(expr $aux \* $json_s + $init - 1)
    
    ./insertRecord.sh $h $i_height $e_height $json_s $conf_file &
    
    pids="$pids $!"

done

wait $pids
