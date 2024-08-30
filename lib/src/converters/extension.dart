import 'dart:convert' as convert;
import 'dart:typed_data' show Uint8List;

import './convert_json.dart';

/// Auxiliar para converter objetos [String]
extension ConverterForString on String {

  Uint8List get base64ToBytes => convert.base64.decode(this);

  Uint8List get utf8ToBytes => convert.utf8.encode(this);

  dynamic get decodeJson => ConvertJson.decode(this);

}

// /// Auxiliar para converter objetos [Map] em json
// extension ConverterForMap on Map<String, dynamic> {
//   String get toJson => ConvertJson.encode(this);
// }

// /// Auxiliar para converter objetos [List] em json
// extension ConverterForLit on List<dynamic> {
//   String get toJson => ConvertJson.encode(this);
// }

/// Auxiliar para converter objetos [Map], [List], [Object] em json
extension ConverterForObject on Object {
  String get toJson => ConvertJson.encode(this);
}
