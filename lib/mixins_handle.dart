mixin CommonExceptionHandle {
  /// 没有请求权限
  void handleUnauthorized();

  /// 无网络环境
  void handleNoNetwork(int code, String message);
}

mixin EntityGenerateHandle {
  T generateOBJ<T>(json);
}
