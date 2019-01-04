import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter_gank/config/gank_config.dart';
import 'package:flutter_gank/net/http_code.dart';
import 'package:flutter_gank/net/http_response.dart';

///http请求
class HttpManager {
  static Dio dio = Dio();

  static Future<HttpResponse> fetch(url,
      {noTip = false,
      Map<String, dynamic> params,
      Map<String, String> header,
      method = 'get'}) async {
    Map<String, String> headers = HashMap();
    if (header != null) {
      headers.addAll(header);
    }
    Options option = new Options(method: method);
    option.headers = headers;
    option.connectTimeout = 15000;
    Response response;
    try {
      response = await dio.request(url, data: params, options: option);
    } on DioError catch (e) {
      Response errorResponse;
      if (e.response != null) {
        errorResponse = e.response;
      } else {
        errorResponse = Response(statusCode: 666);
      }
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        errorResponse.statusCode = Code.NETWORK_TIMEOUT;
      }
      if (GankConfig.DEBUG) {
        print('请求异常: ' + e.toString());
        print('请求异常url: ' + url);
      }
      return HttpResponse(
          Code.errorHandleFunction(errorResponse.statusCode, e.message, noTip),
          false,
          errorResponse.statusCode);
    }

    if (GankConfig.DEBUG) {
      print('请求url: ' + url);
      print('请求头: ' + option.headers.toString());
      if (params != null) {
        print('请求参数: ' + params.toString());
      }
      if (response != null) {
        print('返回参数: ' + response.toString());
      }
    }

    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return HttpResponse(response.data, true, Code.SUCCESS,
            headers: response.headers);
      }
    } catch (e) {
      print(e.toString() + url);
      return HttpResponse(response.data, false, response.statusCode,
          headers: response.headers);
    }
    return HttpResponse(
        Code.errorHandleFunction(response.statusCode, "", noTip),
        false,
        response.statusCode);
  }
}
