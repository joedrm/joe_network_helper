import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sprintf/sprintf.dart';
import 'error_handle.dart';

class BaseInterceptor extends Interceptor {


}
//
//
// class AdapterInterceptor extends BaseInterceptor {
//   static const String msg = "msg";
//   static const String slash = "\"";
//   static const String detail = "detail";
//   static const String non_field_errors = "non_field_errors";
//
//   static const String defaultText = "\"无返回信息\"";
//   static const String notFound = "未找到查询信息";
//
//   static const String failureFormat = "{\"code\":%d,\"message\":\"%s\"}";
//   static const String successFormat =
//       "{\"code\":0,\"data\":%s,\"message\":\"\"}";
//
//   @override
//   onResponse(Response response, ResponseInterceptorHandler handler) {
//     // print("=========response======== $response");
//     Response r = adapterData(response);
//     return super.onResponse(r, handler);
//   }
//
//   @override
//   onError(DioError err, ErrorInterceptorHandler handler) {
//     // print("=========err======== $err");
//     if (err.response != null) {
//       adapterData(err.response);
//     }
//     return super.onError(err, handler);
//   }
//
//   Response adapterData(Response response) {
//     String result;
//     String content = response.data == null ? "" : response.data.toString();
//     /// 成功时，直接格式化返回
//     if (response.statusCode == ExceptionHandle.success ||
//         response.statusCode == ExceptionHandle.success201 ||
//         response.statusCode == ExceptionHandle.successNotContent) {
//       if (content == null || content.isEmpty) {
//         content = defaultText;
//       }
//       result = sprintf(successFormat, [content]);
//       response.statusCode = ExceptionHandle.success;
//     } else {
//       if (response.statusCode == ExceptionHandle.notFound) {
//         /// 错误数据格式化后，按照成功数据返回
//         result = sprintf(failureFormat, [response.statusCode, notFound]);
//         response.statusCode = ExceptionHandle.success;
//       } else {
//         if (content == null || content.isEmpty) {
//           // 一般为网络断开等异常
//           result = content;
//         } else {
//           String msg;
//           try {
//             content = content.replaceAll("\\", "");
//             if (slash == content.substring(0, 1)) {
//               content = content.substring(1, content.length - 1);
//             }
//             Map<String, dynamic> map = json.decode(content);
//             if (map.containsKey(detail)) {
//               msg = map[detail];
//             } else if (map.containsKey(non_field_errors)) {
//               if (map[non_field_errors] is List) {
//                 msg = map[non_field_errors][0];
//               }
//             } else if (map.containsKey(msg)) {
//               msg = map[msg];
//             } else {
//               msg = "未知异常";
//             }
//             result = sprintf(failureFormat, [response.statusCode, msg]);
//             // 401 token失效时，单独处理，其他一律为成功
//             if (response.statusCode == ExceptionHandle.unauthorized) {
//               response.statusCode = ExceptionHandle.unauthorized;
//             } else {
//               response.statusCode = ExceptionHandle.success;
//             }
//           } catch (e) {
//             // Log.d("异常信息：$e");
//             // 解析异常直接按照返回原数据处理（一般为返回500,503 HTML页面代码）
//             result = sprintf(failureFormat,
//                 [response.statusCode, "服务器异常(${response.statusCode})"]);
//           }
//         }
//       }
//     }
//     response.data = result;
//     return response;
//   }
// }
