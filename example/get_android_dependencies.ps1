$AneVersion = "2.2.0"
$PlayerServicesVersion = "16.0.1"
$AdsVersion = "16.0.0"
$SupportV4Version = "27.1.0"
$ConsentVersion = "1.0.7"

$currentDir = (Get-Item -Path ".\" -Verbose).FullName
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri https://github.com/tuarua/AdMob-ANE/releases/download/$AneVersion/AdMobANE.ane?raw=true -OutFile "$currentDir\..\native_extension\ane\AdMobANE.ane"
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.tuarua.frekotlin.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/com.tuarua.frekotlin.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.code.gson.gson-2.8.4.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/com.google.code.gson.gson-2.8.4.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.android.support.support-v4-$SupportV4Version.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/support/com.android.support.support-v4-$SupportV4Version.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.android.gms.play-services-base-$PlayerServicesVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/play-services/com.google.android.gms.play-services-base-$PlayerServicesVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.android.gms.play-services-ads-lite-$AdsVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/play-services/com.google.android.gms.play-services-ads-lite-$AdsVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.android.ads.consent.consent-library-$ConsentVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/play-services/com.google.android.ads.consent.consent-library-$ConsentVersion.ane?raw=true
