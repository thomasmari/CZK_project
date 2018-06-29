#!/bin/bash
# First argument is the name of the new model to release.
# If the model was already released before, updates "release" directory of the model in release (excluding the .png preview, which needs to be updated manually).
# If the model was not released yet, creates "release" directory of the model in release (excluding the .png preview, which needs to be added manually).
if [ -z "${1}" ]; then
    echo "The model must have a name. The first command line variable is the model name."
	exit
fi
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
cd "$SCRIPTPATH"
cd ..
if [ ! -d devel ]; then 
  echo "Directory devel does not exist."
  exit
fi
if [ ! -d "devel/${1}" ]; then 
  echo "Directory devel/${1} does not exist."
  exit
fi
if [ ! -d release ]; then 
  echo "Directory devel does not exist."
  exit
fi
if [ -d "release/${1}" ]; then
  rm "release/${1}/${1}.zip"
  mkdir "release/${1}/${1}"
  cp -R "devel/${1}/." "release/${1}/${1}"
  cp "devel/${1}/${1}README.txt" "release/${1}/${1}README.txt"
  cd "release/${1}"
  zip -rq "${1}.zip" "${1}"
  rm -rf "${1}"
  
  echo "Updated a folder release/${1} (excluding the preview, which needs to be added manually!)."
  echo "If needed, please update the .png preview picture. It must be named ${1}PIC.png"
  exit
fi
if [ ! -d "release/${1}" ]; then 
  mkdir "release/${1}"
  cp -R "devel/${1}/." "release/${1}"/
  cd "release"
  zip -rq "${1}/${1}.zip" "${1}"
  rm "${1}/${1}.xpn"
  rm "${1}/${1}.pm"
  touch "${1}/${1}.html"
  
  echo "<html>" >> "${1}/${1}.html"
  echo "<head>" >> "${1}/${1}.html"
  echo "</head>" >> "${1}/${1}.html"
  echo "<body>" >> "${1}/${1}.html"
  echo "<strong>${1}</strong> :&nbsp;download <a href=\"https://www.fi.muni.cz/~xuhrik/release/${1}/${1}.zip\" target=\"_blank\">here</a><br>" >> "${1}/${1}.html"
  echo "<br>" >> "${1}/${1}.html"
  echo "<iframe align=\"left\" frameborder=0 height=700 scrolling=\"no\" src=\"https://www.fi.muni.cz/~xuhrik/release/${1}/${1}README.txt\" width=700> </iframe>" >> "${1}/${1}.html"
  echo "<br>" >> "${1}/${1}.html"
  echo "<br>" >> "${1}/${1}.html"
  echo "<iframe align=\"left\" frameborder=0 height=1000 scrolling=\"no\" src=\"https://www.fi.muni.cz/~xuhrik/release/${1}/${1}PIC.png\" width=1000> </iframe>" >> "${1}/${1}.html"
  echo "</body>" >> "${1}/${1}.html"
  echo "</html>" >> "${1}/${1}.html"
  
  echo "Created a folder release/${1} (excluding the preview, which needs to be added manually!)."
  echo "Please add the .png preview picture. It must be named ${1}PIC.png"
  exit
fi
