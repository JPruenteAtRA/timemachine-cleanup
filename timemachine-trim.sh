#/bin/bash
#
# Cycle through the TimeMachine backups on a shared volume, mount them and trim the backup to the specified months of tail length of time.
# JPruente last modified 2017-02-10

# Where we store the shared backup folder.
tmdir="/Volumes/Path-To-Your-TM-Share/Shared Items/Backups/"

# How long will the backup tail be since the latest backup?
monthstokeep=6

ls -1 "${tmdir}" | grep -v '^\..*' | while read tmbundle; do
    diskmount=""
    volmount=""
    backupdir=""

    echo ${tmdir}${tmbundle}

    # Test if the bundle is encrypted, if so skip so we don't hang at a passphrase prompt.
    [ "$( hdiutil isencrypted "${tmdir}${tmbundle}" 2>&1 | grep "encrypted" )" == "encrypted: YES" ] && \
         echo "Backup is encrypted, skipping..." && \
         continue

    # Try to mount the sparsebundle
    output="$(hdiutil attach "${tmdir}${tmbundle}" 2>&1 )"

    # If the bundle mounted, grab the device it attached as
    # Only works if 10 or fewer device mounts are created, eg. /dev/diskX Need to fix the regex to support /dev/diskXX or what-have-you
    # In most cases only supporting single digit device names is fine
    [[ "${output}" == /dev/disk[0-9]* ]] && \
        diskmount=$( echo ${output} | sed 's:^\(/dev/disk[0-9]\).*:\1:' ) && \
        echo "${diskmount}"

    # If a device was attached, find where it was mounted.
    [ -e "${diskmount}" ] && [ -b "${diskmount}" ] && [[ "${output}" == *Volumes* ]] && \
        volmount=$( echo ${output} | grep Volumes | sed 's:^.*\(/Volumes/.*\):\1:')

    # If the volume was mounted, build the backup directory location and the location of the Latest backup symlink
    [ -e "${volmount}" ] && [ -d "${volmount}" ] && [[ "${volmount}" == /Volumes/* ]] && \
        backupdir="${volmount}/Backups.backupdb/$( echo ${tmbundle} | sed 's/\(.*\).sparsebundle/\1/')" && \
        latestdir="${backupdir}/Latest"

    # If the latestdir symlink is valid, find every backup that is older than ${monthstokeep} months than it is.
    [ -e "${latestdir}" ] && [ -L "${latestdir}" ] && \
        echo "Delete, beyond tail:" && \

        # Generate the date to check from where the Latest symlink points, uses the -f option of Mac OS/BSD date command to specify input format
        latest="$(date -j -v-${monthstokeep}m -f %Y-%m-%d-%H%M%S $( readlink "${latestdir}" ) +%Y-%m-%d-%H%M%S)" && \

        # Step through each backup name in the expected format and if it is old enough, delete it (or just say we should for testing)
        {
            ls -1 "${backupdir}" | grep '^[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}-[0-9]\{6\}$' | while read i
                do if [ "${i}" \< "${latest}" ]
                    then
                        # echo ${backupdir}/${i}
                        tmutil delete "${backupdir}/${i}"
                    fi
                done
        }

    # Try to eject the device, sometimes it fails, so loop until it is gone.
    while [ -e "${diskmount}" ]; do
        [ -b "${diskmount}" ] && \
            diskutil eject ${diskmount}
    done
done
