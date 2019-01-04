import 'package:flutter/material.dart';
import 'package:flutter_gank/activity/activity_login.dart';
import 'package:flutter_gank/activity/activity_main.dart';
import 'package:flutter_gank/activity/activity_splash.dart';
import 'package:flutter_gank/constant/colors.dart';
import 'package:flutter_gank/constant/strings.dart';
import 'package:flutter_gank/model/user_model.dart';
import 'package:flutter_gank/redux/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class GankApp extends StatelessWidget {
  /// 创建Store，引用 GSYState 中的 appReducer 实现 Reducer 方法
  /// initialState 初始化 State
  final store = new Store<AppState>(
    appReducer,

    ///初始化数据
    initialState: new AppState(
      userInfo: User.empty(),
      themeData: new ThemeData(
        primaryColor: PRIMARY_COLOR,
        platform: TargetPlatform.android, //fix #192
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: StoreBuilder<AppState>(
        builder: (context, store) {
          return MaterialApp(
            title: STRING_GANK_NAME,
            theme: store.state.themeData,
            routes: {
              SplashActivity.ROUTER_NAME: (context) => SplashActivity(),
              MainActivity.ROUTER_NAME: (context) => MainActivity(),
              LoginActivity.ROUTER_NAME: (context) => LoginActivity()
            },
          );
        },
      ),
    );
  }
}
