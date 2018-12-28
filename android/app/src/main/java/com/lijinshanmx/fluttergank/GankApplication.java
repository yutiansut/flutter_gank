package com.lijinshanmx.fluttergank;

import com.lzy.okgo.OkGo;
import com.umeng.commonsdk.UMConfigure;

import io.flutter.app.FlutterApplication;

public class GankApplication extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        OkGo.getInstance().init(this);
        UMConfigure.init(this, "5c1dc3dcb465f537ea000d4d", "gank", UMConfigure.DEVICE_TYPE_PHONE, null);
    }
}
