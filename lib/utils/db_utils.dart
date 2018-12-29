import 'dart:async';
import 'dart:io';

import 'package:flutter_gank/constant/strings.dart';
import 'package:flutter_gank/model/gank_item.dart';
import 'package:objectdb/objectdb.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DbUtils {
  static ObjectDB db;

  Future openDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "$STRING_DB_FAVORITE.db");
    db = ObjectDB(path);
    return await db.open();
  }

  Future insert(GankItem gankItem) async {
    await db.insert(gankItem.toJsonMap());
  }

  Future<List<Map<dynamic, dynamic>>> find(Map<dynamic, dynamic> query) async {
    return await db.find(query);
  }

  Future remove(GankItem gankItem) async {
    await db.remove({'itemId': gankItem.itemId});
  }

  Future clearDB() async {
    await db.remove({});
  }

  Future closeDB() async => await db.close();
}
