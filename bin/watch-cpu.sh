#!/usr/bin/env bash

#  Script: watch-cpu.sh
# Purpose: Monitor the cpu usage and generate an alarm when it reaches the threshold.
# Created: Mar 20, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@gmail.com

# Current script version.
VERSION=0.9.0

# This script name.
PROC_NAME="$(basename $0)"

# Help message to be displayed by the script.
USAGE="
Usage: $PROC_NAME [-l Limit=50,50 [%]] [-i Interval=2 [sec]] [-c Count=10 [measures]]

       Limit: % Limit of the CPU,MEM usage to trigger the alarm.
    Interval: Interval of each measurement [seconds].
       Count: Amount of measures, or 0 for continuous measurements.
"

# Purpose: Quit the program and exhibits an exit message if specified.
# @param $1 [Req] : The exit return code.
# @param $2 [Opt] : The exit message to be displayed.
quit() {

    if test -z "$VERBOSE" || test "$VERBOSE" = "" || test "$VERBOSE" != "-q"; then
        if test -n "$2" -o "$2" != ""; then
            echo -e "$2"
        fi
    fi

    exit $1
}

# Usage message.
usage() {
    quit 1 "$USAGE"
}

# Check if the user passed the help parameters.
test "$1" = '-h' -o "$1" = '--help' && usage

# Check if OS is a Linux distribution
test $(uname -s) = "Darwin" && quit 1 "This script is intended to run under linux OS."

CPU_LIMIT="50"
MEM_LIMIT="50"
INTERVAL=1
COUNT=10
CPU_PEAK=0
MEM_PEAK=0

MAIL='mail'
MAILTO=''
MAILCC=''
SUBJECT='No Subject'
MSG='No Message Selected'

# Loop through the command line options.
while test -n "$1"
do
    case "$1" in
        -l)
            shift
            test -z "$1" && quit 1 "Limit value is required !"
            ok=$( echo $1 | sed -r 's_[0-9]+,[0-9]+_OKDOK_' )
            test "$ok" != "OKDOK" && quit 1 "Invalid limit value(s): ($ok). Please use: [0-9]+,[0-9]+ !"
            CPU_LIMIT="$(echo $1 | cut -d ',' -f1)"
            MEM_LIMIT="$(echo $1 | cut -d ',' -f2)"
        ;;
        -i)
            shift
            test -z "$1" && quit 1 "Interval value is required !"
            ok=$( echo $1 | sed -r 's_[0-9]+_OKDOK_' )
            test "$ok" != "OKDOK" && quit 1 "Invalid interval value: ($ok). Only digits accepted !"
            INTERVAL="$1"
        ;;
        -c)
            shift
            test -z "$1" && quit 1 "Count value is required !"
            ok=$( echo $1 | sed -r 's_[0-9]+_OKDOK_' )
            test "$ok" != "OKDOK" && quit 1 "Invalid count value: ($ok). Only digits accepted !"
            COUNT="$1"
        ;;
        
        *)
            quit 1 "Invalid option: \"$1\""
        ;;
    esac
    shift
done

counter=1
f_mail_sent=0

echo "Checking system usage with limits: [ CPU: $CPU_LIMIT, MEM: $MEM_LIMIT every: $INTERVAL] /$COUNT"
echo ' '

