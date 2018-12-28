import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/constant/strings.dart';
import 'package:flutter_gank/model/gank_item.dart';
import 'package:flutter_gank/net/gank_api.dart';
import 'package:flutter_gank/widget/gank_list_item.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with GankApi {
  List _searchResults;
  String _search;
  bool _searching = false;

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        title: Directionality(
            textDirection: Directionality.of(context),
            child: TextField(
              keyboardType: TextInputType.text,
              style: TextStyle(color: Colors.white, fontSize: 16.0),
              decoration: InputDecoration(
                hintText: STRING_PLEASE_INPUT_SEARCH,
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              autofocus: false,
              onSubmitted: (String search) async {
                _search = search;
                _searchData();
              },
            )),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _searchData();
              })
        ]);
  }

  @override
  void initState() {
    super.initState();
  }

  void _searchData() async {
    if (_search == null || _search.isEmpty) {
      Fluttertoast.showToast(
          msg: STRING_PLEASE_INPUT_SEARCH_KEYWORDS,
          backgroundColor: Colors.black,
          gravity: ToastGravity.CENTER,
          textColor: Colors.white);
      return;
    }
    setState(() {
      _searching = true;
    });
    var result = await searchData(_search);
    result = result.map<GankItem>((json) => GankItem.fromJson(json)).toList();
    setState(() {
      _searchResults = result;
      if (_searchResults.length <= 0) {
        Fluttertoast.showToast(
            msg: STRING_SEARCH_RESULT_EMPTY,
            backgroundColor: Colors.black,
            gravity: ToastGravity.CENTER,
            textColor: Colors.white);
      }
      _searching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Stack(
        children: <Widget>[
          Offstage(
            offstage: _searching,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return GankListItem(_searchResults[index]);
              },
              itemCount: _searchResults == null ? 0 : _searchResults.length,
            ),
          ),
          Offstage(
            offstage: !_searching,
            child: Center(child: CupertinoActivityIndicator()),
          )
        ],
      ),
    );
  }
}
