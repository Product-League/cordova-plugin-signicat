import Foundation
import ConnectisSDK

@objc(SignicatPlugin)
class SignicatPlugin: CDVPlugin {

    @objc(login:)
    func login(command: CDVInvokedUrlCommand) {
        let configDict = command.arguments[0] as! [String: Any]

        let issuer = configDict["issuer"] as! String
        let clientId = configDict["clientId"] as! String
        let redirectUri = configDict["redirectUri"] as! String

        let loginFlow = (configDict["loginFlow"] as? String) == "APP_TO_APP"
                        ? LoginFlow.appToApp
                        : LoginFlow.web

        let config = ConnectisSDKConfiguration(
            issuer: issuer,
            clientID: clientId,
            redirectURI: redirectUri,
            loginFlow: loginFlow
        )

        // TODO: Perform actual login call
        // ConnectisSDK().login(config: config)

        let result = CDVPluginResult(status: .ok)
        commandDelegate.send(result, callbackId: command.callbackId)
    }
}
