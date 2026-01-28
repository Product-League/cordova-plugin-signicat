#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "AppDelegate.h"

extern BOOL ConnectisSDKContinueLogin(void *userActivityPtr);

@implementation AppDelegate (ConnectisHook)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = [AppDelegate class];

        SEL originalSel = @selector(application:continueUserActivity:restorationHandler:);
        SEL swizzledSel = @selector(connectis_application:continueUserActivity:restorationHandler:);

        Method originalMethod = class_getInstanceMethod(cls, originalSel);
        Method swizzledMethod = class_getInstanceMethod(cls, swizzledSel);

        if (!originalMethod || !swizzledMethod) {
            NSLog(@"[ConnectisHook] ERROR: could not find methods to swizzle.");
            return;
        }

        method_exchangeImplementations(originalMethod, swizzledMethod);
        NSLog(@"[ConnectisHook] Swizzle OK: continueUserActivity hooked.");
    });
}

- (BOOL)connectis_application:(UIApplication *)application
          continueUserActivity:(NSUserActivity *)userActivity
            restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler
{
    NSString *type = userActivity.activityType ?: @"<nil>";
    NSString *urlStr = userActivity.webpageURL.absoluteString ?: @"<nil>";

    NSLog(@"[ConnectisHook] continueUserActivity fired. type=%@ url=%@", type, urlStr);

    BOOL sdkHandled = NO;

    if ([type isEqualToString:NSUserActivityTypeBrowsingWeb] && userActivity.webpageURL != nil) {
        sdkHandled = ConnectisSDKContinueLogin((__bridge void *)userActivity);
        NSLog(@"[ConnectisHook] sdkHandled=%@", sdkHandled ? @"true" : @"false");
    } else {
        NSLog(@"[ConnectisHook] Not a Universal Link browsing activity -> skipping SDK.");
    }

    BOOL originalHandled = [self connectis_application:application
                                  continueUserActivity:userActivity
                                    restorationHandler:restorationHandler];

    NSLog(@"[ConnectisHook] originalHandled=%@ (Cordova/others)", originalHandled ? @"true" : @"false");
    NSLog(@"[ConnectisHook] returning=%@", (sdkHandled || originalHandled) ? @"true" : @"false");

    return (sdkHandled || originalHandled);
}

@end