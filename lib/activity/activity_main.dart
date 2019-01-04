import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gank/activity/activity_about.dart';
import 'package:flutter_gank/activity/activity_history.dart';
import 'package:flutter_gank/activity/activity_settings.dart';
import 'package:flutter_gank/constant/colors.dart';
import 'package:flutter_gank/constant/strings.dart';
import 'package:flutter_gank/event/event_change_column.dart';
import 'package:flutter_gank/event/event_refresh_new.dart';
import 'package:flutter_gank/manager/app_manager.dart';
import 'package:flutter_gank/manager/user_manager.dart';
import 'package:flutter_gank/api//gank_api.dart';
import 'package:flutter_gank/api//github_api.dart';
import 'package:flutter_gank/page/page_category.dart';
import 'package:flutter_gank/page/page_favorite.dart';
import 'package:flutter_gank/page/page_fuli.dart';
import 'package:flutter_gank/page/page_new.dart';
import 'package:flutter_gank/page/page_search.dart';
import 'package:flutter_gank/page/page_submit.dart';
import 'package:flutter_gank/redux/app_state.dart';
import 'package:flutter_gank/utils/time_utils.dart';
import 'package:flutter_gank/widget/gank_drawer.dart';
import 'package:flutter_gank/widget/icon_font.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:url_launcher/url_launcher.dart';

