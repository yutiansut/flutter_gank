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
  AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/splash.jpg"), fit: BoxFit.cover)),
        alignment: Alignment.center,
        child: ScaleTransition(
            scale: _controller,
            alignment: Alignment.center,
            child: Text(STRING_GANK_NAME,
                style: TextStyle(
                    inherit: true, color: Colors.white70, fontSize: 18.0))),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        lowerBound: 1.0,
        upperBound: 2.0,
        value: 1.0,
        duration: const Duration(milliseconds: 2500));

    _controller.animateTo(2.0).then((value) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return MainActivity();
      }));
    });
  }
}
