#!/bin/bash
# Run the two scripts to trim old backups and free unused space from sparsebundles
# JPruente last modified 2017-02-10
date +%Y%m%d-%H%M
df
/var/root/bin/timemachine-trim.sh
/var/root/bin/timemachine-compact.sh
df
date +%Y%m%d-%H%M
