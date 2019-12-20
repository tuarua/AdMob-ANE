#!/bin/sh

AneVersion="2.5.0"
FreKotlinVersion="1.9.1"
PlayerServicesVersion="17.0.0"
PlayerServicesMeasurementVersion="17.2.1"
AdsVersion="18.3.0"
ConsentVersion="1.0.8"
SupportV4Version="1.0.0"
GsonVersion="2.8.6"

wget -O android_dependencies/com.tuarua.frekotlin-$FreKotlinVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/com.tuarua.frekotlin-$FreKotlinVersion.ane?raw=true
wget -O android_dependencies/com.google.code.gson.gson-$GsonVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/com.google.code.gson.gson-$GsonVersion.ane?raw=true
wget -O android_dependencies/androidx.legacy.legacy-support-v4-$SupportV4Version.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/support/androidx.legacy.legacy-support-v4-$SupportV4Version.ane?raw=true
wget -O android_dependencies/com.google.android.gms.play-services-base-$PlayerServicesVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/play-services/com.google.android.gms.play-services-base-$PlayerServicesVersion.ane?raw=true
wget -O android_dependencies/com.google.android.gms.play-services-measurement-$PlayerServicesMeasurementVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/play-services/com.google.android.gms.play-services-measurement-$PlayerServicesMeasurementVersion.ane?raw=true
wget -O android_dependencies/com.google.android.gms.play-services-ads-lite-$AdsVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/play-services/com.google.android.gms.play-services-ads-lite-$AdsVersion.ane?raw=true
wget -O android_dependencies/com.google.android.ads.consent.consent-library-$ConsentVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/play-services/com.google.android.ads.consent.consent-library-$ConsentVersion.ane?raw=true
wget -O ../native_extension/ane/AdMobANE.ane https://github.com/tuarua/AdMob-ANE/releases/download/$AneVersion/AdMobANE.ane?raw=true
