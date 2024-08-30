// ignore_for_file: unused_field, unused_local_variable

import 'dart:typed_data' show Uint8List;
import 'package:crypto/crypto.dart';

import './interfaces/collection_methods.dart';
import './query.dart';
import './mongodb.dart';
import './converters/extension.dart';
import './client_service.dart';
import './mongodb_request_result.dart';

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
    _uriFindOne = Uri.parse('${db.endpoint}/action/findOne'), // post
    _uriFind = Uri.parse('${db.endpoint}/action/find'), // post
    _uriInsertOne = Uri.parse('${db.endpoint}/action/insertOne'), // post
    _uriInsertMany = Uri.parse('${db.endpoint}/action/insertMany'), // post
    _uriUpdateOne = Uri.parse('${db.endpoint}/action/updateOne'), // post
    _uriUpdateMany = Uri.parse('${db.endpoint}/action/updateMany'), // post
    _uriDeleteOne = Uri.parse('${db.endpoint}/action/deleteOne'), // post
    _uriDeleteMany = Uri.parse('${db.endpoint}/action/deleteMany'), // post
    _uriAggregate = Uri.parse('${db.endpoint}/action/aggregate'); // post

  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/aggregate
  @override
  Future<Map<String, dynamic>?> aggregate(Query query) {
    throw UnimplementedError();
  }
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/insertMany
  @override
  Future<Map<String, dynamic>?> deleteMany(Query query) {
    throw UnimplementedError();
  }
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/updateOne
  @override
  Future<Map<String, dynamic>?> deleteOne(Query query) {
    throw UnimplementedError();
  }
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/find
  @override
  Future<Map<String, dynamic>?> find(Query query, {int? limit}) {
    throw UnimplementedError();
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

    final Uint8List bodyBytes = body.toJson.utf8ToBytes;

    final MongoDBRequestResult result = await ClientService.post(
      uri: _uriFindOne,
      body: bodyBytes,
      headers: headersRequest(bodyBytes),
    );

    return result.dataReceived.document;

    // return headers;
    // return body;

  }

  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/insertMany
  @override
  Future<Map<String, dynamic>?> insertMany({required Query query, required List<Map<String, dynamic>> documents}) {
   
    final Map<String, dynamic> body = sourceRequest;

    body.addAll({'documents': documents});
    
    throw UnimplementedError();
  }

  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/updateOne
  @override
  Future<Map<String, dynamic>?> insertOne({required Query query, required Map<String, dynamic> document}) {
    
    final Map<String, dynamic> body = sourceRequest;

    body.addAll({'document': document});

    throw UnimplementedError();
    
  }

  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/updateMany
  @override
  Future<Map<String, dynamic>?> updateMany(Query query, {bool? upsert}) {

    // if (query.update is List || query.update is Map) {
    //   body.addAll({'update': query.update});
    // }

    throw UnimplementedError();
  }

  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/updateOne
  @override
  Future<Map<String, dynamic>?> updateOne({
    required Query query, required Map<String, dynamic> data, TypeQuery type = TypeQuery.filter, bool? upsert,}) {
    
    final Map<String, dynamic> body = sourceRequest;

    if (type == TypeQuery.filter && query.filter.isNotEmpty) {
      body.addAll({'filter': query.filter});
    } else {
      if (query.free is List || query.free is Map) {
        body.addAll({'filter': query.free});
      }
    }

    if (query.update is List || query.update is Map) {
      body.addAll({'update': query.update});
    }

    if (upsert is bool) {
      body.addAll({'upsert': upsert});
    }

    throw UnimplementedError();

  }
  
}

final class CollectionExeception implements Exception {
  final String message;
  const CollectionExeception(this.message);
  @override
  String toString() => message;
}