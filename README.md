# AdMob-ANE

AdMob Adobe Air Native Extension for iOS 9.0+, Android 19+.   
Embed AdMob Ads in your AIR mobile apps with an identical API.   
Complete examples included.
Written in Swift 3.1 and Kotlin 1.1. 
-------------

Much time, skill and effort has gone into this. Help support the project

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=5UR2T52J633RC)

-------------

## Android
 
**Dependencies**
Several dependency ANEs are needed.  
 
From the command line cd into /example and run:
````shell
bash get_android_dependencies.sh
`````

They can be downloaded directly from this repo:  
[https://github.com/tuarua/Android-ANE-Dependancies/tree/master/anes]
````xml
<extensions>
    <extensionID>com.tuarua.frekotlin</extensionID>
    <extensionID>com.google.android.gms.play-services-base</extensionID>
    <extensionID>com.google.android.gms.play-services-ads-lite</extensionID>
    <extensionID>com.android.support.support-v4</extensionID>
    <extensionID>com.google.code.gson.gson</extensionID>
    ...
</extensions>
`````

Test Ads are included in the demo.
You will need an AdMob account to deliver live ads.   
[https://support.google.com/admob/answer/7356219?visit_id=1-636396064763467790-3385881595&rd=1]

You will also need to include the following in your app manifest. Update accordingly.

````xml
<manifest android:installLocation="auto">
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
    <application android:enabled="true">
        <meta-data android:name="com.google.android.gms.version" android:value="@integer/google_play_services_version" />
        <activity android:excludeFromRecents="false" android:hardwareAccelerated="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        <activity
             android:name="com.google.android.gms.ads.AdActivity"
             android:configChanges="keyboard|keyboardHidden|orientation|screenLayout|uiMode|screenSize|smallestScreenSize"
             android:theme="@android:style/Theme.Translucent" />
    </application>
</manifest>
`````

## iOS

**Dependencies**   
From the command line cd into /example and run:
````shell
bash get_ios_dependencies.sh
`````

Test Ads are included in the demo.
You will need an AdMob account to deliver live ads.   
[https://support.google.com/admob/answer/7356219?visit_id=1-636396064763467790-3385881595&rd=1]

You will also need to include the following in your app manifest. Update accordingly.
````xml
<InfoAdditions><![CDATA[
    <key>UIDeviceFamily</key>
    <array>
        <string>1</string>
        <string>2</string>
    </array>
    <key>MinimumOSVersion</key>
    <string>9.0</string>
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
        <key>NSAllowsArbitraryLoadsForMedia</key>
        <true/>
        <key>NSAllowsArbitraryLoadsInWebContent</key>
        <true/>
    </dict>
]]></InfoAdditions>
`````  


### Prerequisites

You will need:

- IntelliJ IDEA / Flash Builder
- AIR 26 + AIR 27 Beta
- Android Studio 3 Beta if you wish to edit the Android source
- Xcode 8.3 if you wish to edit the iOS source
- wget on OSX


### References
* [https://developers.google.com/admob/android/quick-start]
* [https://developers.google.com/admob/ios/quick-start]
* [https://kotlinlang.org/docs/reference/android-overview.html] 