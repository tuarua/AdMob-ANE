#!/bin/sh

AneVersion="2.4.0"
FreKotlinVersion="1.8.0"
PlayerServicesVersion="16.0.1"
AdsVersion="16.0.0"
ConsentVersion="1.0.7"
SupportV4Version="27.1.0"
GsonVersion="2.8.4"

wget -O android_dependencies/com.tuarua.frekotlin-$FreKotlinVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/com.tuarua.frekotlin-$FreKotlinVersion.ane?raw=true
wget -O android_dependencies/com.google.code.gson.gson-$GsonVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/com.google.code.gson.gson-$GsonVersion-air33.ane?raw=true
wget -O android_dependencies/com.android.support.support-v4-$SupportV4Version.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/support/com.android.support.support-v4-$SupportV4Version-air33.ane?raw=true
wget -O android_dependencies/com.google.android.gms.play-services-base-$PlayerServicesVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/play-services/com.google.android.gms.play-services-base-$PlayerServicesVersion-air33.ane?raw=true
wget -O android_dependencies/com.google.android.gms.play-services-ads-lite-$AdsVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/play-services/com.google.android.gms.play-services-ads-lite-$AdsVersion-air33.ane?raw=true
wget -O android_dependencies/com.google.android.ads.consent.consent-library-$ConsentVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/play-services/com.google.android.ads.consent.consent-library-$ConsentVersion-air33.ane?raw=true
wget -O ../native_extension/ane/AdMobANE.ane https://github.com/tuarua/AdMob-ANE/releases/download/$AneVersion/AdMobANE.ane?raw=true
