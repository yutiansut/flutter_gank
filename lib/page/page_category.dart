import 'package:flutter/material.dart';
import 'package:flutter_gank/constant/strings.dart';
import 'package:flutter_gank/widget/gank_list_category.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TabController(vsync: this, length: GANK_ALL_CATEGORIES.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                border: Border(
                    bottom: BorderSide(
                        width: 0.0, color: Theme.of(context).dividerColor))),
            child: TabBar(
                controller: _controller,
                isScrollable: true,
                labelColor: Theme.of(context).primaryColor,
                indicatorColor: Theme.of(context).primaryColor,
                tabs: GANK_ALL_CATEGORIES.map<Widget>((page) {
                  return Tab(text: page);
                }).toList())),
        Expanded(
          child: TabBarView(
              controller: _controller,
              children: GANK_ALL_CATEGORIES.map<Widget>((String page) {
                return GankListCategory(page);
              }).toList()),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
