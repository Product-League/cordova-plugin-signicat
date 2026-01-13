package com.signicat.plugin;

import org.apache.cordova.*;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;

import com.connectis.sdk.ConnectisSDK;
import com.connectis.sdk.api.configuration.ConnectisSDKConfiguration;
import com.connectis.sdk.api.authentication.AccessTokenDelegate;
import com.connectis.sdk.api.authentication.AuthenticationResponseDelegate;
import com.connectis.sdk.api.authentication.DeviceAuthenticationResponseDelegate;
import com.connectis.sdk.api.authentication.ErrorResponseDelegate;
import com.connectis.sdk.internal.authentication.device.authentication.DeviceAuthenticationService;
import com.connectis.sdk.internal.authentication.device.authentication.DeviceAuthenticationUtils;
import com.connectis.sdk.internal.authentication.login.LoginService;
import com.connectis.sdk.internal.authentication.login.LoginServiceParameters;
import com.connectis.sdk.internal.authentication.token.AccessTokenService;


public class SignicatPlugin extends CordovaPlugin {

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {

        switch (action) {
            case "login":
                login(args, callbackContext);
                return true;
            case "getAccessToken":
                getAccessToken(callbackContext);
                return true;
            case "enableDeviceAuth":
                enableDeviceAuth(callbackContext);
                return true;
            case "disableDeviceAuth":
                disableDeviceAuth(callbackContext);
                return true;
            default:
                return false;
        }
    }

    private void login(JSONArray args, CallbackContext callbackContext) {

        try {
            Activity activity = cordova.getActivity();

            String issuer = args.getString(0);
            String clientId = args.getString(1);
            String redirectUri = args.getString(2);
            String scopes = args.getString(3);
            String brokerDigidAppAcs = args.getString(4);


            ConnectisSDKConfiguration configuration = new ConnectisSDKConfiguration(
                issuer,
                clientId,
                redirectUri,
                scopes,
                brokerDigidAppAcs,
                LoginFlow.APP_TO_APP
            );


            activity.runOnUiThread(() -> {
                ConnectisSDK.login(
                    configuration,
                    activity,

                    // Success callback
                    (Function1<AuthenticationResponse, Unit>) response -> {
                        callbackContext.success("Signicat login successful");
                        return Unit.INSTANCE;
                    },

                    // allowDeviceAuthentication
                    ConnectisSDK.isDeviceAuthenticationEnabled(activity),

                    // Error callback
                    (Function1<ErrorResponse, Unit>) error -> {
                        callbackContext.error("Signicat login failed");
                        return Unit.INSTANCE;
                    }
                );
            });
                

        } catch (Exception e) {
            callbackContext.error("Login config error: " + e.getMessage());
        }
    }

    private void getAccessToken(CallbackContext callbackContext) {
        ConnectisSDK.getOpenIdAccessToken(new AccessTokenDelegate() {
            @Override
            public void onToken(String token) {
                callbackContext.success(token);
            }

            @Override
            public void onError(Exception e) {
                callbackContext.error("AccessToken error: " + e.getMessage());
            }
        });
    }

    private void enableDeviceAuth(CallbackContext callbackContext) {
        ConnectisSDK.enableDeviceAuthentication();
        callbackContext.success("deviceAuthEnabled");
    }

    private void disableDeviceAuth(CallbackContext callbackContext) {
        ConnectisSDK.disableDeviceAuthentication();
        callbackContext.success("deviceAuthDisabled");
    }


}


