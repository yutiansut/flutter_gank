import 'package:dio/dio.dart';
import 'package:flutter_gank/net/http_manager.dart';
import 'package:flutter_gank/net/http_response.dart';

class GankApi {
  /// gank api urls.
  static const String API_SPECIAL_DAY = "http://gank.io/api/day/";
  static const String API_DATA = "http://gank.io/api/data/";
  static const String API_SEARCH = "http://gank.io/api/search/query";
  static const String API_TODAY = "http://gank.io/api/today";
  static const String API_HISTORY = "http://gank.io/api/day/history";
  static const String API_HISTORY_CONTENT =
      "http://gank.io/api/history/content";
  static const String API_SUBMIT = "https://gank.io/api/add2gank";

  ///获取最新一天的数据
  Future getTodayData() async {
    HttpResponse response = await HttpManager.fetch(API_TODAY);
    return response.data;
  }

  ///获取指定日期的数据 [date:指定日期]
  Future getSpecialDayData(String date) async {
    HttpResponse response =
        await HttpManager.fetch(API_SPECIAL_DAY + date.replaceAll("-", "/"));
    return response.data;
  }

  ///获取分类数据 [category:分类, page: 页数, count:每页的个数]
  Future getCategoryData(String category, int page, {count = 20}) async {
    String url = API_DATA + category + "/$count/$page";
    HttpResponse response = await HttpManager.fetch(url);
    return response.data;
  }

  ///获取所有的历史干货日期.
  Future<List> getHistoryDateData() async {
    HttpResponse response = await HttpManager.fetch(API_HISTORY);
    return response.data['results'];
  }

  ///搜索[简易搜索，后面拆分页]
  Future<List> searchData(String search) async {
    HttpResponse response = await HttpManager.fetch(
        API_SEARCH + "/$search/category/all/count/50/page/1");
    return response.data['results'];
  }

  ///提交干货[url:干货地址,desc:干货描述,type:干货类型,debug:true为测试提交，false为正式提交]
  Future submitData(url, desc, who, type, {debug = false}) async {
    FormData formData = FormData.from({
      'url': url,
      'desc': desc,
      'who': who,
      'type': type,
      'debug': debug,
    });
    HttpResponse response =
        await HttpManager.fetch(API_SUBMIT, params: formData, method: 'post');
    return response.data;
  }

  ///获取所有的历史干货.
  Future<List> getHistoryContentData(int page, {count = 20}) async {
    HttpResponse response =
        await HttpManager.fetch(API_HISTORY_CONTENT + '/$count/$page');
    return response.data['results'];
  }
}
