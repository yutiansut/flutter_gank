import 'package:flutter/material.dart';
import 'package:flutter_gank/constant/colors.dart';
import 'package:flutter_gank/redux/theme_reducer.dart';
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
}
