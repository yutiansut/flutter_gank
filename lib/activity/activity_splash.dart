import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gank/activity/activity_main.dart';
import 'package:flutter_gank/constant/strings.dart';
import 'package:flutter_gank/manager/app_manager.dart';
import 'package:flutter_gank/redux/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class SplashActivity extends StatefulWidget {
  static const String ROUTER_NAME = '/';

  @override
  _SplashActivityState createState() => _SplashActivityState();
}

class _SplashActivityState extends State<SplashActivity> {
  bool hadInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (hadInit) {
      return;
    }
    hadInit = true;
    Store<AppState> store = StoreProvider.of(context);
    AppManager.initApp(store).then((_) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, MainActivity.ROUTER_NAME);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: FractionalOffset.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    'images/gank.png',
                    width: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 60),
                    child: Text(STRING_GANK_NAME,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontFamily: "WorkSansSemiBold")),
                  )
                ],
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text('${DateTime.now().year}@gank.io',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontFamily: "WorkSansMedium")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
