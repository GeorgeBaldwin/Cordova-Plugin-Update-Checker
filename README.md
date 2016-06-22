# Cordova_Plugin_App_Update_Check
iOS/Android Cordova plugin that checks play/app stores for updates for app. 


##iOS
Supports dynamically gragging current bundle id and verifying it with server. If application is older than one on server , user will be prompter with dialog that requires them to update the application.

On App Init, check will execute.

On App Resume, check will execute.


##Android

Need to add the following to config:
```xml
<feature name="UpdateCheck">
   <param name="android-package" value="com.gbos.cordova.plugin.UpdateCheck" />
</feature>
```xml
