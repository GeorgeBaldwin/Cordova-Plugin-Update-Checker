#import "UpdateCheck.h"

@implementation UpdateCheck

- (void)check:(CDVInvokedUrlCommand*)command
{

    NSString* callbackId = [command callbackId];
    NSString* action = [[command arguments] objectAtIndex:0];



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
}

@end