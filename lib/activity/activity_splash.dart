import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gank/activity/activity_main.dart';
import 'package:flutter_gank/constant/strings.dart';
import 'package:flutter_gank/utils/db_utils.dart';

class SplashActivity extends StatefulWidget {
  @override
  _SplashActivityState createState() => _SplashActivityState();
}

class _SplashActivityState extends State<SplashActivity>
    with SingleTickerProviderStateMixin, DbUtils {
  Timer _timer;

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

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1500), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return MainActivity();
      }));
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
