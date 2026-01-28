import UIKit

extension AppDelegate {

    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        // Let Signicat handle it first
        if ConnectisSDK.continueLogin(userActivity: userActivity) {
            return true
        }

        // Fall back to Cordova default handling
        return super.application(
            application,
            continue: userActivity,
            restorationHandler: restorationHandler
        )
    }

    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        // Allow Cordova + plugins to handle it
        return super.application(app, open: url, options: options)
    }
}
