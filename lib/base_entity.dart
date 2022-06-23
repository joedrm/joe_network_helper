

import 'net_config.dart';

class BaseEntity<T> {
  int code;
  String message;
  T data;
  List<T> listData = [];
  int nextPage;

  BaseEntity(this.code, this.message, this.data, this.nextPage);

  BaseEntity.fromJson(Map<String, dynamic> json) {
    code = json[NetConfig.code];
    message = json[NetConfig.message];
    if (json.containsKey(NetConfig.data)) {
      if (json[NetConfig.data] is List) {
        for (var item in (json[NetConfig.data] as List)) {
          listData.add(_generateContentBody<T>(item));
        }
      } else {
        if ((json[NetConfig.data] is Map) &&
            json[NetConfig.data]["results"] != null &&
            (json[NetConfig.data]["results"] is List)) {
          if (json[NetConfig.data]["next"] != null) {
            nextPage = int.parse(
                json[NetConfig.data]["next"].split('page=')[1].split('&')[0]);
          }
          for (var item in (json[NetConfig.data]["results"] as List)) {
            listData.add(_generateContentBody<T>(item));
          }
          return;
        }
        // print("print(json[NetConfig.data]) 22 = $json");
        data = _generateContentBody(json[NetConfig.data]);
      }
    }
  }

  S _generateContentBody<S>(json) {
    if (S.toString() == "String") {
      return json.toString() as S;
    } else if (T.toString() == "String") {
      return json.toString() as S;
    } else if (T.toString() == "Map<dynamic, dynamic>") {
      return json as S;
    } else {
      if (json is Map && NetConfig.generateOBJ != null) {
        return NetConfig.generateOBJ<S>(json);
      }
      if (json is Map && NetConfig.generateHandle != null) {
        return NetConfig.generateHandle.generateOBJ<S>(json);
      }
      return json;
    }
  }
}
