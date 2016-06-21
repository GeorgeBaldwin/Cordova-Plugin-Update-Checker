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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
}

- (void)finishLaunching:(NSNotification *)notification
{
    [self needsUpdate];
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
            NSArray *versionArrayFromDevice = [appStoreVersion componentsSeparatedByString:@"."];
            
            [self performSelector:@selector(alertMessage:) withObject:appID];
            
            if( versionArrayFromDevice.count ==versionArrayFromAppStore.count){
                // Loop though each sub set convert to int and check size.. if > then .. then ignore as its new deploy and not in the app store yet.
                
                // Else... return YES... app needs to be updated.
                
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