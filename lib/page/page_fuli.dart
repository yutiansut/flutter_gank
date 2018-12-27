import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/constant/strings.dart';
import 'package:flutter_gank/model/gank_item.dart';
import 'package:flutter_gank/net/gank_api.dart';
import 'package:flutter_gank/widget/gank_photo_view.dart';
import 'package:flutter_gank/widget/indicator_factory.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gank/event/event_bus.dart';
import 'package:flutter_parallax/flutter_parallax.dart';

class FuliPage extends StatefulWidget {
  @override
  _FuliPageState createState() => _FuliPageState();
}

class _FuliPageState extends State<FuliPage>
    with AutomaticKeepAliveClientMixin, GankApi {
  bool _isLoading = true;
  List _gankItems = [];
  int _page = 1;
  bool isOneColumn = true;
  RefreshController _refreshController;
  final _controller = new ScrollController();

  @override
  void initState() {
    super.initState();
    eventBus.on<ChangeFuliColumnEvent>().listen((event) {
      if (mounted) {
        setState(() {
          isOneColumn = !isOneColumn;
        });
      }
    });
    _refreshController = new RefreshController();
    _getCategoryData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Offstage(
              offstage: _isLoading,
              child: SmartRefresher(
                controller: _refreshController,
                headerBuilder: buildDefaultHeader,
                footerBuilder: (context, mode) =>
                    buildDefaultFooter(context, mode, () {
                      _refreshController.sendBack(
                          false, RefreshStatus.refreshing);
                    }),
                onRefresh: _onRefresh,
                enablePullUp: true,
                child: GridView.count(
                  controller: _controller,
                  //横轴的最大长度
                  crossAxisCount: isOneColumn ? 1 : 2,
                  //主轴间隔
                  mainAxisSpacing: 2.0,
                  //横轴间隔
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 2 / (isOneColumn ? 2 : 3),
                  children: _gankItems?.map<Widget>((gankItem) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return GankPhotoView([
                                (gankItem.url as String)
                                    .replaceFirst("large", "mw690")
                              ], gankItem.desc);
                            }));
                          },
                          child: _buildImageWidget(gankItem),
                        );
                      })?.toList() ??
                      [],
                ),
              )),
          Offstage(
            offstage: !_isLoading,
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImageWidget(gankItem) {
    return isOneColumn
        ? Parallax.inside(
            mainAxisExtent: 150.0,
            child: CachedNetworkImage(
              imageUrl: gankItem.url,
              fit: BoxFit.cover,
            ),
          )
        : CachedNetworkImage(
            imageUrl: gankItem.url,
            fit: BoxFit.cover,
          );
  }

  void _onRefresh(bool up) {
    if (!up) {
      _page++;
      _getCategoryData(loadMore: true);
    } else {
      _page = 1;
      _getCategoryData();
    }
  }

  void _getCategoryData({bool loadMore = false}) async {
    var categoryData = await getCategoryData(STRING_GANK_FULI, _page);
    var gankItems = categoryData['results']
        .map<GankItem>((itemJson) =>
            GankItem.fromJson(itemJson, category: STRING_GANK_FULI))
        .toList();
    if (loadMore) {
      _refreshController.sendBack(false, RefreshStatus.idle);
      setState(() {
        _gankItems.addAll(gankItems);
        _isLoading = false;
      });
    } else {
      _refreshController.sendBack(true, RefreshStatus.completed);
      setState(() {
        _gankItems = gankItems;
        _isLoading = false;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}
