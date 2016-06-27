#import "UpdateCheck.h"

@implementation UpdateCheck

@synthesize appId=_appId;

- (void)check:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = [command callbackId];
    NSString* action = [[command arguments] objectAtIndex:0];
    [self needsUpdate];
    
    NSString* result = @"";
    [self success:result callbackId:callbackId];
}


- (void)pluginInitialize
{
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishLaunching:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)finishLaunching:(NSNotification *)notification
{   
    [self checkIfNewInstall]
    [self needsUpdate];
}

-(void)checkIfNewInstall
{
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appID = infoDictionary[@"CFBundleIdentifier"];
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *currentLevelKey = @"currentlevel";
    if ([preferences objectForKey:currentLevelKey] == nil)
    {
        [preferences setString:appID forKey:currentLevelKey];
        const BOOL didSave = [preferences synchronize];
        if (!didSave)
        {
            //  Couldn't save (I've never seen this happen in real world testing)
        }
    }
    else if ( [preferences objectForKey:currentLevelKey] != "")
    {
        // Clear cache like on android
        //this.webView.clearCache();
        [preferences setString:appID forKey:currentLevelKey];
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

-(BOOL) needsUpdate{
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appID = infoDictionary[@"CFBundleIdentifier"];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", appID]];
    NSData* data = [NSData dataWithContentsOfURL:url];
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
                NSLog(@"Need to update [%@ != %@]", appStoreVersion, currentVersion);
                return YES;
            }
        }
    }
    return NO;
}

@end