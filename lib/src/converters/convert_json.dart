import 'dart:convert';

import '../query.dart';

abstract final class ConvertJson {

  static final RegExp intPattern = RegExp('^[0-9]{1,}\$');
  static final RegExp doublePattern = RegExp('^[0-9]{1,}\\.[0-9]{1,}\$');
  static final RegExp datePattern = RegExp(r'^(\d{4}-\d{2}-\d{2})|(-\d{4}-\d{2}-\d{2})');
  static final RegExp boolPattern = RegExp('^(true|false)\$', caseSensitive: false);

  /// Essa função não dispensa tratamentos de erros
  static O decode<O>(String encoded) {

    if (encoded.isEmpty) {
      throw const ConvertJsonExeception('Não é possível decodificar e criar um objeto com a string vazia');
    }

    encoded = adjustReformattedJson(encoded);

    return json.decode(
      encoded, 
      reviver: (key, value) {
        try {
          if (value is String && datePattern.hasMatch(value)) {
            return DateTime.tryParse(value) ?? value;
          } else if (value is String && boolPattern.hasMatch(value)) {
            return bool.tryParse(value, caseSensitive: false) ?? value;
          } else if(value is String && intPattern.hasMatch(value)) {
            return int.tryParse(value) ?? value;
          } else if(value is String && doublePattern.hasMatch(value)) {
            return double.tryParse(value) ?? value;
          } else {
            return value;
          }
        } on FormatException {
          return value;
        } catch (_) {
          return value;
        }
      },
    );

  }

  /// Tipos de objetos padrão para o formato json Key:[String], Key:[int], Key:[bool] ou Key:[Null]
  /// 
  /// Tipos de objetos que podem ser codificados [Map<String, dynamic>], [Map<String, Object>],
  /// [Map<String, String>], [List<Map<String, dynamic>>], [List<String|int|double|bool>], ...
  ///
  /// É uma [Map] ou uma [List] com instâncias de [Object], essa função deve ser usada com cuidado 
  /// e não dispensa o uso de tratamentos de erro onde ela será usada
  static String encode(Object object) {
    return json.encode(
      object, 
      toEncodable: (dynamic object) {
        if (object is Enum) {
          return object.toString();
        } else if (object is DateTime) {
          // return object.toIso8601String();
          return {'\$date':object.toIso8601String()};
        } else if (object is Query) {
          return object.filter;
        } else {
          // Exeception que será emitida se o objeto for icompatível para o formato 
          // JSON [JsonUnsupportedObjectError] caso essa função seja defina
          throw ConvertJsonExeception(
            'Tipos objetos compatíveis para o formato json Key:[String], Key:[int], Key:[double], Key:[bool], '
            'Key:[Null], Key:[List], Key:[Map]\n\n'
            'Tipo de objeto não tratado para converter para o formato '  
            'json, faça uma implementação condicional para processar e tratar este tipo de '
            'objeto[${object.runtimeType}] ou converta para algum tipo compatível');
        }
      },
    );
  }

  static dynamic tryDecode(String encoded, {required dynamic Function() alternativeValue}) {
    try {
      return decode(encoded);
    } on FormatException {
      // A string é vazia ou é icompatível com formato JSON
      return alternativeValue.call();
    } on ConvertJsonExeception {
      // A string é vazia ou é incompatível com formato JSON
      return alternativeValue.call();
    } catch (_) {
      // Ocorreu algum erro não tratados ao tentar decodificar a string para o formato JSON
      return alternativeValue.call();
    }
  }

  static dynamic tryDecodeOrNull(String encoded) {
    try {
      return decode(encoded);
    } on FormatException {
      // A string é vazia ou é icompatível com formato JSON
      return null;
    } on ConvertJsonExeception {
      // A string é vazia ou é icompatível com formato JSON
      return null;
    } catch (_) {
      // Ocorreu algum erro não tratados ao tentar decodificar a string para o formato JSON
      return null;
    }
  }

  /// Ajustar strings json formatada dentro de outro json
  /// 
  /// [{"item":"{\"contains\":\"false\"}"}]
  static String adjustReformattedJson(String json) {
    return json.replaceAll('"{\\"', '{"').replaceAll('\\"}"', '"}').replaceAll('\\"', '"');
  }

}

final class ConvertJsonExeception implements Exception {
  final String message;
  const ConvertJsonExeception(this.message);
  @override
  String toString() => message;
}