#!/bin/bash
set -e
scriptDir="$(dirname "$0")"
scriptName="$(basename "$0")"
now=$(date +'%s')
timeFormat='%Y-%m-%d %H:%M:%S'

logDir="$scriptDir/logs"
logName="$scriptName.log"
mkdir -p "$logDir"
exec >  >(tee "$logDir/$logName")

if [ ! -d "$scriptDir/dist" ]; then
    echo "ERROR: $scriptDir/dist does not exist..."
    echo
    exit 1
fi
pushd "$scriptDir/dist"

echo
echo "-----------------------------"
echo "Script: $scriptName"
echo $(date +"$timeFormat")
echo "-----------------------------"
echo

usage="Usage: $scriptName [--dev|--local|--public]"

if [ $# -ne 1 ]; then
    echo "$usage"
    echo
    exit 1
fi

echo "-----------------------------"
echo "Getting publishing mode..."
echo $(date +"$timeFormat")
echo "-----------------------------"

modeLocal="local"
modePrivate="private"
modePartner="partner"

libraryPath='$(PODS_ROOT)/Beanstream.SDK/Beanstream.SDK'

while getopts ":dlp --long dev local partner" opt; do
    case $opt in
    d|-dev)
        mode="$modePrivate"
        ;;
    l|-local)
        mode="$modeLocal"
        ;;
    p|-partner)
        mode="$modePartner"
        ;;
    *)
        echo "ERROR: Invalid option: -$OPTARG"
        echo "$usage"
        echo
        exit 1
        ;;
  esac
done
echo "mode: $mode"
echo

echo "-----------------------------"
echo "Updating podspec..."
echo $(date +"$timeFormat")
echo "-----------------------------"
echo

# get archive
archive=$(ls $PWD/*.tar.gz)

if [ ! -f "$archive" ]; then
    echo "ERROR: $archive does not exist..."
    echo
    exit 1
fi

# extract archive
echo "extracting $archive..."

tempDir="temp"
mkdir -p "$tempDir"
rm -rvf "./$tempDir/*"

tar --extract -zf $archive -C "$tempDir"
echo
pushd $tempDir

echo

# get podspec
podspec="BeanstreamAPISimulator.podspec"
echo "podspec: $podspec"

if [ ! -f "$podspec" ]; then
    echo "ERROR: podspec does not exist..."
    echo
    exit 1
fi
echo

# update podspec

# replace beanstream-partner
echo "replacing beanstream-partner with beanstream-$mode..."
sed -i '' -e "s/beanstream-[a-zA-Z]*/beanstream-$mode/g" "$podspec"

echo

# create archive
echo "rebuilding archive..."
export COPYFILE_DISABLE=true
tar -czf $archive ./*
rm -rf ./*
echo

popd
echo

if [ "$mode" != "$modeLocal" ]; then
    echo "-----------------------------"
    echo "Publishing..."
    echo $(date +"$timeFormat")
    echo "-----------------------------"
    echo

    artifactoryUrl="https://beanstream.jfrog.io/beanstream"

    # Getting username/password..."
    netrcFile="$HOME/.netrc"
    if [ ! -f $netrcFile ]; then
       echo "ERROR: $netrcFile does not exist."
       echo
       Exit 1
    fi

    username=$(grep 'login ' "$netrcFile" | sed -e "s/.*login \(.*\)/\1/")
    password=$(grep 'password ' "$netrcFile" | sed -e "s/.*password \(.*\)/\1/")

    curl -u$username:$password -X PUT $artifactoryUrl/beanstream-$mode/$(basename "$archive") -T $archive
fi

echo

echo "-----------------------------"
echo $(date +"$timeFormat")
echo "-----------------------------"
echo

popd
