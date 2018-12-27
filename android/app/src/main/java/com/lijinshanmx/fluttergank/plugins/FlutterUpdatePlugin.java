package com.lijinshanmx.fluttergank.plugins;

import android.app.Activity;

import com.lijinshanmx.fluttergank.activity.MainActivity;
import com.vector.update_app.utils.AppUpdateUtils;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;


/**
 * FlutterUpdatePlugin
 */
public class FlutterUpdatePlugin implements MethodChannel.MethodCallHandler {
    public static String CHANNEL = "com.lijnshanmx.checkupdate/FlutterCheckUpdatePlugin";
    private MainActivity mainActivity;

    private FlutterUpdatePlugin(Activity activity) {
        mainActivity = (MainActivity) activity;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(PluginRegistry.Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "com.lijnshanmx.checkupdate/FlutterCheckUpdatePlugin");
        channel.setMethodCallHandler(new FlutterUpdatePlugin(registrar.activity()));
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("checkupdate")) {
            mainActivity.checkUpdate();
            result.success("Success");
        } else if (call.method.equals("getversion")) {
            result.success(AppUpdateUtils.getVersionName(mainActivity));
        } else {
            result.notImplemented();
        }
    }
}
