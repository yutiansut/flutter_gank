import 'dart:collection';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_gank/common/manager/cache_manager.dart';
import 'package:flutter_gank/common/net/http_code.dart';
import 'package:flutter_gank/common/net/http_response.dart';
import 'package:flutter_gank/config/gank_config.dart';

import 'http_log_interceptor.dart';

///http请求
class HttpManager {
  Dio dio;

  static HttpManager get instance => _getInstance();
  static HttpManager _instance;

  HttpManager._internal() {
    if (dio == null) {
      dio = Dio();
      dio.interceptors.add(HttpLogInterceptor());
    }
  }

  static HttpManager _getInstance() {
    if (_instance == null) {
      _instance = new HttpManager._internal();
    }
    return _instance;
  }

  Future<HttpResponse> request(url,
      {dynamic params, Map<String, String> header, method = 'get'}) async {
    ///Headers
    Map<String, String> headers = HashMap();
    if (header != null) {
      headers.addAll(header);
    }
    Options option = new Options(method: method);
    option.headers = headers;
    option.connectTimeout = GankConfig.CONNECT_TIMEOUT;
    Response response;

    ///caches
    var cacheData = await CacheManager.get(url);
    var connectivityResult = await (Connectivity().checkConnectivity());

    ///no network
    if (connectivityResult == ConnectivityResult.none) {
      ///如果缓存不为空且接口可以缓存，那么直接从缓存取即可.
      if (cacheData != null && !CacheManager.ignoreUrl(url)) {
        if (GankConfig.DEBUG) {
          print('httpManager=====>【缓存】cache请求url: ' + url);
          print('httpManager=====>【缓存】返回结果: ' + cacheData.toString());
        }
        return HttpResponse(cacheData, true, Code.SUCCESS);
      } else {
        return HttpResponse("网络连接错误", false, Code.NETWORK_ERROR);
      }
    }

    try {
      response = await dio.request(url, data: params, options: option);
      await CacheManager.set(CacheObject(url: url, value: response.data));
    } on DioError catch (e) {
      if (cacheData != null && !CacheManager.ignoreUrl(url)) {
        return HttpResponse(cacheData, true, Code.SUCCESS);
      }
      Response errorResponse = e.response ?? Response();
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        errorResponse.statusCode = Code.NETWORK_TIMEOUT;
      }
      return HttpResponse(e.message, false, errorResponse.statusCode);
    }

    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return HttpResponse(response.data, true, Code.SUCCESS);
      }
    } catch (e) {
      return HttpResponse(response.data, false, response.statusCode);
    }

    return HttpResponse("未知错误", false, response.statusCode);
  }
}
