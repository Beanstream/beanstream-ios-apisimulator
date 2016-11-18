#!/bin/bash
#setup script
set -e
scriptDir="$(dirname "$0")"
scriptName="$(basename "$0")"

pushd $scriptDir

#log
now=$(date +"%y%m%d-%H%M%S")
logDir="$scriptDir/logs"
logName="$scriptName.log"
mkdir -p "$logDir"
exec > >(tee "$logDir/$logName")

echo
echo "-----------------------------"
echo "Script: $scriptName"
echo "Time: $now"
echo "-----------------------------"
echo

if [ $# -ne 1 ]; then
    echo "Usage: $scriptName [--public|--dev]"
    echo
    exit 1
fi

echo "-----------------------------"
echo "Getting target repo..."
echo "-----------------------------"
artifactoryUrl="https://beanstream.jfrog.io/beanstream"
while getopts ":dp --long public dev" opt; do
    case $opt in
    p|-public)
        repoToTarget="$artifactoryUrl/beanstream-public"
        ;;
    d|-dev)
        repoToTarget="$artifactoryUrl/beanstream-private"
        ;;
    \?|dp|pd)
        echo "Invalid option: -$OPTARG"
        echo "Usage: $scriptName [--public|--dev]"
        echo
        exit 1
        ;;
  esac
done
echo "repoToTarget: $repoToTarget"
echo

echo "-----------------------------"
echo "Getting podspec version..."
echo "-----------------------------"

podspec="BeanstreamAPISimulator.podspec"
echo "podspec: $podspec"

cd "$scriptDir"
specName=$(grep '\.name.*=' "$podspec" | sed -n "s/.*= *[[:punct:]]\(.*\)[[:punct:]] */\1/p")
specVersion=$(grep '\.version.*=' "$podspec" | sed -n "s/.*= *[[:punct:]]\(.*\)[[:punct:]] */\1/p")
cd -

echo "specName: $specName"
echo "specVersion: $specVersion"
echo

# -----------------------------
# Getting username/password..."
# -----------------------------

netrcFile="$HOME/.netrc"
if [ ! -f $netrcFile ]; then
   echo "$netrcFile does not exist."
   Exit 1
fi

username=$(grep 'login ' "$netrcFile" | sed -e "s/.*login \(.*\)/\1/")
password=$(grep 'password ' "$netrcFile" | sed -e "s/.*password \(.*\)/\1/")

echo "-----------------------------"
echo "Publishing..."
echo "-----------------------------"

archiveFile="$specName-$specVersion.tar.gz"
echo "Archive file: $archiveFile"
echo

curl -u$username:$password -X PUT $repoToTarget/$fileToPublish -T dist/$archiveFile

echo

echo "-----------------------------"
echo

popd
