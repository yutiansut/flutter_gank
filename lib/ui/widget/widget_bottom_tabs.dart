import 'package:flutter/material.dart';
import 'package:flutter_gank/common/constant/strings.dart';
import 'package:flutter_gank/ui/widget/widget_icon_font.dart';

class BottomTabs extends StatefulWidget {
  final PageController pageController;
  final ValueChanged<int> onTap;

  BottomTabs(this.pageController, this.onTap);

  @override
  _BottomTabsState createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var _bottomTabs = <BottomNavigationBarItem>[
      ///最新
      BottomNavigationBarItem(
        icon: Icon(IconFont(0xe67f)),
        title: Text(STRING_GANK_NEW),
      ),

      ///分类
      BottomNavigationBarItem(
        icon: Icon(IconFont(0xe603)),
        title: Text(STRING_GANK_CATEGORY),
      ),

      ///妹纸
      BottomNavigationBarItem(
        icon: Icon(IconFont(0xe637)),
        title: Text(STRING_GIRL),
      ),

      ///收藏
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        title: Text(STRING_GANK_FAVORITE),
      ),
    ];
    return BottomNavigationBar(
      items: _bottomTabs,
      type: BottomNavigationBarType.fixed,
      iconSize: 32,
      currentIndex: currentIndex,
      onTap: (int index) {
        if (widget.onTap != null) {
          currentIndex = index;
          widget.pageController.jumpToPage(index);
          widget.onTap(index);
        }
      },
    );
  }
}
