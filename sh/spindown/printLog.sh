#!/bin/sh

# write_log [fileName] [messages...]
write_log()
{
  # configure
  log_dir="logs"
  log_name="noname"
  filename_auto_complete="enabled"
  date_auto_complete="enabled"
  # filename auto complete
  if [ $# -gt 1 -a $filename_auto_complete = "enabled" ] ; then
    log_name=$1 ; shift
  fi
  # prepare directory
  if [ ! -d ${log_dir} ] ; then
    mkdir -p ${log_dir}
  fi
  # output
  if [ $date_auto_complete = "enabled" ] ; then
    log_dest="${log_dir}/${log_name}$(date '+%y%m%d').log"
  else
    log_dest="${log_dir}/${log_name}.log"
  fi
  echo "${log_dest}> [$(date '+%y%m%d %T')] $@"
  echo "[$(date '+%y/%m/%d %T')] $@" >> ${log_dest}
}

write_log_leveling()
{
  # configure
  log_level=1
  # argument check
  expr $1 + 1 > /dev/null 2>&1
  if [ $? -lt 2 ] ; then
    #logging
    if [ $1 -ge ${log_level} ] ; then
      shift
      write_log $@
    fi
  fi
}

write_log_leveling $@