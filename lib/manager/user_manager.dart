import 'dart:async';
import 'dart:convert';

import 'package:flutter_gank/config/gank_config.dart';
import 'package:flutter_gank/model/user_model.dart';
import 'package:flutter_gank/redux/user_reducer.dart';
import 'package:flutter_gank/utils/sharedpreferences_utils.dart';
import 'package:redux/redux.dart';

class UserManager {
  ///获取本地登录用户信息
  static Future<User> getUserFromLocalStorage() async {
    var userInfoJson = await SPUtils.get(GankConfig.USER_INFO);
    if (userInfoJson != null) {
      var userMap = json.decode(userInfoJson);
      User user = User.fromJson(userMap);
      return user;
    }
    return null;
  }

  ///登录
  static login(userName, password, store) async {}

  static logout(store) async {
    await SPUtils.remove(GankConfig.USER_INFO);
    store.dispatch(UpdateUserAction(null));
  }

  static saveUserToLocalStorage(User user) async {
    await SPUtils.save(GankConfig.USER_INFO, user.toJson());
  }

  ///更新用户信息
  static updateUserDao(params, Store store) async {}

  ///点赞
  static starFlutterGank(Store store) async {}
}
