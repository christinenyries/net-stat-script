#!/usr/bin/bash

# ==================================================================
# Records internet status and log them to a file
# Log includes timestamp, internet status, and duration
#
# e.g. 21:51:11 Internet Status: NOK, Duration: 00:00:45
# =================================================================


# Log directory where records of internet status is saved
# Found in folder named `log` in this script's current directory 
log_dir=$(dirname $0)/log

# Filename of recorded internet status postfixed by current date
log_file="internet_status_$(date +'%F').log"

function prepare_log_file () {
     # Create `log_dir` if it doesn't exist yet
     if [ ! -d $log_dir ]; then
          mkdir $log_dir
          echo "Created $log_dir"
     fi

     # Check if `log_file` already exist
     if [ -e $log_dir/$log_file ]; then
          echo "Log file '$log_file' already exists. Will just append"
     fi
}

function beep () {
     echo -ne '\007'
}

function start_recording () {
     echo "$(date +%T) Started recording..." | tee -a $log_dir/$log_file
     
     local net_stat_curr="OK"
     local net_stat_prev="OK"
     local start_time=$(date +%s)
     local end_time

     # Check if we have an internet. Stop only if user interrupts this script
     while true
     do
          # If `google.com` is pinged successfully, then internet is OK else NOK
          ping -c 1 "google.com" > /dev/null 2>&1
          if [ $? == 0 ]; then
               net_stat_curr="OK"
          else
               net_stat_curr="NOK"
          fi
          
          # If no change to internet status, sleep for five seconds before 
          # checking again else log change to file
          if [ "$net_stat_curr" == "$net_stat_prev" ]; then
               sleep 5
          else
               # Make a sound to notify user about change in internet status
               beep

               # Time previous internet status ended
               end_time=$(date +%s)

               # Log how long previous internet status lasted
               net_stat_prev_duration=$(date -d@$(($end_time - $start_time)) -u +%H:%M:%S)
               echo "$(date +'%T') Internet Status: $net_stat_prev", Duration: ${net_stat_prev_duration} | tee -a $log_dir/$log_file

               # Log start of current internet status
               echo "$(date +'%T') Internet Status: $net_stat_curr" | tee -a $log_dir/$log_file

               # Time current internet status started
               start_time=$(date +%s)

               # Set current internet status to previous for next loop iteration
               net_stat_prev=$net_stat_curr
          fi
     done
}

function stop_recording () {
     echo "$(date +%T) Stopped recording..." | tee -a $log_dir/$log_file
     echo "See logs in $log_dir/$log_file"
     exit 0
}
trap stop_recording SIGINT

prepare_log_file
start_recording
