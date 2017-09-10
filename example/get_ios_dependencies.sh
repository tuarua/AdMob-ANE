#!/bin/sh

wget https://github.com/tuarua/Swift-IOS-ANE/releases/download/1.1.0/ios_dependencies.zip
unzip -u -o ios_dependencies.zip
rm ios_dependencies.zip

wget https://github.com/tuarua/AdMob-ANE/releases/download/0.0.3/ios_dependencies.zip
unzip -u -o ios_dependencies.zip
rm ios_dependencies.zip

wget -O ../native_extension/ane/AdMobANE.ane https://github.com/tuarua/AdMob-ANE/releases/download/0.0.3/AdMobANE.ane?raw=true
