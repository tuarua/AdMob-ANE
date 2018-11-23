#!/bin/sh

AneVersion="2.0.0"
PlayerServicesVersion="15.0.1"
SupportV4Version="27.1.0"
FreSwiftVersion="2.5.0"

rm -r ios_dependencies/device
rm -r ios_dependencies/simulator

wget https://github.com/tuarua/Swift-IOS-ANE/releases/download/$FreSwiftVersion/ios_dependencies.zip
unzip -u -o ios_dependencies.zip
rm ios_dependencies.zip

wget https://github.com/tuarua/AdMob-ANE/releases/download/$AneVersion/ios_dependencies.zip
unzip -u -o ios_dependencies.zip
rm ios_dependencies.zip

wget -O ../native_extension/ane/AdMobANE.ane https://github.com/tuarua/AdMob-ANE/releases/download/$AneVersion/AdMobANE.ane?raw=true
