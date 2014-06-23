#!/bin/sh

FIJI=ImageJ-linux64
MEM=8192m

if [ $# -ne 4 ] ; then
  echo "Invalid number of parameters"
  exit 1
fi

prefs="$1"
source="$2"
results="$3"
timestamp="$4"

PREFS="/tmp/Eyesis_Correction_$timestamp.xml"
LOGFILE="/tmp/Eyesis_Correction_$timestamp.log"
PIDFILE="/tmp/Eyesis_Correction_$timestamp.pid"
RETFILE="/tmp/Eyesis_Correction_$timestamp.ret"

if ! corrxml.sh "$prefs" "$source" "$PREFS" ; then
  echo corrxml.sh failed
  exit 1
fi

(
    $FIJI --headless --allow-multiple --mem $MEM --run Eyesis_Correction "$PREFS" > "$LOGFILE" 2>&1 & FIJI_PID=$!
    echo $FIJI_PID > "$PIDFILE"
    wait $FIJI_PID
    echo $? > "$RETFILE"
) &

exit 0



