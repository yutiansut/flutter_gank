import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gank/activity/activity_about.dart';
import 'package:flutter_gank/constant/colors.dart';
import 'package:flutter_gank/constant/strings.dart';
import 'package:flutter_gank/event/event_refresh_db.dart';
import 'package:flutter_gank/manager/app_manager.dart';
import 'package:flutter_gank/manager/user_manager.dart';
import 'package:flutter_gank/model/user_model.dart';
import 'package:flutter_gank/api//github_api.dart';
import 'package:flutter_gank/redux/app_state.dart';
import 'package:flutter_gank/utils/db_utils.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingActivity extends StatefulWidget {
  @override
  _SettingActivityState createState() => _SettingActivityState();
}

class _SettingActivityState extends State<SettingActivity>
    with DbUtils, GithubApi {
  MethodChannel flutterNativePlugin;
  String _version;
  User currentUser;

  @override
  void initState() {
    super.initState();
    _initVersion();
  }

  void _initVersion() {
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
                margin: EdgeInsets.only(top: 15),
                padding: EdgeInsets.symmetric(horizontal: 14),
                height: 50,
                color: Colors.white,
                child: GestureDetector(
                  onTap: () async {
                    Fluttertoast.showToast(
                        msg: STRING_SUPPORT_LATER,
                        backgroundColor: Colors.black,
                        gravity: ToastGravity.CENTER,
                        textColor: Colors.white);
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          STRING_SYNC_FAVORITES,
                          style: Theme.of(context).textTheme.body1,
                        ),
                      ),
                      Icon(Icons.chevron_right, color: const Color(0xffc7c7ca))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 30),
                child: Divider(height: 0, color: COLOR_DIVIDER),
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
                    AppManager.eventBus.fire(RefreshDBEvent());
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
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 30),
                child: Divider(height: 0, color: COLOR_DIVIDER),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14),
                height: 50,
                color: Colors.white,
                child: GestureDetector(
                  onTap: () async {
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
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 30),
                child: Divider(height: 0, color: COLOR_DIVIDER),
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
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 30),
                child: Divider(height: 0, color: COLOR_DIVIDER),
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
              Offstage(
                offstage: currentUser == null,
                child: Container(
                  margin: EdgeInsets.only(top: 15),
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  height: 60,
                  color: Colors.white,
                  child: GestureDetector(
                    onTap: () async {
                      UserManager.logout(StoreProvider.of<AppState>(context));
                      Fluttertoast.showToast(
                          msg: STRING_LOGOUT_SUCCESS,
                          backgroundColor: Colors.black,
                          gravity: ToastGravity.CENTER,
                          textColor: Colors.white);
                    },
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            STRING_LOGOUT,
                            style: Theme.of(context).textTheme.body1,
                          ),
                        ),
                        Icon(Icons.chevron_right,
                            color: const Color(0xffc7c7ca))
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 30),
                child: Center(
                  child: Text(
                    'v${_version ?? '1.0.0'}(Build for platform: ${Platform.isAndroid ? 'android' : 'iOS'})',
                    style: Theme.of(context)
                        .textTheme
                        .body2
                        .copyWith(color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
