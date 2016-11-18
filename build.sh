#!/bin/bash
set -e
scriptDir="$(dirname "$0")"
scriptName="$(basename "$0")"
now=$(date +"%y%m%d-%H%M%S")
logDir="$scriptDir/logs"
logName="build.log"
mkdir -p "$logDir"
exec >  >(tee "$logDir/$logName")

echo
echo "-----------------------------"
echo "Script: $scriptName"
echo "Time: $now"
echo "-----------------------------"
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

echo "-----------------------------"
echo "Clean..."
echo "-----------------------------"
distDir="$scriptDir/dist"
if [ -n "$distDir" ]; then
   echo "Cleaning $distDir..."
   rm -rf "./$distDir"
fi
echo

echo "-----------------------------"
echo "Packaging..."
echo "-----------------------------"

archiveFile="$specName-$specVersion.tar.gz"
echo "Archive file: $archiveFile"

distArchiveDir="APISimulator"

mkdir -p $distDir/$distArchiveDir

cp -r $scriptDir/$distArchiveDir/ $distDir/$distArchiveDir/
cp $scriptDir/$podspec $scriptDir/$distDir/

cd $scriptDir/$distDir
export COPYFILE_DISABLE=true
tar -cvzf --exclude=$distArchiveDir/Info.plist -f $archiveFile $distArchiveDir/** $podspec
cd -

echo "done"
echo

