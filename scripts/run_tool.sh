#!/bin/sh

[ -z "$1" ] && echo "Usage: ./buildtools_build.sh <view_name>" && exit 1
[ $(basename $(pwd)) != "traq-ios-clone" ] && echo "Please run this script in from project root" && exit 1

./BuildTools/BuildTools/.build/release/$@
