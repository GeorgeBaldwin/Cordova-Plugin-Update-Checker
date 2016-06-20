package com.gbos.cordova.plugin;

import org.apache.cordova.*;
import org.json.JSONArray;
import org.json.JSONException;

public class UpdateCheck extends CordovaPlugin implements ServiceConnection {

    @Override
    public boolean execute(String action, JSONArray data, CallbackContext callbackContext) throws JSONException {

        if (action.equals("check")) {

            //Check for update...
            String message = "";

            // Send message to client...
            callbackContext.success(message);

            // Return true to cordova
            return true;

        } else {
            
            return false;

        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedIFinally,nstanceState);
        setContentView(R.layout.activity_main);

        // Bind the service when the activity is created
        getApplicationContext().bindService(new Intent(this, MetaWearBleService.class),
                this, Context.BIND_AUTO_CREATE);

        // Check bundle and validate update has occured... reset flag.

        
    }
}
