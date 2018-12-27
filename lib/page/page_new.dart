import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/event/event_bus.dart';
import 'package:flutter_gank/model/gank_item.dart';
import 'package:flutter_gank/model/today_item.dart';
import 'package:flutter_gank/net/gank_api.dart';
import 'package:flutter_gank/widget/gank_list_item.dart';
import 'package:flutter_gank/widget/gank_list_title.dart';
import 'package:flutter_gank/widget/gank_photo_view.dart';
import 'package:flutter_gank/widget/indicator_factory.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";

class NewPage extends StatefulWidget {
  @override
  NewPageState createState() => NewPageState();

  NewPage(Key key) : super(key: key);
}

class NewPageState extends State<NewPage>
    with AutomaticKeepAliveClientMixin, GankApi {
  String _girlImage;
  String _date;
  List<GankItem> _gankItems;
  RefreshController _refreshController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    eventBus.on<RefreshNewPageEvent>().listen((event) {
      if (mounted) {
        _date = event.date;
        getNewData(date: _date);
      }
    });
    _refreshController = new RefreshController();
    getNewData();
  }

  Future _onRefresh(bool up) async {
    if (up) {
      await getNewData(date: _date, isRefresh: true);
      _refreshController.sendBack(true, RefreshStatus.completed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ///content view
        Offstage(
          offstage: _isLoading ? true : false,
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            onRefresh: _onRefresh,
            onOffsetChange: null,
            headerBuilder: buildDefaultHeader,
            controller: _refreshController,
            child: _buildListView(),
          ),
        ),

        ///loading view
        Offstage(
          offstage: _isLoading ? false : true,
          child: Center(child: CupertinoActivityIndicator()),
        )
      ],
    );
  }

  ListView _buildListView() {
    return ListView.builder(
        itemCount: _gankItems == null ? 0 : _gankItems.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) {
            return _buildImageBanner(context);
          } else {
            GankItem gankItem = _gankItems[i - 1];
            return gankItem.isTitle
                ? GankItemTitle(gankItem.category)
                : GankListItem(gankItem);
          }
        });
  }

  GestureDetector _buildImageBanner(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return GankPhotoView([_girlImage], '');
        }));
      },
      child: CachedNetworkImage(
        height: 200,
        imageUrl: _girlImage,
        fit: BoxFit.cover,
      ),
    );
  }

  Future getNewData({String date, bool isRefresh = false}) async {
    _date = date;
    if (!isRefresh) {
      setState(() {
        _isLoading = true;
      });
    }
    var todayJson;
    if (date == null) {
      todayJson = await getTodayData();
    } else {
      todayJson = await getSpecialDayData(_date);
    }
    var todayItem = TodayItem.fromJson(todayJson);
    setState(() {
      _gankItems = todayItem.gankItems;
      _girlImage = todayItem.girlImage;
      _isLoading = false;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
