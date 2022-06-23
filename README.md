<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

网络请求工具类

## Features

- 封装GET、POST、PUT、PATCH、DELETE等常见请求。
- 数据解析处理mixin，直接在业务工程实现。
- 异常处理和拦截器。
- 可配置代理，方便抓包调试。


## Getting started
```yaml
dependencies:
  joe_network_helper: ^0.0.1
```

## Using

```dart
NetRequest.post<Model>(url: "",params: {},success: (Model result) {},error: (code, msg) {});
```
