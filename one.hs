#!/bin/bash
LOG_DIR="/tmp"
serv=`hostname -s | tr '[:upper:]' '[:lower:]'`
LOG_FILE="$serv-install-nagios.log"
rm -f /$LOG_DIR/$LOG_FILE
#set -x
vg=`pvscan|grep /dev/cciss/c0d0p2|gawk '{print $4}'`
vg1=`pvscan|grep /dev/sda2|gawk '{print $4}'`
vg2=`pvscan|grep /dev/sda3|gawk '{print $4}'`
vg3=`pvscan|grep /dev/sda1|gawk '{print $4}'`
if [ "$vg1" != "" ] || [ "$vg" != "" ] || [ "$vg2" != "" ] || [ "$vg3" != "" ] ;
then
  echo "`hostname` `date '+%d%m%Y:%k:%M'` identification vg ok" >> $LOG_DIR/$LOG_FILE
  echo "`hostname` `date '+%d%m%Y:%k:%M'` identification vg ok" 
else
  echo "`hostname` `date '+%d%m%Y:%k:%M'` identification vg ko" >> $LOG_DIR/$LOG_FILE
  echo "`hostname` `date '+%d%m%Y:%k:%M'` identification vg ko" 
  exit
fi
if [ "$vg" !=  "" ] ;
then
  VG=$vg
fi
if [ "$vg1" !=  "" ] ;
then
  VG=$vg1
fi
if [ "$vg2" !=  "" ] ;
then
  VG=$vg2
fi
if [ "$vg3" !=  "" ] ;
then
  VG=$vg3
fi


truenagios=`ls -l / |grep edcrfv |gawk '{print $9}'`
if [ "$truenagios" != "" ] ;
then 
  nbre=`ls -l /$truenagios|wc -l` 
  if [ $nbre -gt 4 ] ;
  then
    echo "`hostname` `date '+%d%m%Y:%k:%M'` nagios deja installe" >> $LOG_DIR/$LOG_FILE
    echo "`hostname` `date '+%d%m%Y:%k:%M'` nagios deja installe" 
  else
    nbre="0"
  fi
else
  nbre="0"
