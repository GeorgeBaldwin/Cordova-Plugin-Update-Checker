# Cordova_Plugin > On Application Load, Check App Store/ Play Store and see if new version exist.

Are you lookiing for a plugin that gives your tha app the ability during innitalization to check respective appstores for android and IOS and determine if an update is required? If so, then here is the plugin for you!

iOS/Android Cordova plugin that checks play/app stores for updates for app. 

##iOS
Supports dynamically gragging current bundle id and verifying it with server. If application is older than one on server , user will be prompter with dialog that requires them to update the application.

On App Init, check will execute.

On App Resume, check will execute.


##Android

Supports dynamically gragging current version code and verifying it with app store version. Grabbing version from HTML in google play store web address. If application is older than one on server , user will be prompter with dialog that requires them to update the application.

On App Init, check will execute.

On App Resume, check will execute.

Need to add the following to config:
```xml
<feature name="UpdateCheck">
   <param name="android-package" value="com.gbos.cordova.plugin.UpdateCheck" />
</feature>
```
