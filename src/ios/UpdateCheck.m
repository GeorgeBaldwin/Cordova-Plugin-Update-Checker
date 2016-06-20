#import "UpdateCheck.h"

@implementation UpdateCheck

- (void)check:(CDVInvokedUrlCommand*)command
{

    NSString* callbackId = [command callbackId];
    NSString* appId = [[command arguments] objectAtIndex:0];



    NSString* result = "";
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:msg];

    [self success:result callbackId:callbackId];
}


- (void)pluginInitialize
{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];

}

- (void)finishLaunching:(NSNotification *)notification
{
    // Put here the code that should be on the AppDelegate.m


    let alert = UIAlertController(title: "Hello!", message: "Message", preferredStyle: UIAlertControllerStyle.Alert)
	let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default) 
	{ 
	   // (UIAlertAction) -> Void in   
	}


  
}

-(void)openItunes:(NSString*)storeId
{
	NSString *iTunesLink = @"https://itunes.apple.com/us/app/apple-store/id" + storeId + "?mt=8";
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}

<<<<<<< Updated upstream

-(void)alertMessage:(NSString*)message
{
    UIAlertController* alert = [UIAlertController
          alertControllerWithTitle:@"Alert"
          message:message
          preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction 
          actionWithTitle:@"OK" style:UIAlertActionStyleDefault
         handler:^(UIAlertAction * action) {}];

    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}


=======
-(BOOL) needsUpdate{
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appID = infoDictionary[@"CFBundleIdentifier"];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", appID]];
    NSData* data = [NSData dataWithContentsOfURL:url];
    NSDictionary* lookup = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    if ([lookup[@"resultCount"] integerValue] == 1){
        NSString* appStoreVersion = lookup[@"results"][0][@"version"];
        NSString* currentVersion = infoDictionary[@"CFBundleShortVersionString"];
        if (![appStoreVersion isEqualToString:currentVersion]){
            NSLog(@"Need to update [%@ != %@]", appStoreVersion, currentVersion);
            return YES;
        }
    }
    return NO;
}

>>>>>>> Stashed changes
@end