// ignore_for_file: unused_field, unused_local_variable

import 'dart:typed_data' show Uint8List;
import 'package:crypto/crypto.dart';

import './interfaces/collection_methods.dart';
import './query.dart';
import './mongodb.dart';
import './converters/extension.dart';
import './client_service.dart';
import './mongodb_request_result.dart';
import './mongodb_request_data.dart';

final class Collection implements CollectionMethods {
  
  Collection._({
    required this.name, 
    required this.db,
  });

  factory Collection({required String name, required Mongodb db}) {
    if (db.signPayload && db.secretKeyBytes is! Uint8List) {
      throw const CollectionExeception('Defina a chave secreta[secretKeyBytes] para '
        'assinatura da payload');
    } else {
      return Collection._(name: name, db: db);
    }
  }

  final String name; 
  final Mongodb db;
  
  Map<String, dynamic> get sourceRequest => {
    ...db.source,
    'collection': name,
  };

  Map<String, String> headersRequest(Uint8List payloadBytes) {
    if (db.signPayload) {
      return db.copyHeaders..update(
        'Endpoint-Signature', 
        (_) => 'sha256=${signPayload(payloadBytes)}',
        ifAbsent: () => 'sha256=${signPayload(payloadBytes)}',
      );
    } else {
      return db.copyHeaders;
    }
  }
  
  String signPayload(Uint8List payloadBytes) {
    // HMAC-SHA256-Hex
    return Hmac(
      sha256, 
      db.secretKeyBytes ?? _generateException<Uint8List>('A chave secreta[secretKeyBytes] para '
        'assinatura da payload não foi definida'),
    ).convert(payloadBytes).toString(); 
  }

  T _generateException<T>(String message) => throw CollectionExeception(message);

