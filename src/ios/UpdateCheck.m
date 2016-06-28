#import "UpdateCheck.h"

@implementation UpdateCheck
@synthesize appId=_appId;

- (void)check:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = [command callbackId];
    NSString* action = [[command arguments] objectAtIndex:0];
    NSString* result = @"";
    [self success:result callbackId:callbackId];
}


- (void)pluginInitialize
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validateVersions:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)finishLaunching:(NSNotification *)notification
{
    [self checkIfNewInstall];
}

-(void)checkIfNewInstall
{
    NSString *AppVersion =[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"];
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *SavedAppVersion =[preferences objectForKey:@"savedVersion"];
    
    if ( SavedAppVersion == nil)
    {
        [preferences setValue:AppVersion forKey:@"savedVersion"];
        const BOOL didSave = [preferences synchronize];
    }
    else if ( SavedAppVersion != AppVersion)
    {
        //Clear cache like on android
        //this.webView.clearCache();
        //Flush all cached data
        [self.commandDelegate evalJs:@"localStorage.clear();"];
        
        [preferences setValue:AppVersion forKey:@"savedVersion"];
        const BOOL didSave = [preferences synchronize];
    }
    
}
-(void)openItunes
{
    NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?mt=8", _appId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

-(void)alertMessage:(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update Available"
                                                    message:@"In order to use this application, you must update to the latest version in the app store."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self openItunes];
    }
    else if (buttonIndex == 1) {
        NSLog(@"OK Tapped. Hello World!");
    }
}

- (void)validateVersions:(NSNotification *)notification{
    
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appID = infoDictionary[@"CFBundleIdentifier"];
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", appID]]];
    NSDictionary* lookup = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if ([lookup[@"resultCount"] integerValue] == 1){
        NSString* appStoreVersion = lookup[@"results"][0][@"version"];
        NSString* currentVersion = infoDictionary[@"CFBundleShortVersionString"];
        _appId  = lookup[@"results"][0][@"trackId"];
        
        if (![appStoreVersion isEqualToString:currentVersion]){
            NSArray *versionArrayFromAppStore = [appStoreVersion componentsSeparatedByString:@"."];
            NSArray *versionArrayFromDevice =  [currentVersion componentsSeparatedByString:@"."];
            
            // Do the version count = the count on server ? its only way we can recurse both arrays equally.
            if( versionArrayFromDevice.count ==versionArrayFromAppStore.count){
                for (int i = 0; i < versionArrayFromDevice.count ; i++)
                {
                    // Assign from each array to respective variables
                    NSInteger deviceVersion = [versionArrayFromDevice[i] integerValue];
                    NSInteger appStoreVersion =[versionArrayFromAppStore[i] integerValue];
                    // Does deviceVersion < app store?? if so, then we need to upgrade... otherwise if its greater or equal we dont care as its probably a dev device for future release.
                    if (deviceVersion < appStoreVersion){
                        [self performSelector:@selector(alertMessage:) withObject:appID];
                    }
                }
            }
            else{
                NSLog(@"Need to update [%@ != %@]", appStoreVersion, currentVersion);            }
        }
    }
}
@end