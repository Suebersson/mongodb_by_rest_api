import 'dart:convert' as convert;
import 'dart:typed_data' show Uint8List;
import 'package:convert_json/convert_json_lib.dart';

import './json.dart';

/// Auxiliar para converter objetos [String]
extension ConvertForString on String {

  Uint8List get base64ToBytes => convert.base64.decode(this);

  Uint8List get utf8ToBytes => convert.utf8.encode(this);

  dynamic get decodeJson => ConvertJson.decode(this);

}

/// Auxiliar para converter objetos [Map] em json
extension ConvertForMap on Map<String, dynamic> {
  String get toJson => Json.encode(this);
}

/// Auxiliar para converter objetos [List] em json
extension ConvertForLit on List<dynamic> {
  String get toJson => Json.encode(this);
}