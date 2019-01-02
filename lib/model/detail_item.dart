import 'package:flutter_gank/constant/strings.dart';
import 'package:flutter_gank/model/gank_item.dart';

class DetailItem {
  List<String> category;
  Map itemDataMap = Map();
  String girlImage;
  List<GankItem> gankItems = [];

  DetailItem.fromJson(Map<String, dynamic> json)
      : category =
            json['category']?.map<String>((c) => c.toString())?.toList() {
    var results = json['results'];
    results.forEach((name, value) {
      if (name != STRING_GANK_FULI) {
        itemDataMap[name] = _createGankItemListFromJson(name, value);
      }
    });
    girlImage = json['results'][STRING_GANK_FULI][0]['url'];
  }

  List<GankItem> _createGankItemListFromJson(String name, List value) {
    var gankItemList = value
        .map<GankItem>((item) => GankItem.fromJson(item, category: name))
        .toList();
    gankItems.add(GankItem.title(true, name));
    gankItems.addAll(gankItemList);
    return gankItemList;
  }
}
