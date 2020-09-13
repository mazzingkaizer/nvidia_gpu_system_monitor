#!/bin/sh

while true; do
#MEMORY 사용율
MEMORY_TOTAL=`free | grep ^Mem | awk '{print $2}'`
MEMORY_USED=`free | grep ^Mem | awk '{print $3}'`
MEMORY_PERCENT=$((100*MEMORY_USED/MEMORY_TOTAL))

#CPU 사용율
CPU_PERCENT=`top -b -n 1 | grep -i cpu\(s\)| awk -F, '{print $4}' | tr -d "%id," | awk '{print 100-$1}'`

#DISK 사용율
DISK_TOTAL=`df -P | grep -v ^Filesystem | awk '{sum += $2} END { print sum; }'`
DISK_USED=`df -P | grep -v ^Filesystem | awk '{sum += $3} END { print sum; }'`
DISK_PERCENT=$((100*$DISK_USED/$DISK_TOTAL))

GPU_STAT=`nvidia-smi --query-gpu=index,timestamp,power.draw,temperature.gpu,utilization.gpu,memory.total,memory.free,memory.used,pstate --format=csv |tail -1`
TIMESTAMP=`echo $GPU_STAT|awk -F", " '{print $2}'`
GPU_VAL=`echo $GPU_STAT|awk -F", " '{print $1" "$3" "$4" "$5" "$6" "$7" "$8" "$9}'`

echo $TIMESTAMP" MEMORY : "$MEMORY_PERCENT " CPU : "$CPU_PERCENT " DISK : " $DISK_PERCENT " GPU : " $GPU_VAL
sleep 1
done
