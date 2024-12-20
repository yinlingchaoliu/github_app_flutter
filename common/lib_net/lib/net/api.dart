import 'package:dio/dio.dart';
import 'package:lib_net/net/code.dart';

import 'dart:collection';
import 'package:lib_net/net/interceptors/error_interceptor.dart';
import 'package:lib_net/net/interceptors/header_interceptor.dart';
import 'package:lib_net/net/interceptors/log_interceptor.dart';
import 'package:lib_net/net/interceptors/response_interceptor.dart';
import 'package:lib_net/net/result_data.dart';

///http请求
class HttpManager {
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";

  final Dio _dio = Dio(); // 使用默认配置

  static bool DEBUG = true;

  HttpManager() {
    _dio.interceptors.add(HeaderInterceptors());
    _dio.interceptors.add(LogsInterceptors());
    _dio.interceptors.add(ErrorInterceptors());
    _dio.interceptors.add(ResponseInterceptors());
  }

  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  ///发起网络请求
  ///[ url] 请求url
  ///[ params] 请求参数
  ///[ header] 外加头
  ///[ option] 配置
  Future<ResultData?> netFetch(
      url, params, Map<String, dynamic>? header, Options? option,
      {noTip = false}) async {
    Map<String, dynamic> headers = HashMap();
    if (header != null) {
      headers.addAll(header);
    }

    if (option != null) {
      option.headers = headers;
    } else {
      option = Options(method: "get");
      option.headers = headers;
    }

    Response response;
    try {
      response = await _dio.request(url, data: params, options: option);
    } on DioException catch (e) {
      return _resultError(e, url, noTip: noTip);
    }
    if (response.data is DioException) {
      return _resultError(response.data, url, noTip: noTip);
    }
    return response.data;
  }

  _resultError(DioException e, String url, {noTip = false}) {
    Response? errorResponse;
    if (e.response != null) {
      errorResponse = e.response;
    } else {
      errorResponse =
          Response(statusCode: 666, requestOptions: RequestOptions(path: url));
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      errorResponse!.statusCode = Code.NETWORK_TIMEOUT;
    }
    return ResultData(
        Code.errorHandleFunction(errorResponse!.statusCode, e.message, noTip),
        false,
        errorResponse.statusCode);
  }
}

final HttpManager httpManager = HttpManager();
