import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gank/common/constant/colors.dart';
import 'package:flutter_gank/common/constant/strings.dart';
import 'package:flutter_gank/common/manager/app_manager.dart';
import 'package:flutter_gank/common/manager/favorite_manager.dart';
import 'package:flutter_gank/common/manager/user_manager.dart';
import 'package:flutter_gank/common/model/github_user.dart';
import 'package:flutter_gank/common/utils/navigator_utils.dart';
import 'package:flutter_gank/redux/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  static const String ROUTER_NAME = 'setting';

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              ListTile(
                onTap: () {
                  FavoriteManager.syncFavorites(context);
                },
                title: Text(STRING_SYNC_FAVORITES,
                    style: Theme.of(context).textTheme.body1),
                trailing:
                    Icon(Icons.chevron_right, color: const Color(0xffc7c7ca)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 30),
                child: Divider(height: 0, color: AppColors.COLOR_DIVIDER),
              ),
              ListTile(
                onTap: () async {
                  FavoriteManager.clearFavorites(context);
                },
                title: Text(STRING_CLEAR_FAVORITES,
                    style: Theme.of(context).textTheme.body1),
                trailing:
                    Icon(Icons.chevron_right, color: const Color(0xffc7c7ca)),
              ),
              Container(
                color: const Color(0xfff0f0f0),
                height: 10,
              ),
              ListTile(
                onTap: () async {
                  flutterNativePlugin.invokeMethod('openFeedbackActivity');
                },
                title: Text(STRING_FEED_BACK,
                    style: Theme.of(context).textTheme.body1),
                trailing:
                    Icon(Icons.chevron_right, color: const Color(0xffc7c7ca)),
              ),
              Container(
                color: const Color(0xfff0f0f0),
                height: 10,
              ),
              ListTile(
                onTap: () async {
                  Fluttertoast.showToast(
                      msg: STRING_BE_DEVELOPER_TIP,
                      backgroundColor: Colors.black,
                      gravity: ToastGravity.CENTER,
                      textColor: Colors.white);
                },
                title: Text(STRING_BE_DEVELOPER,
                    style: Theme.of(context).textTheme.body1),
                trailing:
                    Icon(Icons.chevron_right, color: const Color(0xffc7c7ca)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 30),
                child: Divider(height: 0, color: AppColors.COLOR_DIVIDER),
              ),
              ListTile(
                onTap: () async {
                  AppManager.starFlutterGank(context);
                },
                title: Text(STRING_SOURCE_STAR,
                    style: Theme.of(context).textTheme.body1),
                trailing:
                    Icon(Icons.chevron_right, color: const Color(0xffc7c7ca)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 30),
                child: Divider(height: 0, color: AppColors.COLOR_DIVIDER),
              ),
              ListTile(
                onTap: () async {
                  launch('https://github.com/lijinshanmx/flutter_gank/issues');
                },
                title: Text(STRING_SOURCE_ISSUE_PR,
                    style: Theme.of(context).textTheme.body1),
                trailing:
                    Icon(Icons.chevron_right, color: const Color(0xffc7c7ca)),
              ),
              Container(
                color: const Color(0xfff0f0f0),
                height: 10,
              ),
              ListTile(
                onTap: () async {
                  NavigatorUtils.goAbout(context);
                },
                title: Text(STRING_ABOUT,
                    style: Theme.of(context).textTheme.body1),
                trailing:
                    Icon(Icons.chevron_right, color: const Color(0xffc7c7ca)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 30),
                child: Divider(height: 0, color: AppColors.COLOR_DIVIDER),
              ),
              ListTile(
                onTap: () async {
                  AppManager.checkUpdate();
                },
                title: Text(STRING_CHECK_UPDATE,
                    style: Theme.of(context).textTheme.body1),
                trailing:
                    Icon(Icons.chevron_right, color: const Color(0xffc7c7ca)),
              ),
              StoreConnector<AppState, User>(
                converter: (store) => store.state.userInfo,
                builder: (context, userInfo) => Offstage(
                      offstage: userInfo == null,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            color: const Color(0xfff0f0f0),
                            height: 10,
                          ),
                          ListTile(
                            onTap: () async {
                              UserManager.logout(context);
                            },
                            title: Text(STRING_LOGOUT,
                                style: Theme.of(context).textTheme.body1),
                            trailing: Icon(Icons.chevron_right,
                                color: const Color(0xffc7c7ca)),
                          ),
                        ],
                      ),
                    ),
              ),
              Container(
                color: const Color(0xfff0f0f0),
                height: 10,
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
