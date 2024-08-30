import 'dart:convert' show Encoding;
import 'package:http/http.dart' as http;

import './mongodb_request_result.dart';

abstract final class ClientService {

  static Future<MongoDBRequestResult> get({required Uri uri, Map<String, String>? headers}) async{

    try {

      final http.Response response = await http.get(uri, headers: headers);

      return MongoDBRequestResult(
        success: true, 
        statusCode: response.statusCode, 
        body: response.body, 
        headers: response.headers,
      );

    } catch(error) {
      return MongoDBRequestResult.undefinedResult;
    }

  }

  static Future<MongoDBRequestResult> post({
    required Uri uri, Object? body, Map<String, String>? headers, Encoding? encoding,}) async{

    try{
    
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

    } catch(error) {
      return MongoDBRequestResult.undefinedResult;
    }

  }

  static Future<MongoDBRequestResult> put({
    required Uri uri, Object? body, Map<String, String>? headers, Encoding? encoding,}) async{

    try{
    
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

    } catch(error) {
      return MongoDBRequestResult.undefinedResult;
    }

  }

  static Future<MongoDBRequestResult> delete({
    required Uri uri, Object? body, Map<String, String>? headers, Encoding? encoding,}) async{

    try{
    
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

    } catch(error) {
      return MongoDBRequestResult.undefinedResult;
    }

  }

  static Future<MongoDBRequestResult> head({
    required Uri uri, Map<String, String>? headers,}) async{

    try{
    
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

    } catch(error) {
      return MongoDBRequestResult.undefinedResult;
    }

  }

}