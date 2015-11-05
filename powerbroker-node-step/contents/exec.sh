#!/usr/bin/env bash

PBRUN_CMD=${RD_CONFIG_PBRUN_CMD:-pbrun}

# Parse script arguments
USER=$1
shift
HOST=$1
shift
# remaining args are command string to execute.

#
# Set up SSH to invoke via pbrun
#
# Read the key data from environment and save to a temp file.
TMP_SSH_KEYFILE=$(mktemp "/tmp/pbrun-ssh-keyfile.XXXXX")
echo "$RD_CONFIG_TMP_SSH_KEYFILE" > $TMP_SSH_KEYFILE
#    Ssh command flags
SSHOPTS="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o LogLevel=quiet"
SSHOPTS="$SSHOPTS -i $TMP_SSH_KEYFILE"
#    Run it.
ssh $SSHOPTS ${RD_CONFIG_SERVICE_ACCOUNT}@${HOST} $PBRUN_CMD --user ${USER} $@
ssh_exitcode=$?

#
# Clean up and exit
#
rm $TMP_SSH_KEYFILE
exit $ssh_exitcode
#
# Done.
