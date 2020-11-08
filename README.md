# AdMob-ANE

AdMob Adobe Air Native Extension for iOS 9.0+, Android 19+.


-------------

Much time, skill and effort has gone into this. Help support the project

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=5UR2T52J633RC)

-------------


## Prerequisites

You will need:

- IntelliJ IDEA
- AIR 33.1.1.217+
- Xcode 12.1
- [.Net Core Runtime](https://dotnet.microsoft.com/download/dotnet-core/3.1)
- [AIR-Tools](https://github.com/tuarua/AIR-Tools/)

-------------

## Android
 
##### The ANE + Dependencies
 
Change directory into the _example_ folder eg

```bash
cd /MyMac/dev/AIR/AdMob-ANE/example
```

Run the _"air-tools"_ command (You will need [AIR-Tools](https://github.com/tuarua/AIR-Tools/) installed)

```bash
air-tools install
```


**NEW** This tool now: 

1. Downloads the AdMobANE and dependencies.
1. Applies all required Android Manifest, InfoAdditons and Entitlements to your app.xml. See air package.json

Test Ads are included in the demo.
You will need an AdMob account to [deliver live ads](https://support.google.com/admob/answer/7356219).   

-------------

## iOS

>N.B. You must use a Mac to build an iOS app using this ANE. Windows is **NOT** supported.

#### iOS: Packaging Frameworks Dependencies

The iOS ANEs are written in Swift. We need to package the Swift libraries (along with a couple of dynamic frameworks) with our AIR app

![https://raw.githubusercontent.com/wiki/tuarua/Firebase-ANE/images/frameworks-package.png](https://raw.githubusercontent.com/wiki/tuarua/Firebase-ANE/images/frameworks-package.png)

-------------

### Consent SDK for GDPR

For more information on setting up Consent visit [https://support.google.com/fundingchoices/answer/9180084](https://support.google.com/fundingchoices/answer/9180084).


### References
* [https://developers.google.com/admob/android/quick-start]
* [https://developers.google.com/admob/ios/quick-start]
* [https://kotlinlang.org/docs/reference/android-overview.html] 
