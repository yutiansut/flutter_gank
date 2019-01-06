import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gank/common/constant/colors.dart';
import 'package:flutter_gank/common/constant/strings.dart';
import 'package:flutter_gank/common/localization/gank_localizations.dart';
import 'package:flutter_gank/common/manager/app_manager.dart';
import 'package:flutter_gank/common/manager/favorite_manager.dart';
import 'package:flutter_gank/common/manager/user_manager.dart';
import 'package:flutter_gank/common/model/github_user.dart';
import 'package:flutter_gank/common/utils/common_utils.dart';
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
    flutterNativePlugin =
        MethodChannel(Strings.FLUTTER_NATIVE_PLUGIN_CHANNEL_NAME);
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
          title: Text(CommonUtils.getLocale(context).settings),
          centerTitle: true,
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              ListTile(
                onTap: () {
                  CommonUtils.showThemeDialog(context);
                },
                title: Text(CommonUtils.getLocale(context).themeSetting,
                    style: Theme.of(context).textTheme.body1),
                trailing:
                    Icon(Icons.chevron_right, color: const Color(0xffc7c7ca)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 30),
                child: Divider(height: 0, color: AppColors.COLOR_DIVIDER),
              ),
              ListTile(
                onTap: () {
                  CommonUtils.showLanguageDialog(context);
                },
                title: Text(CommonUtils.getLocale(context).languageSetting,
                    style: Theme.of(context).textTheme.body1),
                trailing:
                    Icon(Icons.chevron_right, color: const Color(0xffc7c7ca)),
              ),
              Container(
                color: const Color(0xfff0f0f0),
                height: 10,
              ),
              ListTile(
                onTap: () {
                  FavoriteManager.syncFavorites(context);
                },
                title: Text(CommonUtils.getLocale(context).syncFavorites,
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
                title: Text(CommonUtils.getLocale(context).clearFavorites,
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
                title: Text(
                    GankLocalizations.of(context).currentLocalized.feedBack,
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
                      msg: GankLocalizations.of(context)
                          .currentLocalized
                          .beDeveloperTip,
                      backgroundColor: Colors.black,
                      gravity: ToastGravity.CENTER,
                      textColor: Colors.white);
                },
                title: Text(
                    GankLocalizations.of(context).currentLocalized.beDeveloper,
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
                title: Text(
                    GankLocalizations.of(context).currentLocalized.sourceStar,
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
                title: Text(CommonUtils.getLocale(context).sourceIssuePR,
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
                title: Text(CommonUtils.getLocale(context).about,
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
                  AppManager.checkUpdate(context);
                },
                title: Text(
                    GankLocalizations.of(context).currentLocalized.checkUpdate,
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
                            title: Text(
                                GankLocalizations.of(context)
                                    .currentLocalized
                                    .logout,
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
