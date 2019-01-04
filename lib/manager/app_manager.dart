import 'dart:async';

import 'package:flutter_gank/config/gank_config.dart';
import 'package:flutter_gank/manager/user_manager.dart';
import 'package:flutter_gank/model/user_model.dart';
import 'package:flutter_gank/redux/user_reducer.dart';
import 'package:flutter_gank/utils/common_utils.dart';
import 'package:flutter_gank/utils/sharedpreferences_utils.dart';
import 'package:redux/redux.dart';

class AppManager {
  static Future initApp(Store store) async {
    ///初始化用户信息
    User localUser = await UserManager.getUserFromLocalStorage();
    if (localUser != null) {
      store.dispatch(UpdateUserAction(localUser));
    }

    ///读取主题
    String themeIndex = await SPUtils.get(GankConfig.THEME_COLOR);
    if (themeIndex != null && themeIndex.isNotEmpty) {
      CommonUtils.pushTheme(store, int.parse(themeIndex));
    }
  }
}
