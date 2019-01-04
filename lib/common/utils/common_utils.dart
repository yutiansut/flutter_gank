import 'package:flutter/material.dart';
import 'package:flutter_gank/common/constant/colors.dart';
import 'package:flutter_gank/redux/reducer_theme.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';

class CommonUtils {
  static pushTheme(Store store, int index) {
    ThemeData themeData;
    List<Color> colors = _getThemeListColor();
    themeData = new ThemeData(
        primaryColor: colors[index], platform: TargetPlatform.iOS);
    store.dispatch(new RefreshThemeDataAction(themeData));
  }

  static List<Color> _getThemeListColor() {
    return [
      PRIMARY_COLOR,
      Colors.brown,
      Colors.blue,
      Colors.teal,
      Colors.amber,
      Colors.blueGrey,
      Colors.deepOrange,
    ];
  }

  static showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        backgroundColor: Colors.black,
        gravity: ToastGravity.CENTER,
        textColor: Colors.white);
  }
}
