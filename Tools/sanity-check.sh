#!/bin/sh

##
##  sanity-check.sh
##  DSFSparklines
##
##  Created by Darren Ford on 26/2/21.
##  Copyright © 2021 Darren Ford. All rights reserved.
##
##  MIT license
##
##  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
##  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
##  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
##  permit persons to whom the Software is furnished to do so, subject to the following conditions:
##
##  The above copyright notice and this permission notice shall be included in all copies or substantial
##  portions of the Software.
##
##  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
##  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
##  OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
##  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
##

# A simple script to build all the supported platforms to make sure I havent overlooked an issue on one of them.

pushd .

cd ..

echo "Cleaning builds..."

swift package clean

##
## iOS versions
##
echo "Building iOS targets..."

# Simulator
xcrun swift build -Xswiftc "-sdk" -Xswiftc "`xcrun --sdk iphonesimulator --show-sdk-path`" -Xswiftc "-target" -Xswiftc "x86_64-apple-ios11-simulator"
# Latest iOS arm64
xcrun swift build -Xswiftc "-sdk" -Xswiftc $(xcrun --sdk iphoneos --show-sdk-path) -Xswiftc "-target" -Xswiftc "arm64-apple-ios`xcrun --sdk iphoneos --show-sdk-version`"
# Earliest iOS
xcrun swift build -Xswiftc "-sdk" -Xswiftc $(xcrun --sdk iphoneos --show-sdk-path) -Xswiftc "-target" -Xswiftc "arm64-apple-ios11"

##
## macOS versions
##
echo "Building mac targets..."

# Current macOS
xcrun swift build -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx`xcrun --sdk macosx --show-sdk-version`"
# Earliest macOS
xcrun swift build -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.11"
# Arm64 macOS
xcrun swift build -Xswiftc "-target" -Xswiftc "arm64-apple-macosx`xcrun --sdk macosx --show-sdk-version`"

##
## tvOS versions
##
echo "Building tvOS targets..."

# Simulator
xcrun swift build -Xswiftc "-sdk" -Xswiftc "`xcrun --sdk appletvsimulator --show-sdk-path`" -Xswiftc "-target" -Xswiftc "x86_64-apple-tvos`xcrun --sdk iphoneos --show-sdk-version`-simulator"
# Latest
xcrun swift build -Xswiftc "-sdk" -Xswiftc $(xcrun --sdk appletvos --show-sdk-path) -Xswiftc -target -Xswiftc "arm64-apple-tvos`xcrun --sdk iphoneos --show-sdk-version`"
# Earliest iOS (v11)
xcrun swift build -Xswiftc "-sdk" -Xswiftc $(xcrun --sdk appletvos --show-sdk-path) -Xswiftc -target -Xswiftc "arm64-apple-tvos11"



# xcrun --sdk iphoneos --show-sdk-version
# xcrun --sdk macosx --show-sdk-version
# xcrun --sdk appletvos --show-sdk-version

popd