fi
if [ "$nbre" == "0" ] ;
then
  if (lvdisplay|grep enrpe)
  then
    echo "`hostname` `date '+%d%m%Y:%k:%M'` lv enrpe existe" >> $LOG_DIR/$LOG_FILE
    echo "`hostname` `date '+%d%m%Y:%k:%M'` lv enrpe existe" 
  else
    if (lvcreate -L 350M -n enrpe $VG)
    then
      echo "`hostname` `date '+%d%m%Y:%k:%M'` creation lv ok" >> $LOG_DIR/$LOG_FILE
      echo "`hostname` `date '+%d%m%Y:%k:%M'` creation lv ok" 
    else
      echo "`hostname` `date '+%d%m%Y:%k:%M'` creation lv ko" >> $LOG_DIR/$LOG_FILE
      echo "`hostname` `date '+%d%m%Y:%k:%M'` creation lv ko" 
      exit
    fi
    if (mkfs.ext3 /dev/$VG/enrpe)
    then
      echo "`hostname` `date '+%d%m%Y:%k:%M'` creation fs ok" >> $LOG_DIR/$LOG_FILE
      echo "`hostname` `date '+%d%m%Y:%k:%M'` creation fs ok" 
    else
      echo "`hostname` `date '+%d%m%Y:%k:%M'` creation fs ko" >> $LOG_DIR/$LOG_FILE
      echo "`hostname` `date '+%d%m%Y:%k:%M'` creation fs ko" 
      exit
    fi
  fi
  if (ls -l /edcrfv)
  then
    echo "`hostname` `date '+%d%m%Y:%k:%M'` rep edcrfv existe" >> $LOG_DIR/$LOG_FILE
    echo "`hostname` `date '+%d%m%Y:%k:%M'` rep edcrfv existe" 
  else
    if (mkdir /edcrfv)
    then
      echo "`hostname` `date '+%d%m%Y:%k:%M'` creation rep ok" >> $LOG_DIR/$LOG_FILE
      echo "`hostname` `date '+%d%m%Y:%k:%M'` creation rep ok" 
    else
      echo "`hostname` `date '+%d%m%Y:%k:%M'` creation rep ko" >> $LOG_DIR/$LOG_FILE
      echo "`hostname` `date '+%d%m%Y:%k:%M'` creation rep ko" 
      exit
    fi
  fi
  if (grep enrpe /etc/fstab)
  then
    echo "`hostname` `date '+%d%m%Y:%k:%M'` enrpe fstab existe" >> $LOG_DIR/$LOG_FILE
    echo "`hostname` `date '+%d%m%Y:%k:%M'` enrpe fstab existe"
  else
    if (echo "/dev/$VG/enrpe         /edcrfv                    ext3    defaults        1 2" >> /etc/fstab)
    then
      echo "`hostname` `date '+%d%m%Y:%k:%M'` maj fstab ok" >> $LOG_DIR/$LOG_FILE
      echo "`hostname` `date '+%d%m%Y:%k:%M'` maj fstab ok" 
    else
      echo "`hostname` `date '+%d%m%Y:%k:%M'` maj fstab ko" >> $LOG_DIR/$LOG_FILE
      echo "`hostname` `date '+%d%m%Y:%k:%M'` maj fstab ko" 
      exit
    fi
  fi
  if (grep edcrfv /proc/mounts)
  then
    echo "`hostname` `date '+%d%m%Y:%k:%M'` edcrfv monte existe" >> $LOG_DIR/$LOG_FILE
    echo "`hostname` `date '+%d%m%Y:%k:%M'` edcrfv monte existe" 
  else
    if (mount /edcrfv)
    then
      echo "`hostname` `date '+%d%m%Y:%k:%M'` montage rep ok" >> $LOG_DIR/$LOG_FILE
      echo "`hostname` `date '+%d%m%Y:%k:%M'` montage rep ok" 
    else
      echo "`hostname` `date '+%d%m%Y:%k:%M'` montage rep ko" >> $LOG_DIR/$LOG_FILE
      echo "`hostname` `date '+%d%m%Y:%k:%M'` montage rep ko" 
      exit
    fi
  fi
  if (grep nagios /etc/group)
  then
    echo "`hostname` `date '+%d%m%Y:%k:%M'` group nagios existe" >> $LOG_DIR/$LOG_FILE
    echo "`hostname` `date '+%d%m%Y:%k:%M'` group nagios existe" 
  else
    if (groupadd -g 913 nagios)
    then
      echo "`hostname` `date '+%d%m%Y:%k:%M'` creation groupe ok" >> $LOG_DIR/$LOG_FILE
      echo "`hostname` `date '+%d%m%Y:%k:%M'` creation groupe ok" 
    else
      echo "`hostname` `date '+%d%m%Y:%k:%M'` creation groupe ko" >> $LOG_DIR/$LOG_FILE
      echo "`hostname` `date '+%d%m%Y:%k:%M'` creation groupe ko" 
      exit
    fi
  fi
  if (grep nagios /etc/passwd)
  then
    echo "`hostname` `date '+%d%m%Y:%k:%M'` user nagios existe" >> $LOG_DIR/$LOG_FILE
    echo "`hostname` `date '+%d%m%Y:%k:%M'` user nagios existe" 
  else
    if (useradd -g 913 -u 913 nagios)
    then
      echo "`hostname` `date '+%d%m%Y:%k:%M'` creation user ok" >> $LOG_DIR/$LOG_FILE
      echo "`hostname` `date '+%d%m%Y:%k:%M'` creation user ok" 
    else
      echo "`hostname` `date '+%d%m%Y:%k:%M'` creation user ko" >> $LOG_DIR/$LOG_FILE
      echo "`hostname` `date '+%d%m%Y:%k:%M'` creation user ko" 
      exit
    fi
  fi
  if (echo -e "nagios:nagios" | chpasswd)
  then
    echo "`hostname` `date '+%d%m%Y:%k:%M'` creation pwd ok" >> $LOG_DIR/$LOG_FILE
    echo "`hostname` `date '+%d%m%Y:%k:%M'` creation pwd ok" 
  else
    echo "`hostname` `date '+%d%m%Y:%k:%M'` creation pwd ko" >> $LOG_DIR/$LOG_FILE
    echo "`hostname` `date '+%d%m%Y:%k:%M'` creation pwd ko" 
    exit
  fi
  nbre=`ls -l /edcrfv|wc -l`
  if [ $nbre -gt 4 ] ;
  then
    echo "`hostname` `date '+%d%m%Y:%k:%M'` install nagios existe" >> $LOG_DIR/$LOG_FILE
    echo "`hostname` `date '+%d%m%Y:%k:%M'` install nagios existe" 
  else
    touch /tmp/.debugedcrfv
    if (uname -a|grep x86_64)
    then
      cd /tmp
      if [ -f /etc/redhat-release ] ;
      then
        if (wget http://aqwzsx/depot/LINUX/le/edcrfv-mint-nagios-agent.le-1496-1.x86_64.rpm)
        then
          echo "`hostname` `date '+%d%m%Y:%k:%M'` telechargement enrpe ok" >> $LOG_DIR/$LOG_FILE
          echo "`hostname` `date '+%d%m%Y:%k:%M'` telechargement enrpe ok" 
          rpm -ivh /tmp/edcrfv-mint-nagios-agent.le-1496-1.x86_64.rpm                       
          if (ps -ef|grep enrpe)
          then
            echo "`hostname` `date '+%d%m%Y:%k:%M'` installation nagios ok" >> $LOG_DIR/$LOG_FILE
            echo "`hostname` `date '+%d%m%Y:%k:%M'` installation nagios ok" 
          else
            echo "`hostname` `date '+%d%m%Y:%k:%M'` installation nagios ko" >> $LOG_DIR/$LOG_FILE
            echo "`hostname` `date '+%d%m%Y:%k:%M'` installation nagios ko"
            exit
          fi
        else
          echo "`hostname` `date '+%d%m%Y:%k:%M'` telechargement enrpe ko" >> $LOG_DIR/$LOG_FILE
          echo "`hostname` `date '+%d%m%Y:%k:%M'` telechargement enrpe ok"
          exit
        fi  
      fi
      if [ -f /etc/ian_version ] ;
      then
        if (wget http://aqwzsx/depot/LINUX/ian/edcrfv-mint-nagios-agent.ian_1496-2_amd64.deb)
        then
          echo "`hostname` `date '+%d%m%Y:%k:%M'` telechargement enrpe ok" >> $LOG_DIR/$LOG_FILE
          echo "`hostname` `date '+%d%m%Y:%k:%M'` telechargement enrpe ok"

          dpkg -i /tmp/edcrfv-mint-nagios-agent.ian_1496-2_amd64.deb
          if (ps -ef|grep enrpe)
          then
            echo "`hostname` `date '+%d%m%Y:%k:%M'` installation nagios ok" >> $LOG_DIR/$LOG_FILE
            echo "`hostname` `date '+%d%m%Y:%k:%M'` installation nagios ok"
          else
            echo "`hostname` `date '+%d%m%Y:%k:%M'` installation nagios ko" >> $LOG_DIR/$LOG_FILE
            echo "`hostname` `date '+%d%m%Y:%k:%M'` installation nagios ko"
            exit
          fi
        else
          echo "`hostname` `date '+%d%m%Y:%k:%M'` telechargement enrpe ko" >> $LOG_DIR/$LOG_FILE
          echo "`hostname` `date '+%d%m%Y:%k:%M'` telechargement enrpe ok"
          exit

        fi
      fi
    else
      cd /tmp
      if [ -f /etc/redhat-release ] ;
      then
        if (wget http://aqwzsx/depot/LINUX/le/edcrfv-mint-nagios-agent.le-1496-1.i386.rpm)
        then
          echo "`hostname` `date '+%d%m%Y:%k:%M'` telechargement enrpe ok" >> $LOG_DIR/$LOG_FILE
          echo "`hostname` `date '+%d%m%Y:%k:%M'` telechargement enrpe ok"

          rpm -ivh /tmp/edcrfv-mint-nagios-agent.le-1496-1.i386.rpm                                                     
          if (ps -ef|grep enrpe)
          then
            echo "`hostname` `date '+%d%m%Y:%k:%M'` installation nagios ok" >> $LOG_DIR/$LOG_FILE
            echo "`hostname` `date '+%d%m%Y:%k:%M'` installation nagios ok"
          else
            echo "`hostname` `date '+%d%m%Y:%k:%M'` installation nagios ko" >> $LOG_DIR/$LOG_FILE
            echo "`hostname` `date '+%d%m%Y:%k:%M'` installation nagios ko"
            exit
          fi
        else
          echo "`hostname` `date '+%d%m%Y:%k:%M'` telechargement enrpe ko" >> $LOG_DIR/$LOG_FILE
          echo "`hostname` `date '+%d%m%Y:%k:%M'` telechargement enrpe ok"
          exit

        fi
      fi
      if [ -f /etc/ian_version ] ;
      then
        if (wget http://aqwzsx/depot/LINUX/ian/edcrfv-mint-nagios-agent.ian_1496-2_i386.deb)
        then
          echo "`hostname` `date '+%d%m%Y:%k:%M'` telechargement enrpe ok" >> $LOG_DIR/$LOG_FILE
          echo "`hostname` `date '+%d%m%Y:%k:%M'` telechargement enrpe ok"

          dpkg -i /tmp/edcrfv-mint-nagios-agent.ian_1496-2_i386.deb
          if (ps -ef|grep enrpe)
          then
            echo "`hostname` `date '+%d%m%Y:%k:%M'` installation nagios ok" >> $LOG_DIR/$LOG_FILE
            echo "`hostname` `date '+%d%m%Y:%k:%M'` installation nagios ok"
          else
            echo "`hostname` `date '+%d%m%Y:%k:%M'` installation nagios ko" >> $LOG_DIR/$LOG_FILE
            echo "`hostname` `date '+%d%m%Y:%k:%M'` installation nagios ko"
            exit
          fi
        else
          echo "`hostname` `date '+%d%m%Y:%k:%M'` telechargement enrpe ko" >> $LOG_DIR/$LOG_FILE
          echo "`hostname` `date '+%d%m%Y:%k:%M'` telechargement enrpe ok"
          exit

        fi
      fi

    fi
  fi
fi
