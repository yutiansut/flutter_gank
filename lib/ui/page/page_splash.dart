import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gank/ui/page/page_home.dart';
import 'package:flutter_gank/common/constant/strings.dart';
import 'package:flutter_gank/common/manager/app_manager.dart';
import 'package:flutter_gank/redux/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class SplashPage extends StatefulWidget {
  static const String ROUTER_NAME = '/';

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
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
        Navigator.pushReplacementNamed(context, HomePage.ROUTER_NAME);
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
