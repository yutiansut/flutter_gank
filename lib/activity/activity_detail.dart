import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/model/gank_item.dart';
import 'package:flutter_gank/model/detail_item.dart';
import 'package:flutter_gank/api//gank_api.dart';
import 'package:flutter_gank/widget/gank_list_item.dart';
import 'package:flutter_gank/widget/gank_list_title.dart';
import 'package:flutter_gank/widget/gank_photo_view.dart';
import 'package:flutter_gank/widget/indicator_factory.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DetailActivity extends StatefulWidget {
  final String _date;

  DetailActivity(this._date);

  @override
  _DetailActivityState createState() => _DetailActivityState();
}

class _DetailActivityState extends State<DetailActivity> with GankApi {
  List<GankItem> _gankItems;
  RefreshController _refreshController;
  bool _isLoading = true;
  String _girlImage;

  @override
  void initState() {
    super.initState();
    _refreshController = new RefreshController();
    getNewData();
  }

  Future getNewData({String date, bool isRefresh = false}) async {
    if (!isRefresh) {
      setState(() {
        _isLoading = true;
      });
    }
    var specialDayDataJson = await getSpecialDayData(widget._date);
    var specialDayItem = DetailItem.fromJson(specialDayDataJson);
    setState(() {
      _gankItems = specialDayItem.gankItems;
      _girlImage = specialDayItem.girlImage;
      _isLoading = false;
    });
  }

  Future _onRefresh(bool up) async {
    if (up) {
      await getNewData(date: widget._date, isRefresh: true);
      _refreshController.sendBack(true, RefreshStatus.completed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._date),
        centerTitle: true,
      ),
      body: Stack(
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
      ),
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
          return GankPhotoView([_girlImage], widget._date);
        }));
      },
      child: CachedNetworkImage(
        height: 200,
        imageUrl: _girlImage,
        fit: BoxFit.cover,
      ),
    );
  }
}
