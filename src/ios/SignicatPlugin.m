#import "Cordova/CDV.h"
#import "SignicatPlugin.h"
#import <ConnectisSDK/ConnectisSDK.h>
#import <ConnectisSDK/ConnectisSDK-Swift.h>



@implementation SignicatPlugin

- (void)login:(CDVInvokedUrlCommand*)command {
    NSDictionary *config = [command.arguments objectAtIndex:0];
    NSString *issuer = config[@"issuer"];
    NSString *clientId = config[@"clientId"];
    NSString *redirectUri = config[@"redirectUri"];
    NSString *loginFlow = config[@"loginFlow"] ?: @"WEB";
    BOOL allowDeviceAuth = [config[@"allowDeviceAuthentication"] boolValue];
    NSString *brokerAppAcs = config[@"brokerAppAcs"];
    NSString *brokerDigidAppAcs = config[@"brokerDigidAppAcs"];

    ConnectisSDKConfiguration *cfg = [[ConnectisSDKConfiguration alloc] initWithIssuer:issuer
                                                                               clientID:clientId
                                                                            redirectURI:redirectUri
                                                                              loginFlow:( [loginFlow isEqualToString:@"APP_TO_APP"] ?
                                                                                          ConnectisLoginFlowAppToApp :
                                                                                          ConnectisLoginFlowWeb )];
    cfg.allowDeviceAuthentication = allowDeviceAuth;
    if (brokerAppAcs) {
        cfg.brokerAppAcs = brokerAppAcs;
    }
    if (brokerDigidAppAcs) {
        cfg.brokerDigidAppAcs = brokerDigidAppAcs;
    }

    [ConnectisSDK initializeWithConfiguration:cfg];

    __weak SignicatPlugin *weakSelf = self;
    [ConnectisSDK loginFromViewController:self.viewController
                                  success:^(ConnectisAuthenticationResponse *response) {

        NSMutableDictionary *res = [NSMutableDictionary dictionary];
        res[@"issuer"] = response.issuer;
        res[@"accessToken"] = response.accessToken;
        res[@"idToken"] = response.idToken;
        res[@"refreshToken"] = response.refreshToken;

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                       messageAsDictionary:res];
        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    } error:^(NSError *error) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                       messageAsString:error.localizedDescription];
        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}




- (void)getAccessToken:(CDVInvokedUrlCommand*)command {
    __weak SignicatPlugin *weakSelf = self;
    [ConnectisSDK getOpenIdAccessToken:^(NSString *token, NSError *error) {
        if (token) {
            CDVPluginResult *res = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:token];
            [weakSelf.commandDelegate sendPluginResult:res callbackId:command.callbackId];
        } else {
            CDVPluginResult *res = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
            [weakSelf.commandDelegate sendPluginResult:res callbackId:command.callbackId];
        }
    }];
}

- (void)enableDeviceAuth:(CDVInvokedUrlCommand*)command {
    [ConnectisSDK enableDeviceAuthentication];
    CDVPluginResult *res = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"deviceAuthEnabled"];
    [self.commandDelegate sendPluginResult:res callbackId:command.callbackId];
}

- (void)disableDeviceAuth:(CDVInvokedUrlCommand*)command {
    [ConnectisSDK disableDeviceAuthentication];
    CDVPluginResult *res = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"deviceAuthDisabled"];
    [self.commandDelegate sendPluginResult:res callbackId:command.callbackId];
}



@end

