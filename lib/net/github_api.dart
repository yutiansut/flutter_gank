import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_gank/manager/user_manager.dart';
import 'package:flutter_gank/model/user_model.dart';

class GithubApi {
  static const String GANK_CLIENT_ID = '750419fa775225670b05';
  static const String GANK_CLIENT_SECRET =
      '6f12853d2f72abbd13548239cf8040783e6e47df';
  static const String note = 'com.lijinshanmx.gank';
  static const String noteUrl = 'https://github.com/lijinshanmx/gank/CallBack';
  static const List<String> GANK_OAUTH2_SCOPE = [
    'user',
    'repo',
    'gist',
    'notifications'
  ];
  static String browserOAuth2Url =
      'https://github.com/login/oauth/authorize?client_id=${GithubApi.GANK_CLIENT_ID}&scope=${GANK_OAUTH2_SCOPE.join(',')}&state=${DateTime.now().millisecondsSinceEpoch}';

  Dio dio = new Dio();

  Future<User> login(String userName, String password) async {
    try {
      var response = await dio.post("https://api.github.com/authorizations",
          data: {
            "client_id": GANK_CLIENT_ID,
            "client_secret": GANK_CLIENT_SECRET,
            "note": note,
            "noteUrl": noteUrl,
            "scopes": GANK_OAUTH2_SCOPE
          },
          options: Options(
            headers: {
              "Authorization":
                  "Basic ${base64Encode(utf8.encode("$userName:$password"))}",
              "cache-control": "no-cache"
            },
          ));
      String token = response.data['token'];
      return await getUserInfo(token);
    } catch (e) {
      print(e);
      return null;
    }
  }

  String _getToken(String tokenStr) {
    List<String> tokenSplit = tokenStr.split('&');
    for (String str in tokenSplit) {
      if (str.startsWith('access_token')) {
        return str.split('=')[1];
      }
    }
    return null;
  }

  Future<String> getAccessToken(String code) async {
    var response = await dio.get('https://github.com/login/oauth/access_token',
        data: {
          'client_id': GANK_CLIENT_ID,
          'client_secret': GANK_CLIENT_SECRET,
          'code': code
        });
    return _getToken(response.data);
  }

  Future<User> getUserInfo(String accessToken) async {
    try {
      var response = await dio
          .get("https://api.github.com/user?access_token=$accessToken");
      var userInfo = response.data;
      userInfo['token'] = accessToken;
      User user = User.fromJson(userInfo);
      await UserManager.saveUserToLocalStorage(user);
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<bool> starFlutterGank(String accessToken) async {
    var response = await dio.put(
        "https://api.github.com/user/starred/lijinshanmx/flutter_gank?access_token=$accessToken");
    return response.statusCode == 204;
  }
}
