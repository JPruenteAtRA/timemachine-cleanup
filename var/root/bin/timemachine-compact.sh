#!/bin/bash
#
# Step through each backup sparsebundle and run an hdiutil compact on them
# JPruente last modified 2017-02-10

tmdir="/Volumes/Path-To-Your-TM-Share/Shared Items/Backups/"

echo "$(ls -1 "${tmdir}" | grep -v "^\..*")" | while read i
do
    echo ${i}
    if [ "$( hdiutil isencrypted "${tmdir}${i}" 2>&1 )" == "encrypted: NO" ]
    then
        hdiutil compact "${tmdir}${i}" 2>&1
    else
        echo "Backup is encrypted, skipping..."
    fi
done