while :
do
    
    # Cpu usage first measurement.
    total_jiffies_1=0
    work_jiffies_1=0
    idx=1

    for next in $( grep "cpu " /proc/stat | cut -d' ' -f 3- )
    do
        total_jiffies_1=$((total_jiffies_1+next))
        if test $idx = 1 || test $idx = 2 || test $idx = 3
        then
            work_jiffies_1=$((work_jiffies_1+next))
        fi
        idx=$((idx+1))
    done
    
    # Network usage first measurement.
    rx1=$(cat /sys/class/net/eth0/statistics/rx_bytes)
    tx1=$(cat /sys/class/net/eth0/statistics/tx_bytes)
    
    # Disk I/O usage first measurement.
    dsk_r1=$(awk '{print $1}' /sys/block/xvda/xvda1/stat) # Number of read I/Os processed
    dsk_w1=$(awk '{print $5}' /sys/block/xvda/xvda1/stat) # Number of write I/Os processed
    
    sleep $INTERVAL
    
    # Cpu usage second measurement.
    total_jiffies_2=0
    work_jiffies_2=0
    idx=1
    
    for next in $( grep "cpu " /proc/stat | cut -d' ' -f 3- )
    do
        total_jiffies_2=$(( total_jiffies_2 + next))
        if test $idx = 1 || test $idx = 2 || test $idx = 3
        then
            work_jiffies_2=$((work_jiffies_2+next))
        fi
        idx=$((idx+1))
    done
    
    # Network usage second measurement.
    rx2=$(cat /sys/class/net/eth0/statistics/rx_bytes)
    tx2=$(cat /sys/class/net/eth0/statistics/tx_bytes)
    
    # Disk I/O usage second measurement.
    dsk_r2=$(awk '{print $1}' /sys/block/xvda/xvda1/stat)
    dsk_w2=$(awk '{print $5}' /sys/block/xvda/xvda1/stat)
    
    # Total of Network usage.
    rx_bps=$(( ( rx2 - rx1 ) * 8 / 1024 ))
    tx_bps=$(( ( tx2 - tx1 ) * 8 / 1024 ))
    netw=$((rx_bps + tx_bps))
    
    # Total of Disk usage.
    disk_io=$(bc -l <<< "(($dsk_r2-$dsk_r1) + ($dsk_w2-$dsk_w1))")
    i_disk_io=$(echo $disk_io | sed -r 's_([0-9]*)\.[0-9]*_\1_')
    
    # Total of CPU usage.
    total_over_period=$(( total_jiffies_2 - total_jiffies_1 ))
    work_over_period=$(( work_jiffies_2 - work_jiffies_1 ))
    pcpu=$(bc -l <<< "(($work_over_period / $total_over_period) * 100)" )
    i_pcpu=$(echo $pcpu | sed -r 's_([0-9]*)\.[0-9]*_\1_')
    
    # Total of MEM usage.
    pmem=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    i_pmem=$(echo $pmem | sed -r 's_([0-9]*)\.[0-9]*_\1_')
    
    if test $(echo " $pcpu > $CPU_PEAK" | bc -l) -eq 1
    then
         CPU_PEAK=$pcpu
    fi
    
    if test $(echo " $pmem > $MEM_PEAK" | bc -l) -eq 1
    then
         MEM_PEAK=$pmem
    fi
    
    REPORT_LINE=
    
    echo -en "[$(date +'%D %T') - $counter] "
    echo -en  "DISK(I/O): $(printf '%6d\n' $i_disk_io) [rw/sec] "
    echo -en "NET(Rx-Tx): $(printf '%6d\n' $netw) [kbps] "
    echo -en   "CPU/PEAK: $(printf '%.2f\n' $pcpu)% / $(printf '%.2f\n' $CPU_PEAK)% <A:=$CPU_LIMIT%> "
    echo -en   "MEM/PEAK: $(printf '%.2f\n' $pmem)% / $(printf '%.2f\n' $MEM_PEAK)% <A:=$MEM_LIMIT%> "
    echo ''
    
    if test $((i_pcpu)) -ge $((CPU_LIMIT))
    then
        echo -e "-------------------------------------------------------\a"
        echo  "### CPU ALARM ! LIMIT of $CPU_LIMIT TRESPASSED ###"
        if test "$f_mail_sent" = "0" || test "$f_mail_sent" = "2" # 0: no email sent; 2: mem email sent
        then
            SUBJECT='CPU MONITOR ALARM'
            MSG="### CPU ALARM ! LIMIT of $CPU_LIMIT TRESPASSED: $pcpu%\nWhen: $(date)\n\nTop Consumers:\n--------------------------------\n"
            MSG="$MSG $(ps -eo pcpu,pid,user | sort -r -k1 | head -5)"
            echo -e "$MSG" | $MAIL -s "$SUBJECT" -c "$MAILCC" "$MAILTO"
            echo "Message sent S [$SUBJECT], To <$MAILTO>, CC <$MAILCC>"
        fi
        echo "---------------------------------------------------------"
        test "$f_mail_sent" = "0" && f_mail_sent=1
        test "$f_mail_sent" = "2" && f_mail_sent=3
    fi
    
    if test $((i_pmem)) -ge $((MEM_LIMIT))
    then
        echo -e "-------------------------------------------------------\a"
        echo  "### MEMORY ALARM ! LIMIT of $MEM_LIMIT TRESPASSED ###"
        if test "$f_mail_sent" = "0" || test "$f_mail_sent" = "1" # 0: no email sent; 1: cpu email sent
        then
            SUBJECT='MEMORY MONITOR ALARM'
            MSG="### MEMORY ALARM ! LIMIT of $MEM_LIMIT TRESPASSED: $pmem%\nWhen: $(date)\n\nTop Consumers:\n--------------------------------\n"
            MSG="$MSG $(ps -eo pmem,pid,user | sort -r -k1 | head -5)"
            echo -e "$MSG" | $MAIL -s "$SUBJECT" -c "$MAILCC" "$MAILTO"
            echo "Message sent S [$SUBJECT], To <$MAILTO>, CC <$MAILCC>"
        fi
        echo "---------------------------------------------------------"
        test "$f_mail_sent" = "0" && f_mail_sent=2
        test "$f_mail_sent" = "1" && f_mail_sent=3
    fi

    counter=$((counter+1))
    
    if test "$COUNT" != "0"
    then
         test $((counter)) -gt $((COUNT)) && quit 0
    fi

done

echo ' '

exit 0