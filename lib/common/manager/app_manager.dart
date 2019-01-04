import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gank/api/api_github.dart';
import 'package:flutter_gank/common/constant/strings.dart';
import 'package:flutter_gank/common/event/event_show_history_date.dart';
import 'package:flutter_gank/common/manager/favorite_manager.dart';
import 'package:flutter_gank/common/manager/user_manager.dart';
import 'package:flutter_gank/common/model/github_user.dart';
import 'package:flutter_gank/common/utils/common_utils.dart';
import 'package:flutter_gank/common/utils/sp_utils.dart';
import 'package:flutter_gank/config/gank_config.dart';
import 'package:flutter_gank/redux/app_state.dart';
import 'package:flutter_gank/redux/reducer_user.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

class AppManager {
  static EventBus eventBus = EventBus();

  static initApp(Store store) async {
    ///初始化用户信息
    try {
      User localUser = await UserManager.getUserFromLocalStorage();
      if (localUser != null) {
        store.dispatch(UpdateUserAction(localUser));
      }

      ///读取主题
      String themeIndex = await SPUtils.get(GankConfig.THEME_COLOR);
      if (themeIndex != null && themeIndex.isNotEmpty) {
        CommonUtils.pushTheme(store, int.parse(themeIndex));
      }

      ///初始化收藏数据库
      await FavoriteManager.init();
      return true;
    } catch (e) {
      return false;
    }
  }

  static notifyShowHistoryDateEvent() {
    AppManager.eventBus.fire(ShowHistoryDateEvent());
  }

  static ThemeData getThemeData(context) {
    return StoreProvider.of<AppState>(context).state.themeData;
  }

  static checkUpdate() async {
    MethodChannel flutterNativePlugin =
        MethodChannel(FLUTTER_NATIVE_PLUGIN_CHANNEL_NAME);
    var hasNewVersion = await flutterNativePlugin.invokeMethod('checkupdate');
    if (!hasNewVersion) {
      Fluttertoast.showToast(
          msg: STRING_ALREADY_NEW_VERSION,
          backgroundColor: Colors.black,
          gravity: ToastGravity.CENTER,
          textColor: Colors.white);
    }
  }

  static starFlutterGank(context) async {
    User user = StoreProvider.of<AppState>(context).state.userInfo;
    if (user != null && user.isLogin) {
      bool success = await GithubApi.starFlutterGank(user.token);
      if (success) {
        CommonUtils.showToast(STRING_STAR_SUCCESS);
      } else {
        CommonUtils.showToast(STRING_STAR_FAILED);
      }
    } else {
      launch('https://github.com/lijinshanmx/flutter_gank');
    }
  }
}
