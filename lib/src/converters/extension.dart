import 'dart:convert' as convert;
import 'dart:typed_data' show Uint8List;

import './convert_json.dart';

/// Auxiliar para converter objetos [String]
extension ConverterForString on String {

  Uint8List get base64ToBytes => convert.base64.decode(this);

  Uint8List get utf8ToBytes => convert.utf8.encode(this);

  dynamic get decodeJson => ConvertJson.decode(this);

}

/// Auxiliar para converter objetos [Map] em json
extension ConverterForMap on Map<String, dynamic> {
  String get toJson => _toJson(this);
}

/// Auxiliar para converter objetos [List] em json
extension ConverterForLit on List<dynamic> {
  String get toJson => _toJson(this);
}

// /// Auxiliar para converter objetos [Map], [List], [Object] em json
// extension ConverterForObject on Object {
//   String get toJson => ConvertJson.encode(
//     this,
//     treatments: [
//       ObjectTreatment(
//         test: (object) => object is DateTime, 
//         treat: (object) {
//           object as DateTime;
//           return {'\$date': object.toIso8601String()};
//         },
//       ),
//       ObjectTreatment(
//         test: (object) => object is RegExp, 
//         treat: (object) {
//           object as RegExp;
//           // https://www.mongodb.com/pt-br/docs/v6.0/reference/operator/query/regex/
//           final Map<String, String> regex = {'\$regex': object.pattern};
//           if (object.isDotAll) {
//             regex.update(
//               '\$options', 
//               (options) => options += 's',
//               ifAbsent: () => 's',
//             );
//           }
//           if (!object.isCaseSensitive) {
//             regex.update(
//               '\$options', 
//               (options) => options += 'i',
//               ifAbsent: () => 'i',
//             );
//           }
//           if (object.isMultiLine) {
//             regex.update(
//               '\$options', 
//               (options) => options += 'm',
//               ifAbsent: () => 'm',
//             );
//           }
//           if (object.isUnicode) {
//             regex.update(
//               '\$options', 
//               (options) => options += 'u',
//               ifAbsent: () => 'u',
//             );
//           }
//           return regex;
//         },
//       ),
//     ],
//   );
// }

String _toJson(Object codable) {
  return ConvertJson.encode(
    codable,
    treatments: [
      ObjectTreatment(
        test: (object) => object is DateTime, 
        treat: (object) {
          object as DateTime;
          return {'\$date': object.toIso8601String()};
        },
      ),
      ObjectTreatment(
        test: (object) => object is RegExp, 
        treat: (object) {
          object as RegExp;
          // https://www.mongodb.com/pt-br/docs/v6.0/reference/operator/query/regex/
          final Map<String, String> regex = {'\$regex': object.pattern};
          if (object.isDotAll) {
            regex.update(
              '\$options', 
              (options) => options += 's',
              ifAbsent: () => 's',
            );
          }
          if (!object.isCaseSensitive) {
            regex.update(
              '\$options', 
              (options) => options += 'i',
              ifAbsent: () => 'i',
            );
          }
          if (object.isMultiLine) {
            regex.update(
              '\$options', 
              (options) => options += 'm',
              ifAbsent: () => 'm',
            );
          }
          if (object.isUnicode) {
            regex.update(
              '\$options', 
              (options) => options += 'u',
              ifAbsent: () => 'u',
            );
          }
          return regex;
        },
      ),
    ],
  );
}