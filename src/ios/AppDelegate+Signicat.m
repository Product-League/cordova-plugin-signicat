#import "AppDelegate+Signicat.h"
#import <ConnectisSDK/ConnectisSDK.h>

@implementation AppDelegate (SignicatPlugin)


    - (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler {

        NSLog(@"APP DELEGATE!");
        return YES
        //return ConnectisSDK.continueLogin(userActivity: userActivity)
    }


@end
