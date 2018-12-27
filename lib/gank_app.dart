import 'package:flutter/material.dart';
import 'package:flutter_gank/activity/activity_splash.dart';
import 'package:flutter_gank/constant/colors.dart';
import 'package:flutter_gank/constant/strings.dart';
import 'package:flutter_gank/utils/db_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GankApp extends StatefulWidget {
  static GankAppState of(BuildContext context, {bool nullOk: false}) {
    assert(nullOk != null);
    assert(context != null);
    final GankAppState result =
        context.ancestorStateOfType(const TypeMatcher<GankAppState>());
    if (nullOk || result != null) return result;
    throw new FlutterError('Get Static App failed');
  }

  @override
  GankAppState createState() => new GankAppState();
}

class GankAppState extends State<GankApp> with DbUtils {
  Color _primaryColor = PRIMARY_COLOR;

  void changeThemeColor(Color color) {
    SharedPreferences.getInstance().then((preferences) {
      preferences.setInt("themeColor", _primaryColor.value);
    });
    setState(() {
      _primaryColor = color;
    });
  }

  @override
  void initState() {
    super.initState();
    openDB();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: STRING_GANK_NAME,
      theme: ThemeData(
          primaryColor: _primaryColor,
          scaffoldBackgroundColor: COLOR_BG,
          dialogBackgroundColor: COLOR_BG,
          canvasColor: Colors.white,
          bottomAppBarColor: Colors.grey,
          dividerColor: COLOR_DIVIDER,
          textTheme: TextTheme(
            title: TextStyle(inherit: true, fontSize: 18.0),
            subhead:
                TextStyle(inherit: true, fontSize: 13.0, color: Colors.black),
            body1:
                TextStyle(inherit: true, fontSize: 16.0, color: Colors.black),
            body2:
                TextStyle(inherit: true, fontSize: 14.0, color: Colors.black),
          )),
      home: SplashActivity(),
    );
  }
}
