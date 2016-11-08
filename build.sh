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

podspec="$scriptDir/BeanstreamAPISimulator.podspec"
echo "podspec: $podspec"

version=$(grep '\.version.*=' "$podspec" | sed -n "s/.*=[^0-9]*\([0-9]*\.[0-9]*\.[0-9]*[0-9A-Za-z-]*\).*/\1/p")
echo "version: $version"
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
echo "Package..."
echo "-----------------------------"
archiveDir="APISimulator"
archiveFile="$distDir/BeanstreamAPISimulator-$version.tar.gz"

mkdir -p $distDir/

export COPYFILE_DISABLE=true
tar -cvzf --exclude=APISimulator/Info.plist -f $archiveFile $archiveDir/** "$podspec"

echo "done"
