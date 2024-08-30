import 'dart:developer' show log;

import './converters/extension.dart';
import './mongodb_request_data.dart';

final class MongoDBRequestResult {
  
  const MongoDBRequestResult({
    required this.success,
    required this.statusCode, 
    required this.body, 
    required this.headers,
  });
  
  final bool success;
  final int statusCode;
  final String body;
  final Map<String, String> headers;

  Map<String, dynamic> get bodyData {
    try {
      return body.decodeJson;
    } on TypeError catch (error, stackTrace) {
      final String message = 'Erro ao tentar definir/atribuir um objeto em uma '
        'variavel/atributo com tipo diferente';
      log(
        message,
        name: '$MongoDBRequestResult > bodyData',
        error: error,
        stackTrace: stackTrace, 
      );
      throw MongoDBRequestResultExeception(message);
    } catch (error, stackTrace) {
      final String message = 'Erro não tratado ao tentar converter o json[body] para uma Map<String, dynamic>';
      log(
        message,
        name: '$MongoDBRequestResult > bodyData',
        error: error,
        stackTrace: stackTrace, 
      );
      throw MongoDBRequestResultExeception(message);
    }
  }

  String get contentType => headers['content-type'] ?? headers['Content-type'] 
    ?? headers['Content-Type'] ?? ''; 

  Map<String, dynamic> get toMap => {
    'success': success,
    'statusCode': statusCode,
    'body': body,
    'headers': headers,
  };

  static final MongoDBRequestResult undefinedResult = const MongoDBRequestResult(
    success: false, 
    statusCode: 0, 
    body: '', 
    headers: {},
  );

  MongoDBRequestData get dataReceived => MongoDBRequestData.fromMap(bodyData);

  factory MongoDBRequestResult.errorInRequest(String message) {
    return undefinedResult.copyWith(body: message);
  } 

  // https://httpstatuses.io/
  bool get isStatusCodeFamily100 => statusCode >= 100 && statusCode <= 103;
  bool get isStatusCodeFamily200 => statusCode >= 200 && statusCode <= 226;
  bool get isStatusCodeFamily300 => statusCode >= 300 && statusCode <= 308;
  bool get isStatusCodeFamily400 => statusCode >= 400 && statusCode <= 499;
  bool get isStatusCodeFamily500 => statusCode >= 500 && statusCode <= 599;

  bool get contentTypeIsApplicationJson {
    return headers['content-type']?.contains('application/json') 
      ?? headers['Content-type']?.contains('application/json') 
      ?? headers['Content-Type']?.contains('application/json') 
      ?? false;
  }

  factory MongoDBRequestResult.fromMap(Map<String, dynamic> map) {
    return MongoDBRequestResult(
      success: map['success'] ?? false,
      statusCode: map['statusCode'] ?? 0,
      body: map['body'] ?? '',
      headers: map['headers'] ?? {},
    );
  }

  MongoDBRequestResult copyWith({
    bool? success, 
    int? statusCode,
    String? body,
    Map<String, String>? headers,
  }) {
    return MongoDBRequestResult(
      success: success ?? this.success,
      statusCode: statusCode ?? this.statusCode,
      body: body ?? this.body,
      headers: headers ?? this.headers,
    );
  }

  @override
  String toString() => '$runtimeType($toMap)'.replaceAll(RegExp('{|}'), '');

}

final class MongoDBRequestResultExeception implements Exception {
  final String message;
  const MongoDBRequestResultExeception(this.message);
  @override
  String toString() => message;
}