# timemachine-cleanup
Scripts to automatically trim/truncate Time Machine backups and recover storage space from the sparsebundles

# Designed usage
These scripts will
* Search a specified shared directory
* Find Time Machine backup sparse bundles
* Mount each sparsebundle that is accessible, in use or encrypted backups are ignored
* Check for backups older than the specified tail length
* Delete backups older than tail length
* Unmount the sparsebundle
* When finshed, it will then run a compact operation on each sparsebundle
* Log to /var/log/timemachine-cleanup and, as scheduled, rotate the logs just before beginning another cleanup cycle
