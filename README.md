# timemachine-cleanup
Scripts to automatically trim/truncate Time Machine backups and recover storage space from the sparsebundles

# Designed usage
These scripts will
* Search a specified shared directory
* Find Time Machine backup sparse bundles
* Mount each sparsebundle that is accessible, in use or encrypted backups are ignored
* Check for backups older than the specified tail length from the latest backup (not the current date!)
* Delete backups older than tail length
* Unmount the sparsebundle
* When finshed trimming all available sparsebundles, it will then run a compact operation on them
* Logging to /var/log/timemachine-cleanup{,-err}.log and, if the schedules are kept in near sync, rotate the logs just before beginning another cleanup cycle

# Scheduling the cleanups
Modify the times and/or days as desired in the plist. The script will run at initial load. If this is not desired then remove the RunAtLoad key from the plist.

As root or via sudo, load the plist with 
> launchctl load /Library/LaunchDaemons/com.riskanalytics.corp.jpruente.timemachine-cleanup.plist
