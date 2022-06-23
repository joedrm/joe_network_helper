import 'dart:io';

import 'package:dio/dio.dart';

class ExceptionHandle {
  static const int success = 200;
  static const int success201 = 201;
  static const int successNotContent = 204;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;

  static const int netError = 1000;
  static const int parseError = 1001;
  static const int socketError = 1002;
  static const int httpError = 1003;
  static const int timeoutError = 1004;
  static const int cancelError = 1005;
  static const int noNetWork = 1006;
  static const int unknownError = 9999;

  static NetError handleException(dynamic error) {
    if (error is DioError) {
      if (error.type == DioErrorType.other ||
          error.type == DioErrorType.response) {
        dynamic e = error.error;
        if (e is SocketException) {
          return NetError(socketError, "网络异常，请检查你的网络！");
        }
        if (e is HttpException) {
          return NetError(httpError, "服务器异常！");
        }
        return NetError(error.response.statusCode, "网络异常，请检查你的网络！");
      } else if (error.type == DioErrorType.connectTimeout ||
          error.type == DioErrorType.sendTimeout ||
          error.type == DioErrorType.receiveTimeout) {
        return NetError(timeoutError, "连接超时！");
      } else if (error.type == DioErrorType.cancel) {
        return NetError(cancelError, "取消请求");
      } else {
        return NetError(unknownError, "未知异常");
      }
    } else {
      return NetError(unknownError, "未知异常");
    }
  }
}

class NetError {
  int code;
  String msg;

  NetError(this.code, this.msg);
}
