#import <Cordova/CDV.h>

@interface UpdateCheck : CDVPlugin

- (void) check:(CDVInvokedUrlCommand*)command;
@property NSString *appId;

@end