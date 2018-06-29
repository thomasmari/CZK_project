#!/bin/bash
# This script automatically uploads all necessary files to the server, replacing the old ones. This is how the files on the server are updated.
# The is a hardcoded variable.
# "serverPath" is the path leading to where to upload the files on the target server.
# It needs to be inserted into the script manually (at least the first time or after the path/server changes).
# This script is expected to stay in directory utilityScripts.
serverPath="xuhrik@aisa.fi.muni.cz:/home/xuhrik/public_html"
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
cd "$SCRIPTPATH"
cd ..
if [ ! -d release ]; then 
  echo "Local directory release does not exist."
  exit
fi
scp -prq "index.html" "${serverPath}/index.html"
rsync -avWe ssh --delete-before "release" "${serverPath}"
echo "The server files are now updated."