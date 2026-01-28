import Foundation
import ConnectisSDK

@_cdecl("ConnectisSDKContinueLogin")
public func ConnectisSDKContinueLogin(_ userActivityPtr: UnsafeMutableRawPointer) -> Bool {
    let userActivity = Unmanaged<NSUserActivity>
        .fromOpaque(userActivityPtr)
        .takeUnretainedValue()

    let urlStr = userActivity.webpageURL?.absoluteString ?? "<nil>"
    NSLog("[ConnectisBridge] continueLogin called. activityType=%@ url=%@",
          userActivity.activityType, urlStr)

    let handled = ConnectisSDK.continueLogin(userActivity: userActivity)

    NSLog("[ConnectisBridge] continueLogin returned: %@", handled ? "true" : "false")
    return handled
}