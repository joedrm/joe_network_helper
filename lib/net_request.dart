import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'base_entity.dart';
import 'dio_helper.dart';
import 'error_handle.dart';
import 'mixins_handle.dart';
import 'net_config.dart';

class NetRequest {
  /// Get
  static get<T>({
    String url,
    Map<String, dynamic> queryParams,
    NetSuccessCallback<T> success,
    NetSuccessListCallback<T> successList,
    NetErrorCallback error,
    NoNetCallback noNet,
    CancelToken cancelToken,
    Options options,
    CommonExceptionHandle exceptionHandle,
  }) {
    _fetchData<T>(Method.get.value, url,
            queryParams: queryParams,
            cancelToken: cancelToken,
            options: options,
            noNet: noNet)
        .then((value) =>
            _handleResult(value, success, successList, error, exceptionHandle))
        .onError((e, stackTrace) => _handleError(e, url, error));
  }

  /// Post
  static post<T>({
    String url,
    dynamic params,
    NetSuccessCallback<T> success,
    NetSuccessListCallback<T> successList,
    NetErrorCallback error,
    NoNetCallback noNet,
    CancelToken cancelToken,
    Options options,
    CommonExceptionHandle exceptionHandle,
  }) {
    _fetchData<T>(Method.post.value, url,
            postData: params,
            cancelToken: cancelToken,
            options: options,
            noNet: noNet)
        .then((value) =>
            _handleResult(value, success, successList, error, exceptionHandle))
        .onError((e, stackTrace) => _handleError(e, url, error));
  }

  /// Delete
  static delete<T>({
    String url,
    dynamic params,
    NetSuccessCallback<T> success,
    NetSuccessListCallback<T> successList,
    NetErrorCallback error,
    NoNetCallback noNet,
    CancelToken cancelToken,
    Options options,
    CommonExceptionHandle exceptionHandle,
  }) {
    _fetchData<T>(Method.delete.value, url,
            postData: params,
            cancelToken: cancelToken,
            options: options,
            noNet: noNet)
        .then((value) =>
            _handleResult(value, success, successList, error, exceptionHandle))
        .onError((e, stackTrace) => _handleError(e, url, error));
  }

  static patch<T>({
    String url,
    dynamic params,
    NetSuccessCallback<T> success,
    NetSuccessListCallback<T> successList,
    NetErrorCallback error,
    NoNetCallback noNet,
    CancelToken cancelToken,
    Options options,
    CommonExceptionHandle exceptionHandle,
  }) {
    _fetchData<T>(Method.patch.value, url,
            postData: params,
            cancelToken: cancelToken,
            options: options,
            noNet: noNet)
        .then((value) =>
            _handleResult(value, success, successList, error, exceptionHandle))
        .onError((e, stackTrace) => _handleError(e, url, error));
  }

  static Future<BaseEntity<T>> _fetchData<T>(
    String method,
    String url, {
    Map<String, dynamic> queryParams,
    dynamic postData,
    NoNetCallback noNet,
    CancelToken cancelToken,
    Options options,
  }) async {
    /// 检查网络状态
    ConnectivityResult connectionStatus = await _checkNetwork();
    if (connectionStatus == ConnectivityResult.none) {
      // SGToast.show("好像没有网络了~");
      // ProgressLoading.dismiss();
      if (noNet != null) {
        noNet(true);
      }
      return BaseEntity(ExceptionHandle.noNetWork, '好像没有网络了~', null, 0);
    }
    Response<String> response = await DioHelper().request(method, url,
        data: postData,
        queryParams: queryParams,
        cancelToken: cancelToken,
        options: options);
    try {
      final String data = response.data.toString();
      final bool isCompute =
          !NetConfig.isDriverTest && data.length > 10 * 1024;
      final Map<String, dynamic> _map =
          isCompute ? await compute(_parseData, data) : _parseData(data);
      return BaseEntity<T>.fromJson(_map);
    } catch (e) {
      return BaseEntity(ExceptionHandle.noNetWork, '好像没有网络了~', null, 0);
    }
  }

  static _handleResult<T>(
    BaseEntity baseEntity,
    NetSuccessCallback<T> success,
    NetSuccessListCallback<T> successList,
    NetErrorCallback error,
    CommonExceptionHandle exceptionHandle,
  ) {
    if (baseEntity == null) {
      return;
    }
    if (baseEntity.code == 0) {
      if (success != null) {
        success(baseEntity.data);
      }
      if (successList != null) {
        successList(baseEntity.listData, baseEntity.nextPage);
      }
    } else if (baseEntity.code == ExceptionHandle.unauthorized) {
      // ProgressLoading.dismiss();
      if (exceptionHandle != null) {
        exceptionHandle.handleUnauthorized();
      }

      if (NetConfig.exceptionHandle != null) {
        NetConfig.exceptionHandle.handleUnauthorized();
      }

      /// 直接跳转到登录页面，业务层不作处理。
      _onError(baseEntity.code, baseEntity.message, error);
    } else if (baseEntity.code == ExceptionHandle.noNetWork) {
      if (exceptionHandle != null) {
        exceptionHandle.handleNoNetwork(baseEntity.code, baseEntity.message);
      }
      if (NetConfig.exceptionHandle != null) {
        NetConfig.exceptionHandle
            .handleNoNetwork(baseEntity.code, baseEntity.message);
      }
      _onError(baseEntity.code, baseEntity.message, error);
    } else {
      _onError(baseEntity.code, baseEntity.message, error);
    }
  }

  static void _handleError(dynamic er, String url, NetErrorCallback onError) {
    _cancelLogPrint(er, url);
    final NetError error = ExceptionHandle.handleException(er);
    if (error != null) {
      _onError(error.code, error.msg, onError);
    }
  }

  static void _onError(int code, String msg, NetErrorCallback onError) {
    if (code == null) {
      code = ExceptionHandle.unknownError;
      msg = '未知异常';
    }
    if (onError != null) {
      // Log.e('接口请求异常： code: $code, mag: $msg; onError = $onError');
      onError(code, msg);
    }
  }

  static Map<String, dynamic> _parseData(String data) {
    if (data == null || data.isEmpty) {
      return {};
    }
    return json.decode(data) as Map<String, dynamic>;
  }

  static Future<ConnectivityResult> _checkNetwork() async {
    return await Connectivity().checkConnectivity();
  }

  static void _cancelLogPrint(dynamic e, String url) {
    if (e is DioError && CancelToken.isCancel(e)) {
      // Log.e('取消请求接口： $url');
    }
  }
}
