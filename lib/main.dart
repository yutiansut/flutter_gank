import 'package:flutter/material.dart';
import 'package:flutter_gank/common/constant/colors.dart';
import 'package:flutter_gank/common/constant/strings.dart';
import 'package:flutter_gank/redux/app_state.dart';
import 'package:flutter_gank/ui/page/page_about.dart';
import 'package:flutter_gank/ui/page/page_home.dart';
import 'package:flutter_gank/ui/page/page_login.dart';
import 'package:flutter_gank/ui/page/page_search.dart';
import 'package:flutter_gank/ui/page/page_splash.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() => runApp(GankApp());

class GankApp extends StatelessWidget {
  /// 初始化 State
  final store = new Store<AppState>(
    appReducer,

    ///初始化数据
    initialState: new AppState(
      userInfo: null,
      themeData: new ThemeData(
        primaryColor: PRIMARY_COLOR,
        platform: TargetPlatform.android,
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
              SplashPage.ROUTER_NAME: (context) => SplashPage(),
              HomePage.ROUTER_NAME: (context) => HomePage(),
              LoginPage.ROUTER_NAME: (context) => LoginPage(),
              SearchPage.ROUTER_NAME: (context) => SearchPage(),
              AboutPage.ROUTER_NAME: (context) => AboutPage(),
            },
          );
        },
      ),
    );
  }
}
