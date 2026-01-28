import UIKit
import ConnectisSDK

@objc(SignicatAppDelegate)
class SignicatAppDelegate: NSObject {

    @objc
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        if ConnectisSDK.continueLogin(userActivity: userActivity) {
            return true
        }

        return false
    }

    @objc
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Keep this for safety / future compatibility
        return true
    }
}
