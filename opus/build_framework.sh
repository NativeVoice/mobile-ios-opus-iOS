#!/bin/bash
#
#  build_framework.sh
#  NVSDK
#

set -e

# iOS devices
xcodebuild archive \
    -scheme opus \
    -archivePath "./build/ios.xcarchive" \
    -sdk iphoneos \
    SKIP_INSTALL=NO
# iOS simulator
xcodebuild archive \
    -scheme opus \
    -archivePath "./build/ios_sim.xcarchive" \
    -sdk iphonesimulator \
    SKIP_INSTALL=NO

xcodebuild -create-xcframework \
    -framework "./build/ios.xcarchive/Products/Library/Frameworks/opus.framework" \
    -framework "./build/ios_sim.xcarchive/Products/Library/Frameworks/opus.framework" \
    -output "./build/dist/opus.xcframework"