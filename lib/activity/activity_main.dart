import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gank/activity/activity_about.dart';
import 'package:flutter_gank/constant/strings.dart';
import 'package:flutter_gank/event/event_bus.dart';
import 'package:flutter_gank/net/gank_api.dart';
import 'package:flutter_gank/page/page_category.dart';
import 'package:flutter_gank/page/page_favorite.dart';
import 'package:flutter_gank/page/page_fuli.dart';
import 'package:flutter_gank/page/page_new.dart';
import 'package:flutter_gank/page/page_search.dart';
import 'package:flutter_gank/page/page_submit.dart';

class MainActivity extends StatefulWidget {
  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity>
    with TickerProviderStateMixin, GankApi {
  GlobalKey<NewPageState> _homeNewGlobalKey;
  int _currentPageIndex = 0;
  double _elevation = 5;
  String _currentDate;
  double _historyCardHeight = 50;
  List _historyData;
  List<BottomNavigationBarItem> _bottomTabs;
  PageController _pageController;
  Animation<Offset> _drawerDetailsPosition;
  bool _showHistoryDate = false;
  AnimationController _controller;
  Animation<double> _drawerContentsOpacity;
  MethodChannel checkUpdatePlugin;
  Animatable<Offset> _drawerDetailsTween;

  void _pageChange(int index) {
    if (_showHistoryDate && _currentPageIndex != 0) {
      _controller.reverse();
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
    _homeNewGlobalKey = new GlobalKey();
    _pageController = new PageController(initialPage: 0);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _drawerContentsOpacity = CurvedAnimation(
      parent: ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsTween = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).chain(CurveTween(
      curve: Curves.fastOutSlowIn,
    ));
    checkUpdatePlugin = MethodChannel(FLUTTER_CHECK_UPDATE_PLUGIN_CHANNEL_NAME);
    _drawerDetailsPosition = _controller.drive(_drawerDetailsTween);
    _bottomTabs = <BottomNavigationBarItem>[
      new BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text(STRING_GANK_NEW),
      ),
      new BottomNavigationBarItem(
        icon: Icon(Icons.apps),
        title: Text(STRING_GANK_CATEGORY),
      ),
      new BottomNavigationBarItem(
        icon: Icon(Icons.image),
        title: Text(STRING_GIRL),
      ),
      new BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        title: Text(STRING_GANK_FAVORITE),
      ),
    ];
  }

  ///调用native，检查更新
  Future<Null> _checkUpdate() async {
    if (Platform.isAndroid) {
      await checkUpdatePlugin.invokeMethod('checkupdate');
    }
  }

  ///获取干货历史发布日期
  void _getHistoryData() async {
    var historyData = await getHistoryData();
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
      appBar: _buildAppBar(context),
      body: _buildStack(),
      bottomNavigationBar: botNavBar,
    );
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
            NewPage(_homeNewGlobalKey),
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
      leading: _buildLeading(context),
      title: Offstage(
          offstage: _currentPageIndex != 0, child: Text(_currentDate ?? '')),
      actions: _buildActions(context),
    );
  }

  ///标题栏右边按钮
  List<Widget> _buildActions(BuildContext context) {
    return [
      GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return SearchPage();
          }));
        },
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 16),
          child: Icon(
            Icons.search,
            size: 26,
            color: Colors.white,
          ),
        ),
      )
    ];
  }

  ///标题栏左侧按钮
  GestureDetector _buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_currentPageIndex == 0) {
          ///干货历史按钮
          _showHistoryDate = !_showHistoryDate;
          if (_showHistoryDate)
            _controller.forward();
          else
            _controller.reverse();
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
          ///提交干货按钮
          eventBus.fire(ChangeFuliColumnEvent());
        } else {
          ///关于页面
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return AboutActivity();
          }));
        }
      },
      child: Icon(
        getLeadingIcon(),
        size: 22,
        color: Colors.white,
      ),
    );
  }

  ///历史日期动画widget.
  SlideTransition _buildHistorySlideTransition() {
    return SlideTransition(
      position: _drawerDetailsPosition,
      child: FadeTransition(
        opacity: ReverseAnimation(_drawerContentsOpacity),
        child: Card(
          elevation: 5,
          margin: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
          child: Container(
            color: Colors.white,
            height: _historyCardHeight,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _historyData == null ? 0 : _historyData.length,
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentDate = _historyData[i];
                        eventBus.fire(RefreshNewPageEvent(_currentDate));
                      });
                    },
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        color: Colors.white,
                        child: Text(_historyData[i],
                            style: TextStyle(
                                fontSize: 16,
                                color: (_historyData[i] == _currentDate)
                                    ? Theme.of(context).primaryColor
                                    : Colors.black),
                            textAlign: TextAlign.center),
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
  IconData getLeadingIcon() {
    if (_currentPageIndex == 0) {
      return Icons.date_range;
    } else if (_currentPageIndex == 1) {
      return Icons.add;
    } else if (_currentPageIndex == 2) {
      return Icons.view_day;
    } else {
      return Icons.settings;
    }
  }
}
