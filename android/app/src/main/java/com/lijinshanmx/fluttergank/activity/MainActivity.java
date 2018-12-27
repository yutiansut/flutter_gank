package com.lijinshanmx.fluttergank.activity;

import android.os.Build;
import android.os.Bundle;
import android.os.Environment;

import com.lijinshanmx.fluttergank.plugins.FlutterUpdatePlugin;
import com.lijinshanmx.fluttergank.utils.OkGoUpdateHttpUtil;
import com.vector.update_app.UpdateAppManager;
import com.vector.update_app.utils.AppUpdateUtils;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterFragmentActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            getWindow().setStatusBarColor(0);
        }
        GeneratedPluginRegistrant.registerWith(this);
        FlutterUpdatePlugin.registerWith(registrarFor(FlutterUpdatePlugin.CHANNEL));

    }

    public void checkUpdate() {
        String path = Environment.getExternalStorageDirectory().getAbsolutePath();
        Map<String, String> params = new HashMap<>();

        params.put("appKey", "ab5dce55Ac4bcW408cPb8c2Aaeac179c5f6g");
        params.put("version", AppUpdateUtils.getVersionName(this));

        new UpdateAppManager
                .Builder()
                .setActivity(this)
                .setHttpManager(new OkGoUpdateHttpUtil())
                .setUpdateUrl("https://gank.io/api/checkversion")
                .setPost(true)
                .setParams(params)
                .setTargetPath(path)
                .dismissNotificationProgress()
                .build()
                .update();
    }

}
