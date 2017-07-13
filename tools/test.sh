#!/bin/bash

backup_start=$(date)
date=$(date +%F)
epoch_seconds=$(date '+%s')
epoch_day=$(echo $epoch_seconds '/60/60/24' | bc -q )
backup_path_number=$(echo $epoch_day "%$backup_path_count" | bc -q )
backup_path=${backup_path_list[$backup_path_number]}
backup_log="$backup_path/log.$date"
backup_path_files="$backup_path/files"

