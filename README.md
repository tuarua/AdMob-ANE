# AdMob-ANE

AdMob Adobe Air Native Extension for iOS 9.0+, Android 19+.


-------------

Much time, skill and effort has gone into this. Help support the project

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=5UR2T52J633RC)

-------------

## Android
 
##### The ANE + Dependencies
 
From the command line cd into /example and run:   
macOS
 
```shell
bash get_android_dependencies.sh
```
Windows Powershell

```shell
PS get_android_dependencies.ps1
```

The dependencies can be downloaded directly from [this repo](https://github.com/tuarua/Android-ANE-Dependancies/tree/master/anes):  

```xml
<extensions>
    <extensionID>com.tuarua.frekotlin</extensionID>
    <extensionID>com.google.android.gms.play-services-base</extensionID>
    <extensionID>com.google.android.gms.play-services-ads-lite</extensionID>
    <extensionID>com.google.android.gms.play-services-measurement</extensionID>
    <extensionID>com.google.android.ads.consent.consent-library</extensionID>
    <extensionID>com.android.support.support-v4</extensionID>
    <extensionID>com.google.code.gson.gson</extensionID>
    ...
</extensions>
```

You will also need to include the following in your app manifest. Update accordingly.

```xml
<manifest android:installLocation="auto">
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
    <application android:enabled="true">
        <meta-data android:name="com.google.android.gms.version" android:value="@integer/google_play_services_version" />
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="[YOUR_APP_ID]"/>
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
```

Test Ads are included in the demo.
You will need an AdMob account to [deliver live ads](https://support.google.com/admob/answer/7356219).   

#### AIR 32 & 33
This ANE is built against AIR 33 SDK. If you wish to use with AIR 32 you will need to replace dx.jar in lib/android/bin/ with [this one](https://github.com/tuarua/Android-ANE-Dependencies/blob/master/AIR32_patch/lib/android/bin/dx.jar?raw=true)

-------------

## iOS

##### The ANE + Dependencies

>N.B. You must use a Mac to build an iOS app using this ANE. Windows is **NOT** supported.

From the  Terminal cd into /example and run:

```shell
bash get_ios_dependencies.sh
```

The folder, **ios_dependencies/device/Frameworks**, must be packaged as part of your app when creating the ipa. How this is done will depend on the IDE you are using.   
After the ipa is created unzip it and confirm there is a "Frameworks" folder in the root of the .app package.

-------------

You will also need to include the following in your app manifest. Update accordingly.

```xml
<InfoAdditions><![CDATA[
    <key>UIDeviceFamily</key>
    <array>
        <string>1</string>
        <string>2</string>
    </array>
    <key>MinimumOSVersion</key>
    <string>9.0</string>
    <key>GADApplicationIdentifier</key>
    <string>[YOUR_APP_ID]</string>
    <key>NSAppTransportSecurity</key>
    <!-- If performing EU GDPR check -->
    <key>GADDelayAppMeasurementInit</key>
    <true/>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
        <key>NSAllowsArbitraryLoadsForMedia</key>
        <true/>
        <key>NSAllowsArbitraryLoadsInWebContent</key>
        <true/>
    </dict>
]]></InfoAdditions>
```  

Test Ads are included in the demo.
You will need an AdMob account to [deliver live ads](https://support.google.com/admob/answer/7356219).

#### AIR 32 & 33
You should use AIR 32 for iOS builds

-------------

### Consent SDK for GDPR
#### !! Important !!
Before using the consent methods:

1. Login in to you [AdMob account](https://apps.admob.com).
2. Navigate to Blocking Controls > EU User Consent.
3. Check radio for **Custom set of ad technology providers**.
4. Click Select Providers.
5. Select up to **12** providers only.

### Prerequisites

You will need:

- IntelliJ IDEA / Flash Builder
- AIR 33.0.2.338+
- Xcode 11.3
- * wget on macOS via `brew install wget`
- Android Studio 3 if you wish to edit the Android source
- Powershell on Windows


### References
* [https://developers.google.com/admob/android/quick-start]
* [https://developers.google.com/admob/ios/quick-start]
* [https://kotlinlang.org/docs/reference/android-overview.html] 
