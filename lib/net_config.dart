import 'package:dio/dio.dart';
import 'dio_helper.dart';
import 'intercept.dart';
import 'mixins_handle.dart';

enum Method { get, post, put, patch, delete, head }



extension MethodExtension on Method {
  String get value => ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'HEAD'][index];
}

typedef NetSuccessCallback<T> = Function(T data);
typedef HandleOriginalResponseData<T> = Function(T data);
typedef NetSuccessListCallback<T> = Function(List<T> data, int page);
typedef NetErrorCallback = Function(int code, String msg);
typedef NoNetCallback = Function(bool isNoNet);
typedef GenerateOBJ = T Function<T>(dynamic json);

/// 网络配置
class NetConfig {

  static const String data = 'data';
  static const String message = 'message';
  static const String code = 'code';

  static int _connectTimeout = 5000;
  static int _receiveTimeout = 5000;
  static int _sendTimeout = 5000;
  static String _baseUrl;
  static String _devUrl;
  static String _proUrl;
  static String _stagingUrl;
  static List<Interceptor> _interceptors = [
    // LoggingInterceptor(),
    // AdapterInterceptor(),
  ];
  static bool _useDefaultInterceptor = true;
  static bool _proxyEnable = false;
  static bool _isDriverTest = false;
  static String _proxyIp = "";
  static int _proxyPort;
  static String _contentType = "application/json;charset=UTF-8";
  static String _mqttSubUri = "base/event/subscribe/";
  static GenerateOBJ _generateOBJ;
  static EntityGenerateHandle _generateHandle;
  static CommonExceptionHandle _exceptionHandle;

  static int get connectTimeout => _connectTimeout;
  static int get receiveTimeout => _receiveTimeout;
  static int get sendTimeout => _sendTimeout;
  static String get baseUrl => _baseUrl;
  static String get devUrl => _devUrl;
  static String get proUrl => _proUrl;
  static String get stagingUrl => _stagingUrl;
  static List<Interceptor> get interceptors => _interceptors;
  static bool get proxyEnable => _proxyEnable;
  static String get proxyIp => _proxyIp;
  static int get proxyPort => _proxyPort;
  static String get contentType => _contentType;
  static String get mqttSubUri => _mqttSubUri;
  static GenerateOBJ get generateOBJ => _generateOBJ;
  static EntityGenerateHandle get generateHandle => _generateHandle;
  static CommonExceptionHandle get exceptionHandle => _exceptionHandle;
  static bool get useDefaultInterceptor => _useDefaultInterceptor;
  static bool get isDriverTest => _isDriverTest;

  static config(
      {int connectTimeout,
      int receiveTimeout,
      int sendTimeout,
      String baseUrl,
      String devUrl,
      String proUrl,
      String stagingUrl,
      bool useDefaultInterceptor,
      bool proxyEnable,
      String proxyIp,
      int proxyPort,
      String contentType,
      String mqttSubUri,
      List<Interceptor> ints,
      GenerateOBJ generateOBJ,
      EntityGenerateHandle generateHandle,
      CommonExceptionHandle exceptionHandle}) {
    _connectTimeout = connectTimeout ?? _connectTimeout;
    _receiveTimeout = receiveTimeout ?? _receiveTimeout;
    _sendTimeout = sendTimeout ?? _sendTimeout;
    _interceptors = interceptors ?? _interceptors;
    _contentType = contentType ?? _contentType;
    _generateOBJ = generateOBJ;
    _generateHandle = generateHandle;
    _exceptionHandle = exceptionHandle;
    _useDefaultInterceptor = useDefaultInterceptor ?? true;
    if (!_useDefaultInterceptor) {
      _interceptors.clear();
    }
    if (ints != null && ints.isNotEmpty) {
      for (var interceptor in ints) {
        _interceptors.add(interceptor);
      }
    }
    _devUrl = devUrl ?? _devUrl;
    _proUrl = proUrl ?? _proUrl;
    _stagingUrl = stagingUrl ?? _stagingUrl;
    setMqttSubUri(mqttSubUri);
    setBaseUrl(baseUrl ?? proUrl ?? devUrl ?? stagingUrl);
    proxy(proxyEnable, proxyIp, proxyPort);
  }

  /// 配置代理
  static proxy(
    bool proxyEnable,
    String proxyIp,
    int proxyPort,
  ) {
    _proxyEnable = proxyEnable ?? _proxyEnable;
    _proxyIp = proxyIp ?? _proxyIp;
    _proxyPort = proxyPort ?? _proxyPort;
    DioHelper().setProxy();
  }

  /// 设置主域名，由于切换网络环境
  static setBaseUrl(
    String baseUrl,
  ) {
    _baseUrl = baseUrl ?? _baseUrl;
    DioHelper().setBaseUrl();
  }

  /// 设置请求MQTT订阅参数的URI
  static setMqttSubUri(String mqttSubUri) {
    _mqttSubUri = mqttSubUri ?? _mqttSubUri;
  }
}
