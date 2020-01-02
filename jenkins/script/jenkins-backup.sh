#!/usr/bin/env bash

# the folder to exclude relative to the source-folder
cd /root/
rsync -av --exclude "workspace" --exclude ".m2" --exclude "caches"  --progress /var/jenkins_home /root/restic-jenkins/

export AWS_ACCESS_KEY_ID= 
export AWS_SECRET_ACCESS_KEY=
export RESTIC_REPOSITORY=s3:http://0.0.0.0:0000/restic-jenkins/
export RESTIC_PASSWORD=

/usr/local/bin/restic backup -q ./restic-jenkins
/usr/local/bin/restic forget -q --prune --keep-hourly 24 --keep-daily 7

