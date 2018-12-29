import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gank/activity/activity_about.dart';
import 'package:flutter_gank/constant/strings.dart';
import 'package:flutter_gank/utils/db_utils.dart';
import 'package:flutter_gank/event/event_bus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingActivity extends StatefulWidget {
  @override
  _SettingActivityState createState() => _SettingActivityState();
}

class _SettingActivityState extends State<SettingActivity> with DbUtils {
  MethodChannel flutterNativePlugin;
  String _version;

  @override
  void initState() {
    super.initState();
    flutterNativePlugin = MethodChannel(FLUTTER_NATIVE_PLUGIN_CHANNEL_NAME);
    flutterNativePlugin.invokeMethod('getversion').then((v) {
      setState(() {
        _version = v;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(STRING_SETTING),
          centerTitle: true,
        ),
        body: Container(
          color: const Color(0xfff0f0f0),
          child: ListView(
            children: <Widget>[
              Container(
                height: 80,
                padding: EdgeInsets.symmetric(horizontal: 18),
                color: Colors.white,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            STRING_GANK_NAME,
                            style: Theme.of(context)
                                .textTheme
                                .title
                                .copyWith(fontSize: 20),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0, left: 4.0),
                            child: Text(
                              'http://gank.io',
                              style: Theme.of(context).textTheme.body1.copyWith(
                                  fontSize: 12, color: Color(0xff818181)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Image.asset(
                        'images/gank.png',
                        width: 55,
                        height: 55,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                padding: EdgeInsets.symmetric(horizontal: 14),
                height: 50,
                color: Colors.white,
                child: GestureDetector(
                  onTap: () {
                    ///just one msg.
                    Fluttertoast.showToast(
                        msg: STRING_CLEAR_CACHE_SUCCESS,
                        backgroundColor: Colors.black,
                        gravity: ToastGravity.CENTER,
                        textColor: Colors.white);
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          STRING_CLEAR_CACHE,
                          style: Theme.of(context).textTheme.body1,
                        ),
                      ),
                      Icon(Icons.chevron_right, color: const Color(0xffc7c7ca))
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14),
                height: 50,
                color: Colors.white,
                child: GestureDetector(
                  onTap: () async {
                    await clearDB();
                    Fluttertoast.showToast(
                        msg: STRING_CLEAR_FAVORITES_SUCCESS,
                        backgroundColor: Colors.black,
                        gravity: ToastGravity.CENTER,
                        textColor: Colors.white);
                    eventBus.fire(RefreshDBEvent());
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          STRING_CLEAR_FAVORITES,
                          style: Theme.of(context).textTheme.body1,
                        ),
                      ),
                      Icon(Icons.chevron_right, color: const Color(0xffc7c7ca))
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                padding: EdgeInsets.symmetric(horizontal: 14),
                height: 50,
                color: Colors.white,
                child: GestureDetector(
                  onTap: () {
                    flutterNativePlugin.invokeMethod('openFeedbackActivity');
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          STRING_FEED_BACK,
                          style: Theme.of(context).textTheme.body1,
                        ),
                      ),
                      Icon(Icons.chevron_right, color: const Color(0xffc7c7ca))
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                padding: EdgeInsets.symmetric(horizontal: 14),
                height: 50,
                color: Colors.white,
                child: GestureDetector(
                  onTap: () {
                    Fluttertoast.showToast(
                        msg: STRING_BE_DEVELOPER_TIP,
                        backgroundColor: Colors.black,
                        gravity: ToastGravity.CENTER,
                        textColor: Colors.white);
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          STRING_BE_DEVELOPER,
                          style: Theme.of(context).textTheme.body1,
                        ),
                      ),
                      Icon(Icons.chevron_right, color: const Color(0xffc7c7ca))
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14),
                height: 50,
                color: Colors.white,
                child: GestureDetector(
                  onTap: () {
                    launch('https://github.com/lijinshanmx/flutter_gank');
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          STRING_SOURCE_STAR,
                          style: Theme.of(context).textTheme.body1,
                        ),
                      ),
                      Icon(Icons.chevron_right, color: const Color(0xffc7c7ca))
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14),
                height: 50,
                color: Colors.white,
                child: GestureDetector(
                  onTap: () {
                    launch(
                        'https://github.com/lijinshanmx/flutter_gank/issues');
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          STRING_SOURCE_ISSUE_PR,
                          style: Theme.of(context).textTheme.body1,
                        ),
                      ),
                      Icon(Icons.chevron_right, color: const Color(0xffc7c7ca))
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                padding: EdgeInsets.symmetric(horizontal: 14),
                height: 50,
                color: Colors.white,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return AboutActivity();
                    }));
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          STRING_ABOUT,
                          style: Theme.of(context).textTheme.body1,
                        ),
                      ),
                      Icon(Icons.chevron_right, color: const Color(0xffc7c7ca))
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14),
                height: 50,
                color: Colors.white,
                child: GestureDetector(
                  onTap: () async {
                    var hasNewVersion =
                        await flutterNativePlugin.invokeMethod('checkupdate');
                    if (!hasNewVersion) {
                      Fluttertoast.showToast(
                          msg: STRING_ALREADY_NEW_VERSION,
                          backgroundColor: Colors.black,
                          gravity: ToastGravity.CENTER,
                          textColor: Colors.white);
                    }
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          STRING_CHECK_UPDATE,
                          style: Theme.of(context).textTheme.body1,
                        ),
                      ),
                      Icon(Icons.chevron_right, color: const Color(0xffc7c7ca))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 30),
                child: Center(
                  child: Text(
                    'v$_version(Build for platform: ${Platform.isAndroid ? 'android' : 'iOS'})',
                    style: Theme.of(context)
                        .textTheme
                        .body2
                        .copyWith(color: const Color(0xff888888)),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
