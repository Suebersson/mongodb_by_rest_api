import 'package:convert_json/convert_json_lib.dart';

/// https://www.mongodb.com/docs/atlas/app-services/data-api/data-formats/
abstract final class Json {

  static final List<ObjectTreatment> treatments = List.unmodifiable([
    ObjectTreatment(
      test: (object) => object is DateTime, 
      treat: (object) {
        // https://www.mongodb.com/docs/atlas/app-services/data-api/data-formats/#date
        object as DateTime;
        return {'\$date': object.toIso8601String()};
      },
    ),
    ObjectTreatment(
      test: (object) => object is RegExp, 
      treat: (object) {
        // https://www.mongodb.com/pt-br/docs/v6.0/reference/operator/query/regex/
        object as RegExp;
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
  ]);

  static String encode(Object codable) {
    return ConvertJson.encode(
      codable,
      treatments: treatments,
    );
  }

}