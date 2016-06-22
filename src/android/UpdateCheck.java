package com.gbos.cordova.plugin;

import org.apache.cordova.*;
import org.json.JSONArray;
import org.json.JSONException;
import android.content.*;
import android.os.IBinder;

public class UpdateCheck extends CordovaPlugin {

    IntentFilter intentFilter = new IntentFilter("android.net.conn.CONNECTIVITY_CHANGE");
    boolean multitasking=true;
    BroadcastReceiver mReceiver=null;

    public void initialize(CordovaInterface cordova, CordovaWebView webView) {

        super.initialize(cordova, webView);
        //Device.uuid = getUuid();
        this.initReceiver();
    }

    private void initReceiver() {

        this.mReceiver=new BroadcastReceiver(){

            @Override
            public void onReceive(Context context, Intent intent) {
                if (intent.getAction().equals("android.net.conn.CONNECTIVITY_CHANGE"))
                {
                    //My code
                }
            }
        };

        this.cordova.getActivity().registerReceiver(this.mReceiver, intentFilter);
    }

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
    public void onDestroy(){
        super.onDestroy();
    }

    @Override
    public void onResume(boolean multitask){
        super.onResume(multitask);
    }


    @Override
    public void onStart(){
        super.onStart();
    }
}