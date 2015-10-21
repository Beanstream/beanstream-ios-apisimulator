#!/bin/bash
set -e

projectName="BeanstreamAPISimulator"

scriptDir="$(dirname "$0")"
scriptName="$(basename "$0")"
now=$(date +"%y%m%d-%H%M%S")
logDir="$scriptDir/logs"
logName="build.log"
mkdir -p "$logDir"
exec >  >(tee "$logDir/$logName")

echo "Script: $scriptName"
echo "Timestamp: $now"

echo "ProjectName: $projectName"

# Usage
configuration="Release"
if [ "$1" =  "-d" ]; then
	configuration="Debug"
elif [ ! -z "$1" ]; then
	configuration="$1" 
fi
echo "Configuration: $configuration"

# Clean
distDir="dist"
if [ -n "$distDir" ]; then
   echo "Cleaning $distDir..."
   rm -rf "./$distDir"
fi

# Build
cd "$scriptDir/$projectName"
xcodebuild clean
xcodebuild -derivedDataPath . -configuration "$configuration" -scheme UniversalLib
cd -

# Package
distZipDir="$projectName"
zipFile="$projectName-$configuration-$now.zip"
echo "Package files into $distDir..."

mkdir -p "$distDir/$distZipDir"

cp -r "$scriptDir/$projectName/Build/Products/Universal/$projectName/" "$distDir/$projectName"

cd "$distDir"
zip -r "$zipFile" . -i "$distZipDir/*"
cd -

echo "done"

