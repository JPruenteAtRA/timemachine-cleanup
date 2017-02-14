#!/bin/bash
#
# Step through each backup sparsebundle and run an hdiutil compact on them
# JPruente last modified 2017-02-14

tmdir="/Volumes/Path-To-Your-TM-Share/Shared Items/Backups/"

echo "$(ls -1 "${tmdir}" | grep -v "^\..*")" | while read i
do
    echo ${i}
    isencout="$( hdiutil isencrypted "${tmdir}${i}" 2>&1 | tail -n 1 )"
    if [ "${isencout}" == "encrypted: NO" ]
    then
        hdiutil compact "${tmdir}${i}" 2>&1
    else
        echo "Skipping: ${isencout}"
    fi
done
