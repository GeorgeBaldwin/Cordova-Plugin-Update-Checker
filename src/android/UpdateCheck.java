package com.gbos.cordova.plugin;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.app.Application;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.provider.Settings;
import android.util.Log;
import android.app.AlertDialog.Builder;
import android.widget.TextView;

import com.gc.android.market.api.MarketSession;
import com.gc.android.market.api.MarketSession.Callback;
import com.gc.android.market.api.model.Market.AppsRequest;
import com.gc.android.market.api.model.Market.AppsResponse;
import com.gc.android.market.api.model.Market.ResponseContext;
import com.motionindustries.mi.R;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.PluginResult;
import org.apache.http.client.HttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONException;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.util.List;

public class UpdateCheck extends CordovaPlugin {

    IntentFilter intentFilter = new IntentFilter("android.net.conn.CONNECTIVITY_CHANGE");
    boolean multitasking = true;
    BroadcastReceiver mReceiver = null;

    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
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
    public void onDestroy() {
        super.onDestroy();
    }

    @Override
    public void onResume(boolean multitask) {
        super.onResume(multitask);
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                new DownloadHtmlTask().execute(cordova.getActivity().getPackageName());
            }
        });
    }

    @Override
    public void onStart() {
        try{
            //--Init
            SharedPreferences preferences = cordova.getActivity().getApplicationContext().getSharedPreferences("MyPrefs", Context.MODE_PRIVATE);
            PackageInfo pInfo = cordova.getActivity().getPackageManager().getPackageInfo(cordova.getActivity().getPackageName(), 0);
            SharedPreferences.Editor editor = preferences.edit();
            String version = pInfo.versionName;
            String storedVersion = preferences.getString("ApplicationVersion", "");
            if(storedVersion == ""){
                editor.putString("ApplicationVersion", version);
                editor.apply();
                //editor.commit();
            } else if(storedVersion != "" && !storedVersion.equals(version)){
                this.webView.loadUrl("javascript:localStorage.clear()");
                editor.putString("ApplicationVersion", version);
                editor.apply();
                editor.commit();
                this.webView.clearCache();
            }
        }
        catch(Exception ex){
            // nothing for now.
        }
        super.onStart();
    }

    private class DownloadHtmlTask extends AsyncTask {
        public String getHtml(String urlToRead) throws Exception {
            StringBuilder result = new StringBuilder();
            URL url = new URL(urlToRead);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            InputStream streamIn = conn.getInputStream();
            BufferedReader rd = new BufferedReader(new InputStreamReader(streamIn));
            String line;
            while ((line = rd.readLine()) != null) {
                result.append(line);
            }
            rd.close();

            int num = result.indexOf("itemprop=\"softwareVersion\">") + 27;
            int num2 = result.indexOf("</div>",num);
            return result.substring(num,num2).trim();
        }

        protected void onPostExecute(Bitmap result) {
            //return getHtml("");
        }

        @Override
        protected Object doInBackground(Object[] params) {
            String result = "";
            try {

                String webStoreVersion = getHtml("https://play.google.com/store/apps/details?id=" +  cordova.getActivity().getPackageName() + "&hl=en");
                PackageInfo pInfo = cordova.getActivity().getPackageManager().getPackageInfo(cordova.getActivity().getPackageName(), 0);
                String appVersion = pInfo.versionName;
                // Get current bundle... loop through and check who is what... and if
                if(webStoreVersion == appVersion){
                    alert("You must update to the latest version of Motion Mobile to continue use.","Update Available","OK",null);
                }
                else{
                    String[] appVersionArray = appVersion.split(".");
                    String[] webStoreVersionArray = webStoreVersion.split(".");
                    int maxLoop = webStoreVersionArray.length >= appVersionArray.length ? webStoreVersionArray.length : appVersionArray.length;
                    for(int n = 10; n <  maxLoop ; n = n+1) {
                        int appPiece = Integer.parseInt(appVersionArray[n]);
                        int webPiece = Integer.parseInt(webStoreVersionArray[n]);

                        if(appVersionArray.length <= n &&  webStoreVersionArray.length > n ){
                            openGooglePlay(cordova.getActivity().getPackageName());
                        }

                        if (appPiece < webPiece){
                            openGooglePlay(cordova.getActivity().getPackageName());
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            return  result;
        }

        public synchronized void alert(final String message, final String title, final String buttonLabel, final CallbackContext callbackContext) {
            // final CordovaInterface cordova = cordova;
            Runnable runnable = new Runnable() {
                public void run() {
                    AlertDialog.Builder dlg = createDialog(cordova); // new AlertDialog.Builder(cordova.getActivity(), AlertDialog.THEME_DEVICE_DEFAULT_LIGHT);
                    dlg.setMessage(message);
                    dlg.setTitle(title);
                    dlg.setCancelable(true);
                    dlg.setPositiveButton(buttonLabel,
                            new AlertDialog.OnClickListener() {
                                public void onClick(DialogInterface dialog, int which) {
                                    dialog.dismiss();
                                    // callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, 0));
                                }
                            });
                    dlg.setOnCancelListener(new AlertDialog.OnCancelListener() {
                        public void onCancel(DialogInterface dialog)
                        {
                            dialog.dismiss();
                            // callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, 0));
                        }
                    });
                    changeTextDirection(dlg);
                };
            };
            cordova.getActivity().runOnUiThread(runnable);
        }

        @SuppressLint("NewApi")
        private void changeTextDirection(Builder dlg){
            int currentapiVersion = android.os.Build.VERSION.SDK_INT;
            dlg.create();
            AlertDialog dialog =  dlg.show();
            if (currentapiVersion >= android.os.Build.VERSION_CODES.JELLY_BEAN_MR1) {
                TextView messageview = (TextView)dialog.findViewById(android.R.id.message);
                messageview.setTextDirection(android.view.View.TEXT_DIRECTION_LOCALE);
            }
        }

        @SuppressLint("NewApi")
        private AlertDialog.Builder createDialog(CordovaInterface cordova) {
            int currentapiVersion = android.os.Build.VERSION.SDK_INT;
            if (currentapiVersion >= android.os.Build.VERSION_CODES.HONEYCOMB) {
                return new AlertDialog.Builder(cordova.getActivity(), AlertDialog.THEME_DEVICE_DEFAULT_LIGHT);
            } else {
                return new AlertDialog.Builder(cordova.getActivity());
            }
        }

        private void openGooglePlay(String appId) throws android.content.ActivityNotFoundException {
            Context context = cordova.getActivity().getApplicationContext();
            Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=" + appId));
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);
        }
    }
}