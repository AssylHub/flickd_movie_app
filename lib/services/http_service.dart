import 'package:dio/dio.dart';
import 'package:flickd_app/model/app_config.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HTTPService {
  final Dio dio = Dio();
  final GetIt getIt = GetIt.instance;

  late String _base_url;
  late String _api_key;
  HTTPService() {
    AppConfig _config = getIt.get<AppConfig>();
    _base_url = _config.BASE_API_URL;
    _api_key = _config.API_KEY;
  }

  Future<Response> get(
      {required path, required Map<String, dynamic> query}) async {
    // try {
      String _url = "$_base_url$path";
      Map<String, dynamic> _query = {
        "api_key": _api_key,
        "language": "en-US",
      };
      if (query != null) {
        _query.addAll(query);
      }
      return await dio.get(_url, queryParameters: _query);
    // } on DioException catch (e) {
    //   print("Unable to perform get request");
    //   print("DioError:$e");
    //   // return null;
    // }
    // return "dfnds";
  }
}