class MainActivity extends StatefulWidget {
  static const String ROUTER_NAME = 'main';

  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity>
    with TickerProviderStateMixin, GankApi, GithubApi {
  int _currentPageIndex = 0;
  double _elevation = 5;
  String _currentDate;
  List _historyData;
  List<BottomNavigationBarItem> _bottomTabs;
  PageController _pageController;
  Animation<Offset> _historyDateDetailsPosition, _drawerDetailsPosition;
  bool _showHistoryDate = false;
  bool _showDrawerContents = true;
  AnimationController _controllerHistoryDate, _controllerDrawer;
  Animation<double> _historyDateContentsOpacity, _drawerContentsOpacity;
  Animatable<Offset> _historyDateDetailsTween, _drawerDetailsTween;
  MethodChannel flutterNativePlugin;

  void _pageChange(int index) {
    if (_showHistoryDate && _currentPageIndex != 0) {
      _controllerHistoryDate.reverse();
      _showHistoryDate = !_showHistoryDate;
    }
    setState(() {
      if (_currentPageIndex != index) {
        _currentPageIndex = index;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initData();
    _getHistoryData();
    _checkUpdate();
  }

  ///初始化数据
  void initData() {
    _pageController = new PageController(initialPage: 0);
    _controllerHistoryDate = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _controllerDrawer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _historyDateContentsOpacity = CurvedAnimation(
      parent: ReverseAnimation(_controllerHistoryDate),
      curve: Curves.fastOutSlowIn,
    );
    _drawerContentsOpacity = CurvedAnimation(
      parent: ReverseAnimation(_controllerDrawer),
      curve: Curves.fastOutSlowIn,
    );
    _historyDateDetailsTween = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).chain(CurveTween(
      curve: Curves.fastOutSlowIn,
    ));
    _drawerDetailsTween = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).chain(CurveTween(
      curve: Curves.fastOutSlowIn,
    ));
    _historyDateDetailsPosition =
        _controllerHistoryDate.drive(_historyDateDetailsTween);
    _drawerDetailsPosition = _controllerDrawer.drive(_drawerDetailsTween);
    flutterNativePlugin = MethodChannel(FLUTTER_NATIVE_PLUGIN_CHANNEL_NAME);
    _bottomTabs = <BottomNavigationBarItem>[
      new BottomNavigationBarItem(
        icon: Icon(IconData(0xe67f, fontFamily: "IconFont")),
        title: Text(STRING_GANK_NEW),
      ),
      new BottomNavigationBarItem(
        icon: Icon(IconData(0xe603, fontFamily: "IconFont")),
        title: Text(STRING_GANK_CATEGORY),
      ),
      new BottomNavigationBarItem(
        icon: Icon(IconData(0xe637, fontFamily: "IconFont")),
        title: Text(STRING_GIRL),
      ),
      new BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        title: Text(STRING_GANK_FAVORITE),
      ),
    ];
  }

  ///调用native，检查更新
  void _checkUpdate() async {
    if (Platform.isAndroid) {
      await flutterNativePlugin.invokeMethod('checkupdate');
    }
  }

  ///获取干货历史发布日期
  void _getHistoryData() async {
    var historyData = await getHistoryDateData();
    setState(() {
      _historyData = historyData;
      _currentDate = _historyData[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    //底部tab bar
    final BottomNavigationBar botNavBar = BottomNavigationBar(
      items: _bottomTabs,
      type: BottomNavigationBarType.fixed,
      iconSize: 32,
      currentIndex: _currentPageIndex,
      onTap: (int index) {
        _pageController.jumpToPage(index);
        _pageChange(index);
      },
    );

    return Scaffold(
      drawer: _buildGankDrawer(context),
      appBar: _buildAppBar(context),
      body: _buildStack(),
      bottomNavigationBar: botNavBar,
    );
  }

  GankDrawer _buildGankDrawer(BuildContext context) {
    return GankDrawer(
      widthPercent: 0.75,
      child: Column(
        children: <Widget>[
          StoreBuilder<AppState>(
            builder: (context, store) => UserAccountsDrawerHeader(
                  accountName: Text(store.state.userInfo?.userName ?? '请先登录'),
                  accountEmail: Text(
                      store.state.userInfo?.userDesc ?? '~~(>_<)~~ 什么也没有~'),
                  currentAccountPicture: GestureDetector(
                      onTap: () {
                        if (store.state.userInfo == null) {
                          Navigator.of(context).pushNamed('login');
                        }
                      },
                      child: Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          border:
                              new Border.all(color: Colors.white, width: 1.0),
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: store.state.userInfo?.avatarUrl == null ||
                                  store.state.userInfo.avatarUrl.isEmpty
                              ? Image.asset('images/gank.png')
                              : CachedNetworkImage(
                                  imageUrl: store.state.userInfo.avatarUrl),
                        ),
                      )),
                  margin: EdgeInsets.zero,
                  onDetailsPressed: () {
                    _showDrawerContents = !_showDrawerContents;
                    if (_showDrawerContents)
                      _controllerDrawer.reverse();
                    else
                      _controllerDrawer.forward();
                  },
                ),
          ),
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Expanded(
              child: ListView(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      // The initial contents of the drawer.
                      FadeTransition(
                        opacity: _drawerContentsOpacity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: ListTile(
                                leading: Icon(
                                  IconFont(0xe655),
                                  color: Color(0xff737373),
                                ),
                                title: Text('搜索干货'),
                                onTap: () {
                                  _gotoActivity(context, SearchPage());
                                },
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                IconFont(0xe8a6),
                                color: Color(0xff737373),
                              ),
                              title: Text('历史干货'),
                              onTap: () {
                                _gotoActivity(context, HistoryActivity());
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                IconFont(0xe62c),
                                color: Color(0xff737373),
                              ),
                              title: Text('提交干货'),
                              onTap: () {
                                _gotoActivity(context, SubmitPage());
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Divider(
                                height: 0,
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                IconFont(0xe621),
                                color: Color(0xff737373),
                              ),
                              title: Text('设置'),
                              onTap: () {
                                _gotoActivity(context, SettingActivity());
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                IconFont(0xe710),
                                color: Color(0xff737373),
                              ),
                              title: Text('关于'),
                              onTap: () {
                                _gotoActivity(context, AboutActivity());
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                IconFont(0xe6ab),
                                color: Color(0xff737373),
                              ),
                              title: Text('点个赞'),
                              onTap: () {
                                launch(
                                    'https://github.com/lijinshanmx/flutter_gank');
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                IconFont(0xe61a),
                                color: Color(0xff737373),
                              ),
                              title: Text('反馈'),
                              onTap: () {
                                flutterNativePlugin
                                    .invokeMethod('openFeedbackActivity');
                              },
                            ),
                          ],
                        ),
                      ),
                      // The drawer's "details" view.
                      SlideTransition(
                        position: _drawerDetailsPosition,
                        child: FadeTransition(
                          opacity: ReverseAnimation(_drawerContentsOpacity),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              ListTile(
                                  leading: Icon(
                                    IconFont(0xe619),
                                    color: Color(0xff737373),
                                  ),
                                  title: Text('同步收藏')),
                              ListTile(
                                leading: Icon(
                                  IconFont(0xe65b),
                                  color: Color(0xff737373),
                                ),
                                title: Text(STRING_LOGOUT),
                                onTap: () {
                                  UserManager.logout(
                                      StoreProvider.of<AppState>(context));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _gotoActivity(BuildContext context, Widget activity) {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return activity;
    }));
  }

  ///build Scaffold Body.
  Stack _buildStack() {
    return Stack(
      children: <Widget>[
        PageView(
          physics: new NeverScrollableScrollPhysics(),
          onPageChanged: _pageChange,
          controller: _pageController,
          children: <Widget>[
            NewPage(),
            CategoryPage(),
            FuliPage(),
            FavoritePage()
          ],
        ),
        _buildHistorySlideTransition()
      ],
    );
  }

  ///AppBar
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: _elevation,
      centerTitle: true,
      title: Offstage(
          offstage: _currentPageIndex != 0, child: Text(_currentDate ?? '')),
      actions: <Widget>[_buildActions(context)],
    );
  }

  ///标题栏左侧按钮
  IconButton _buildActions(BuildContext context) {
    return IconButton(
      icon: Icon(
        getActionsIcon(),
        size: 22,
        color: Colors.white,
      ),
      onPressed: () {
        if (_currentPageIndex == 0) {
          ///干货历史按钮
          _showHistoryDate = !_showHistoryDate;
          if (_showHistoryDate)
            _controllerHistoryDate.forward();
          else
            _controllerHistoryDate.reverse();
          setState(() {
            _elevation = _showHistoryDate ? 0 : 5;
          });
        } else if (_currentPageIndex == 1) {
          ///提交干货按钮
          Navigator.push(
              context,
              MaterialPageRoute<bool>(
                builder: (BuildContext context) => SubmitPage(),
                fullscreenDialog: true,
              ));
        } else if (_currentPageIndex == 2) {
          ///切换妹纸图列数按钮
          AppManager.eventBus.fire(ChangeFuliColumnEvent());
        } else {
          ///关于页面
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return SettingActivity();
          }));
        }
      },
    );
  }

  ///历史日期动画widget.
  SlideTransition _buildHistorySlideTransition() {
    return SlideTransition(
      position: _historyDateDetailsPosition,
      child: FadeTransition(
        opacity: ReverseAnimation(_historyDateContentsOpacity),
        child: Card(
          elevation: 5,
          margin: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
          child: Container(
            color: Colors.white,
            height: 50,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _historyData == null ? 0 : _historyData.length,
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentDate = _historyData[i];
                        AppManager.eventBus
                            .fire(RefreshNewPageEvent(_currentDate));
                      });
                    },
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        color: Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  getDay(_historyData[i]),
                                  style: Theme.of(context)
                                      .textTheme
                                      .body2
                                      .copyWith(
                                          fontSize: 18,
                                          color: (_historyData[i] ==
                                                  _currentDate)
                                              ? Theme.of(context).primaryColor
                                              : Colors.black),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 3.0, bottom: 2),
                                  child: Text(
                                    getWeekDay(_historyData[i]),
                                    style: Theme.of(context)
                                        .textTheme
                                        .body2
                                        .copyWith(
                                            fontSize: 8,
                                            color: (_historyData[i] ==
                                                    _currentDate)
                                                ? Theme.of(context).primaryColor
                                                : COLOR_HISTORY_DATE),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 3.0, bottom: 2.0),
                              child: Text(
                                getMonth(_historyData[i]),
                                style: Theme.of(context)
                                    .textTheme
                                    .body2
                                    .copyWith(
                                        fontSize: 8,
                                        color: (_historyData[i] == _currentDate)
                                            ? Theme.of(context).primaryColor
                                            : COLOR_HISTORY_DATE),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }

  ///获取Leading icon.
  IconData getActionsIcon() {
    if (_currentPageIndex == 0) {
      return IconData(0xe8a6, fontFamily: "IconFont");
    } else if (_currentPageIndex == 1) {
      return IconData(0xe6db, fontFamily: "IconFont");
    } else if (_currentPageIndex == 2) {
      return IconData(0xe63a, fontFamily: "IconFont");
    } else {
      return IconData(0xe619, fontFamily: "IconFont");
    }
  }
}
