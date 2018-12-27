import 'package:dio/dio.dart';

Future parseDouYinVideoUrl(String url) {
  Dio dio = new Dio();
  FormData formData = new FormData.from({
    "name": "wendux",
    "age": 25,
  });
  dio.post("http://service0.iiilab.com/video/web/douyin", data: formData);
}
