# timemachine-cleanup
Scripts to automatically trim/truncate Apple macOS or OS X Time Machine backups on a network Time Machine volume on macOS Server, and recover freed storage space from the sparsebundles.

Time Machine, by design, will not do any sort of clean up beyond initial trimming of hourly down to daily, and then down to weekly backups. It will then hold the weekly backups until it runs out of space and then begins to remove old weekly backups as needed to perform a current backup. This is not ideal when implementing a shared network Time Machine server and impedes the ability to add new backups as space is filled and not managed further. Though with macOS Server app can  specify quotas for using a shared network volume for Time Machine not all OS X versions respect the setting, and also a maximum age of a backup can not be. These scripts implement that missing feature and also recover the freed space of the deleted backups from the sparsebundles.

# Designed usage
These scripts will
* Search a specified shared directory
* Find Time Machine backup sparse bundles
* Mount each sparsebundle that is accessible (in use or encrypted backups are ignored)
* Check for backups older than the specified tail length from the latest backup (not the current date!)
* Delete backups older than tail length
* Unmount the sparsebundle
* When finshed trimming all available sparsebundles, it will then run a compact operation on them (in use or encrypted backups are ignored)
* Logging to /var/log/timemachine-cleanup{,-err}.log and, if the schedules are kept in near sync, rotate the logs just before beginning another cleanup cycle

# Scheduling the cleanups
Modify the times and/or days as desired in the plist and also the rotation schedule in the newsyslog.d conf file. The plist will run the cleanup script at initial load. If this is not desired then remove the RunAtLoad key from the plist.

As root or via sudo, load the plist with 
> launchctl load /Library/LaunchDaemons/com.riskanalytics.corp.jpruente.timemachine-cleanup.plist
