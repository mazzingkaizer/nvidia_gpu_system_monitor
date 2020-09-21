#!/bin/bash

GPU_NUM=0

if [ "$#" -eq  "0" ]
  then
    GPU_NUM=0  #if first argument not exist, set to see GPU 0
  else
    GPU_NUM=$1 #if first argument exist, set to see GPU NUMBER
fi

while true; do
#GPU RATIO
GPU_STAT=`nvidia-smi --query-gpu=index,timestamp,power.draw,temperature.gpu,utilization.gpu,memory.total,memory.free,memory.used,pstate --format=csv |head -$((GPU_NUM+2))|tail -1`
TIMESTAMP=`echo $GPU_STAT|awk -F", " '{print $2}'`
GPU_VAL=`echo $GPU_STAT|awk -F", " '{print $1" "$3" "$4" "$5" "$6" "$7" "$8" "$9}'`

#MEMORY RATIO
MEMORY_TOTAL=`free | grep ^Mem | awk '{print $2}'`
MEMORY_USED=`free | grep ^Mem | awk '{print $3}'`
MEMORY_PERCENT=$((100*MEMORY_USED/MEMORY_TOTAL))

#CPU RATIO
CPU_PERCENT=`top -b -n 1 | grep -i cpu\(s\)| awk -F, '{print $4}' | tr -d "%id," | awk '{print 100-$1}'`

#DISK RATIO
DISK_TOTAL=`df -P | grep -v ^Filesystem | awk '{sum += $2} END { print sum; }'`
DISK_USED=`df -P | grep -v ^Filesystem | awk '{sum += $3} END { print sum; }'`
DISK_TOTAL_F=`echo $DISK_TOTAL | awk -F"E" 'BEGIN{OFMT="%10.10f"} {print $1 * (10 ^ $2)}'`
DISK_PERCENT=$(bc <<<"100*$DISK_USED/$DISK_TOTAL_F")

echo $TIMESTAMP" MEMORY : "$MEMORY_PERCENT " CPU : "$CPU_PERCENT " DISK : " $DISK_PERCENT " GPU : " $GPU_VAL
sleep 1
done

