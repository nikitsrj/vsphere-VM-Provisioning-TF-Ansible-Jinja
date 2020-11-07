#!/bin/bash
# Developed by Nikit Swaraj
#This script generate hostname for the server

#site is mostly Singapore 
site=$1
SITE=${site:0:3}
# env is Production, UAT, SIT, DR  (P/U/S/D)
env=$2
ENV=${env:0:1}
# Location is based on datacenter No 1/2/3 (1)
LOC=$3
# Server type is VM or Physical (V/P)
servertype=$4
SRVTYPE=${servertype:0:1}
# based on OS windows and Linux (W/L)
os=$5
OS=${os:0:1}
# Based on Application or Database or Web (AP/DS/WB)
type=$6
TYPE=${type:0:2}
# Systemcode based on the User entered (COB/SCM)
systemcode=$7
SYSCODE=${systemcode:0:3}
# Based on VM incremental seq no (01/02/03)
sequence=$8
SQNC=${sequence:0:2}

echo "$SITE$ENV$LOC$SRVTYPE$OS$TYPE$SYSCODE$SQNC" | tr [a-z] [A-Z]