  late final Uri 
    _uriFindOne = db.uriMethods.findOne, // post
    _uriFind = db.uriMethods.find, // post
    _uriInsertOne = db.uriMethods.insertOne, // post
    _uriInsertMany = db.uriMethods.insertMany, // post
    _uriUpdateOne = db.uriMethods.updateOne, // post
    _uriUpdateMany = db.uriMethods.updateMany, // post
    _uriDeleteOne = db.uriMethods.deleteOne, // post
    _uriDeleteMany = db.uriMethods.deleteMany, // post
    _uriAggregate = db.uriMethods.aggregate; // post

  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/aggregate
  @override
  Future<Map<String, dynamic>?> aggregate(Query query) {

    final Map<String, dynamic> body = sourceRequest;

    if (query.sort.isNotEmpty) {
      body.addAll({'sort': query.sort});
    }

    throw UnimplementedError();
  }
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/insertMany
  @override
  Future<Deleted> deleteMany(Query query) {

    final Map<String, dynamic> body = sourceRequest;

    throw UnimplementedError();
  }
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/updateOne
  @override
  Future<Deleted> deleteOne(Query query) {

    final Map<String, dynamic> body = sourceRequest;

    throw UnimplementedError();
  }
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/find
  @override
  Future<List<Map<String, dynamic>>> find(Query query, {TypeQuery type = TypeQuery.filter, int? limit}) async{
    // // todos os documentos com apenas os campos escificados
    // final Query where = query.$projection(['title', 'country', 'uf']);
    // final List<Map<String, dynamic>> data = await events.find(where);
    // print(data.length);

    // // todos os documentos
    // final List<Map<String, dynamic>> data = await events.find(query);
    // print(data.length);

    final Map<String, dynamic> body = sourceRequest;

    if (type == TypeQuery.filter && query.filter.isNotEmpty) {
      body.addAll({'filter': query.filter});
    } else {
      if (query.free is List || query.free is Map) {
        body.addAll({'filter': query.free});
      }
    }

    if (query.projection.isNotEmpty) {
      body.addAll({'projection': query.projection});
    }

    if (limit is int) {
      body.addAll({'limit': limit});
    }

    if (query.sort.isNotEmpty) {
      body.addAll({'sort': query.sort});
    }
    
    final Uint8List bodyBytes = body.toJson.utf8ToBytes;

    final MongoDBRequestResult result = await ClientService.post(
      uri: _uriFind,
      body: bodyBytes,
      headers: headersRequest(bodyBytes),
    );

    // return [...result.dataReceived.document];
    return result.dataReceived.parseDocumentsList();

  }
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/findOne
  @override
  Future<Map<String, dynamic>?> findOne(Query query, {TypeQuery type = TypeQuery.filter}) async {

    final Map<String, dynamic> body = sourceRequest;

    if (type == TypeQuery.filter && query.filter.isNotEmpty) {
      body.addAll({'filter': query.filter});
    } else {
      if (query.free is List || query.free is Map) {
        body.addAll({'filter': query.free});
      }
    }

    if (query.projection.isNotEmpty) {
      body.addAll({'projection': query.projection});
    }

    if (query.sort.isNotEmpty) {
      body.addAll({'sort': query.sort});
    }

    final Uint8List bodyBytes = body.toJson.utf8ToBytes;

    final MongoDBRequestResult result = await ClientService.post(
      uri: _uriFindOne,
      body: bodyBytes,
      headers: headersRequest(bodyBytes),
    );

    // return result.dataReceived.document;
    return result.dataReceived.parseDocumentMapOrNull();

  }

  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/insertMany
  @override
  Future<Inserted> insertMany({required Query query, required List<Map<String, dynamic>> documents}) {
   
    final Map<String, dynamic> body = sourceRequest;

    body.addAll({'documents': documents});
    
    throw UnimplementedError();
  }

  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/updateOne
  @override
  Future<Inserted> insertOne({required Query query, required Map<String, dynamic> document}) {
    
    final Map<String, dynamic> body = sourceRequest;

    body.addAll({'document': document});

    throw UnimplementedError();
    
  }

  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/updateMany
  @override
  Future<Updated> updateMany({
    required Query query, 
    required Map<String, dynamic> data, TypeQuery type = TypeQuery.filter, bool? upsert,}) async{

    final Map<String, dynamic> body = sourceRequest;

    if (type == TypeQuery.filter && query.filter.isNotEmpty) {
      body.addAll({'filter': query.filter});
    } else {
      if (query.free is List || query.free is Map) {
        body.addAll({'filter': query.free});
      }
    }

    if (upsert is bool) {
      body.addAll({'upsert': upsert});
    }

    body.update(
      'update', 
      (_) => {'\$set': data},
      ifAbsent: () => {'\$set': data},
    );

    final Uint8List bodyBytes = body.toJson.utf8ToBytes;

    final MongoDBRequestResult result = await ClientService.post(
      uri: _uriUpdateMany,
      body: bodyBytes,
      headers: headersRequest(bodyBytes),
    );

    return result.dataReceived.updated;

  }

  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/updateOne
  @override
  Future<Updated> updateOne({
    required Query query, 
    required Map<String, dynamic> data, TypeQuery type = TypeQuery.filter, bool? upsert,}) async{
    
    final Map<String, dynamic> body = sourceRequest;

    if (type == TypeQuery.filter && query.filter.isNotEmpty) {
      body.addAll({'filter': query.filter});
    } else {
      if (query.free is List || query.free is Map) {
        body.addAll({'filter': query.free});
      }
    }

    if (upsert is bool) {
      body.addAll({'upsert': upsert});
    }

    body.update(
      'update', 
      (_) => {'\$set': data},
      ifAbsent: () => {'\$set': data},
    );

    final Uint8List bodyBytes = body.toJson.utf8ToBytes;

    final MongoDBRequestResult result = await ClientService.post(
      uri: _uriUpdateOne,
      body: bodyBytes,
      headers: headersRequest(bodyBytes),
    );

    return result.dataReceived.updated;

  }
  
}

final class CollectionExeception implements Exception {
  final String message;
  const CollectionExeception(this.message);
  @override
  String toString() => message;
}