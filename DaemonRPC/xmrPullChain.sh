#!/bin/bash

#   VARIABLE CONFIGURATION
# _______________________________________

conf_file='pullChain.conf'  # < Configuration file name

#________________________________________
#_ Pull from conf

database='xmrstats'         # < Your PostgreSQL database name
user='lsa'                  # < Your PostgreSQL user name
ip='127.0.0.1'              # < monerod (Monero Daemon) IP
port='18081'                # < monerod (Monero Daemon) port
json_s=100                  # < size of json in blocks, in doubt leave default
cpu_t=8                    # < amount of cpu threads

#_ CALCULAR

dbheight=1                  # < current db_height
cheight=2313585             # < current block chain height

loop_s=$(expr $json_s \* $cpu_t)
left=$(expr $cheight - $dbheight)

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

