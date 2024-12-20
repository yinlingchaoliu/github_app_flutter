import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:lib_net/net/code.dart';
import 'package:lib_net/net/result_data.dart';

///是否需要弹提示
const NOT_TIP_KEY = "noTip";

/// 错误拦截
/// Created by guoshuyu
/// on 2019/3/23.
class ErrorInterceptors extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options, handler) async {
    //没有网络
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.isEmpty ||
        connectivityResult[0] == ConnectivityResult.none) {
      return handler.reject(DioException(
          requestOptions: options,
          type: DioExceptionType.unknown,
          response: Response(
              requestOptions: options,
              data: ResultData(
                  Code.errorHandleFunction(Code.NETWORK_ERROR, "", false),
                  false,
                  Code.NETWORK_ERROR))));
    }
    return super.onRequest(options, handler);
  }
}
