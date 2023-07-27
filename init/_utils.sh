#!/usr/bin/env bash

source ~/.photon/ui/_main.sh

function title() {
  # clear -x
  echo
  ui_banner "$1"
  echo 

  echo >> $LOG
  echo >> $LOG
  echo $1 >> $LOG
  echo "=========" >> $LOG
  echo >> $LOG
}

function sub() {
  echo
  echo
  # fmt="${txBold} %s${txReset}\n"
  # printf "$fmt" "$1"
  h1 "$1"
  echo

  echo >> $LOG
  echo $1 >> $LOG
  echo "---------" >> $LOG
}

collect_system_metrics() {
    echo "===== System Metrics =====" | tee -a $LOG

    # Disk usage
    echo "Disk usage:" | tee -a $LOG
    df -h . | tee -a $LOG

    # Number of files in the home directory
    echo "Number of files in the home directory:" | tee -a $LOG
    find ~ -type f | wc -l | tee -a $LOG

    # Number of installed packages
    echo "Number of installed packages:" | tee -a $LOG
    dpkg -l | wc -l | tee -a $LOG

    echo "===== End of System Metrics =====" | tee -a $LOG
}


write_installed_packages() {
    stage=$1
    output_file="installed_packages_$stage.txt"
    dpkg -l | tail -n +6 | awk '{print $2}' > $output_file
    echo "Installed packages list saved to $output_file"
}

