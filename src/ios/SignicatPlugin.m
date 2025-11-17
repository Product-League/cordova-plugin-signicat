#import "SignicatPlugin.h"
#import "Cordova/CDV.h"

@import SignicatSDK; 

@implementation SignicatPlugin

- (void)startAuthentication:(CDVInvokedUrlCommand*)command {

    NSDictionary* config = [command.arguments objectAtIndex:0];
    NSString* clientId = config[@"clientId"];
    NSString* redirectUri = config[@"redirectUri"];
    NSString* env = config[@"environment"];

    SignicatConfig* sc = [[SignicatConfig alloc] initWithClientId:clientId
                                                      redirectUri:redirectUri
                                                      environment:[env isEqual:@"TEST"] ?
                                                            SignicatEnvironmentTest :
                                                            SignicatEnvironmentProduction];

    [[SignicatSDK shared] initialize:sc];

    __weak SignicatPlugin* weakSelf = self;

    [[SignicatSDK shared] startAuthenticationFrom:self.viewController
        success:^(NSString *token) {
            CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                        messageAsString:token];
            [weakSelf.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        }
        error:^(NSError *err) {
            CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                        messageAsString:err.localizedDescription];
            [weakSelf.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        }];
}

@end
