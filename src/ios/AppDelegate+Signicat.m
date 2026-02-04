#import "AppDelegate+Signicat.h"
#import <ConnectisSDK/ConnectisSDK.h>

@implementation AppDelegate (SignicatPlugin)

#pragma mark - Universal Link / App-to-App Resume

- (BOOL)application:(UIApplication *)application
continueUserActivity:(NSUserActivity *)userActivity
 restorationHandler:(void (^)(NSArray * __nullable restorableObjects))restorationHandler
{
    NSLog(@"[Signicat] APP DELEGATE!");
    // First ask Signicat SDK to handle it
    BOOL handled = [ConnectisSDK continueLoginWithUserActivity:userActivity];

    if (handled) {
        NSLog(@"[Signicat] continueLoginWithUserActivity handled the link");
        return YES;
    }

    // Fallback to original Cordova behavior if not handled
    return [super application:application
         continueUserActivity:userActivity
           restorationHandler:restorationHandler];
}

#pragma mark - Classic URL callback (optional)

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    NSLog(@"[Signicat] APP DELEGATE2!");
    // You can still log or inspect, but Cordova default is fine
    NSLog(@"[Signicat] openURL called: %@", url.absoluteString);

    return [super application:app openURL:url options:options];
}

@end
