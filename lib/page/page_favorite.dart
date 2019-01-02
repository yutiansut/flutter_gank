import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/constant/strings.dart';
import 'package:flutter_gank/event/event_bus.dart';
import 'package:flutter_gank/model/gank_item.dart';
import 'package:flutter_gank/utils/db_utils.dart';
import 'package:flutter_gank/widget/gank_list_item.dart';
import 'package:flutter_gank/widget/indicator_factory.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with AutomaticKeepAliveClientMixin, DbUtils {
  bool _isLoading = true;
  bool _isEmpty = false;
  List _gankItems = [];
  RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = new RefreshController();
    eventBus.on<RefreshDBEvent>().listen((event) {
      if (mounted) {
        ///刷新本地收藏，注意:mounted变量判断是否已挂载当前widget.
        _refreshFavorites();
      }
    });
    _readFavorites();
  }

  void dispose() {
    super.dispose();
  }

  ///读取收藏数据,并更新UI
  void _readFavorites() async {
    List<GankItem> gankItems = await _getFavoritesData();
    setState(() {
      _isLoading = false;
      _gankItems = gankItems;
      _isEmpty = _gankItems.length == 0;
    });
  }

  ///刷新收藏,并更新UI
  void _refreshFavorites() async {
    List<GankItem> gankItems = await _getFavoritesData();
    setState(() {
      _gankItems = gankItems;
      _isEmpty = _gankItems.length == 0;
      _refreshController.sendBack(true, RefreshStatus.completed);
    });
  }

  ///从本地数据库获取收藏数据
  Future<List<GankItem>> _getFavoritesData() async {
    var results = await find({});
    return results
        .map<GankItem>((json) => GankItem.fromJson(json, isDbJson: true))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return buildContainer(context);
  }

  ///build 组件
  Container buildContainer(BuildContext context) {
    super.build(context);
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Offstage(
            offstage: _isLoading || _isEmpty,
            child: SmartRefresher(
              controller: _refreshController,
              headerBuilder: buildDefaultHeader,
              onRefresh: _onRefresh,
              enablePullUp: false,
              child: ListView.builder(
                itemCount: _gankItems?.length ?? 0,
                itemBuilder: (context, index) =>
                    GankListItem(_gankItems[index]),
              ),
            ),
          ),
          Offstage(
            offstage: !_isLoading,
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          ),
          Offstage(
            offstage: !_isEmpty,
            child: Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset("images/favorite_empty.png",
                    width: 130, color: Color(0xFF00ACC1)),
                Text(STRING_NO_FAVORITE,
                    style: Theme.of(context)
                        .textTheme
                        .body2
                        .copyWith(color: Theme.of(context).primaryColor))
              ],
            )),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _onRefresh(bool up) {
    _refreshFavorites();
  }
}
