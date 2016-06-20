package com.gbos.cordova.plugin;

import org.apache.cordova.*;
import org.json.JSONArray;
import org.json.JSONException;

public class UpdateCheck extends CordovaPlugin {

    @Override
    public boolean execute(String action, JSONArray data, CallbackContext callbackContext) throws JSONException {

        if (action.equals("check")) {

            //Check for update...
            String message = "";

            // Send message to client...
            callbackContext.success(message);

            return true;

        } else {
            
            return false;

        }
    }
}
