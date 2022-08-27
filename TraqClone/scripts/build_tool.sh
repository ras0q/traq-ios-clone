#!/bin/sh

[ -z "$1" ] && echo "Usage: ./buildtools_build.sh <view_name>" && exit 1
[ $(basename $(pwd)) != "TraqClone" ] && echo "Please run this script in TraqClone" && exit 1

SDKROOT=(xcrun --sdk macosx --show-sdk-path)
swift build -c debug --product $1
