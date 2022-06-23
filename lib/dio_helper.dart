import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

import 'net_config.dart';

class DioHelper {
  factory DioHelper() => _singleton;

  static DioHelper get instance => DioHelper();
  static final DioHelper _singleton = DioHelper._();

  static Dio _dio;

  Dio get dio => _dio;
  ConnectivityResult connectionStatus;

  DioHelper._() {
    final BaseOptions _options = BaseOptions(
      connectTimeout: NetConfig.connectTimeout,
      receiveTimeout: NetConfig.receiveTimeout,
      sendTimeout: NetConfig.sendTimeout,
      responseType: ResponseType.plain,
      validateStatus: (_) {
        return true;
      },
      baseUrl: NetConfig.baseUrl,
    );
    _dio = Dio(_options);

    /// 设置拦截器
    for (var interceptor in NetConfig.interceptors) {
      _dio.interceptors.add(interceptor);
    }

    /// 检查网络
    Connectivity().checkConnectivity().then((value) {
      connectionStatus = value;
    });

    /// 设置代理，用来抓包
    setProxy();
  }

  void setBaseUrl() {
    if (NetConfig.baseUrl == null || NetConfig.baseUrl.isEmpty) return;
    _dio.options.baseUrl = NetConfig.baseUrl;
  }

  void setProxy() {
    if (!NetConfig.proxyEnable) return;
    if (NetConfig.proxyIp == null || NetConfig.proxyIp.isEmpty) return;
    if (NetConfig.proxyPort == null) return;
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.findProxy = (uri) {
        return "PROXY ${NetConfig.proxyIp}:${NetConfig.proxyPort}";
      };

      /// 代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以禁用证书校验
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    // Log.e("setProxy ${NetConfig.proxyIp}:${NetConfig.proxyPort}");
  }

  Future<Response<String>> request<T>(String method, String url,
      {dynamic data,
      Map<String, dynamic> queryParams,
      CancelToken cancelToken,
      Options options}) async {
    return await _dio.request<String>(
      url,
      data: data,
      queryParameters: queryParams,
      options: _checkOptions(method, options),
      cancelToken: cancelToken,
    );
  }

  Options _checkOptions(String method, Options options) {
    options ??= Options();
    options.method = method;
    return options;
  }
}
