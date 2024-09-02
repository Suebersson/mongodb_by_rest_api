import 'dart:async' show FutureOr;
import 'dart:io' show SocketException;
import 'dart:convert' show Encoding;
import 'dart:developer' show log;
import 'package:http/http.dart' as http;

import './mongodb_request_result.dart';

abstract final class ClientService {

  static Future<MongoDBRequestResult> get({required Uri uri, Map<String, String>? headers}) {

    return _tryRequest(
      name: '$ClientService.get', 
      request: () async{
        
        final http.Response response = await http.get(uri, headers: headers);

        return MongoDBRequestResult(
          success: true, 
          statusCode: response.statusCode, 
          body: response.body, 
          headers: response.headers,
        );

      },
    );

  }

  static Future<MongoDBRequestResult> post({
    required Uri uri, Object? body, Map<String, String>? headers, Encoding? encoding,}) {

    return _tryRequest(
      name: '$ClientService.post', 
      request: () async{

        final http.Response response = await http.post(
          uri,
          body: body,
          headers: headers,
          encoding: encoding,
        );

        return MongoDBRequestResult(
          success: true, 
          statusCode: response.statusCode, 
          body: response.body, 
          headers: response.headers,
        );

      },
    );

  }

  static Future<MongoDBRequestResult> put({
    required Uri uri, Object? body, Map<String, String>? headers, Encoding? encoding,}) {

    return _tryRequest(
      name: '$ClientService.put', 
      request: () async{
        
        final http.Response response = await http.put(
          uri,
          body: body,
          headers: headers,
          encoding: encoding,
        );

        return MongoDBRequestResult(
          success: true, 
          statusCode: response.statusCode, 
          body: response.body, 
          headers: response.headers,
        );

      },
    );

  }

  static Future<MongoDBRequestResult> delete({
    required Uri uri, Object? body, Map<String, String>? headers, Encoding? encoding,}) {

    return _tryRequest(
      name: '$ClientService.delete',
      request: () async{
        
        final http.Response response = await http.delete(
          uri,
          body: body,
          headers: headers,
          encoding: encoding,
        );

        return MongoDBRequestResult(
          success: true, 
          statusCode: response.statusCode, 
          body: response.body, 
          headers: response.headers,
        );

      },
    );

  }

  static Future<MongoDBRequestResult> head({required Uri uri, Map<String, String>? headers,}) {

    return _tryRequest(
      name: '$ClientService.head', 
      request: () async{
        
        final http.Response response = await http.head(
          uri,
          headers: headers,
        );

        return MongoDBRequestResult(
          success: true, 
          statusCode: response.statusCode, 
          body: response.body, 
          headers: response.headers,
        );

      },
    );

  }

  static Future<MongoDBRequestResult> _tryRequest({
    required String name, required FutureOr<MongoDBRequestResult> Function() request,}) async{

    try {
    
      return await request.call();

    } on ArgumentError catch(error, stackTrace) {
      log(
        'Verifique se a url está correta no padrão [http://...] ou [https://...]',
        name: name,
        error: error,
        stackTrace: stackTrace,
      );
      return MongoDBRequestResult.undefinedResult;
    } on SocketException catch(error, stackTrace) {
      log(
        'Antes de fazer a requisição verifique se existe conexão com à internet',
        name: name,
        error: error,
        stackTrace: stackTrace,
      );
      return MongoDBRequestResult.undefinedResult;
    } on http.ClientException catch(error, stackTrace) {
      log(
        'Falha na requisição http',
        name: name,
        error: error,
        stackTrace: stackTrace,
      );
      return MongoDBRequestResult.undefinedResult;
    } catch(error, stackTrace) {
      log(
        'Erro não tratado ao tentar fazer requisição http',
        name: name,
        error: error,
        stackTrace: stackTrace,
      );
      return MongoDBRequestResult.undefinedResult;
    }

  }

}

final class ClientServiceExeception implements Exception {
  final String message;
  const ClientServiceExeception(this.message);
  @override
  String toString() => message;
}