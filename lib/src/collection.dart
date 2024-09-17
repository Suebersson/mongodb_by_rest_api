import 'dart:typed_data' show Uint8List;
import 'package:crypto/crypto.dart';

import './interfaces/collection_methods.dart';
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
  Future<List<Map<String, dynamic>>> aggregate(List<Map<String, dynamic>> pipeline) async{

    final Map<String, dynamic> body = sourceRequest;

    body.addAll({'pipeline': pipeline});

    final Uint8List bodyBytes = body.toJson.utf8ToBytes;

    final MongoDBRequestResult result = await ClientService.post(
      uri: _uriAggregate,
      body: bodyBytes,
      headers: headersRequest(bodyBytes),
    );

    return result.dataReceived.parseDocumentsList();

  }
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/insertMany
  @override
  Future<Deleted> deleteMany(dynamic filter) async{

    final Map<String, dynamic> body = sourceRequest;
    
    body.addAll({'filter': filter});

    final Uint8List bodyBytes = body.toJson.utf8ToBytes;

    final MongoDBRequestResult result = await ClientService.post(
      uri: _uriDeleteMany,
      body: bodyBytes,
      headers: headersRequest(bodyBytes),
    );

    return result.dataReceived.deleted;

  }
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/updateOne
  @override
  Future<Deleted> deleteOne(dynamic filter) async{

    final Map<String, dynamic> body = sourceRequest;
    
    body.addAll({'filter': filter});

    final Uint8List bodyBytes = body.toJson.utf8ToBytes;

    final MongoDBRequestResult result = await ClientService.post(
      uri: _uriDeleteOne,
      body: bodyBytes,
      headers: headersRequest(bodyBytes),
    );

    return result.dataReceived.deleted;

  }
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/find
  @override
  Future<List<Map<String, dynamic>>> find(
    dynamic filter, {Map<String, dynamic>? projection, Map<String, dynamic>? sort, int? limit,}) async{
    // // todos os documentos com apenas os campos escificados
    // final Query where = query.$projection(['title', 'country', 'uf']);
    // final List<Map<String, dynamic>> data = await events.find(query, projection: where.operators);
    // print(where.operators);
    // print(data.length);

    // // todos os documentos
    // final List<Map<String, dynamic>> data = await events.find(query);
    // print(data.length);

    final Map<String, dynamic> body = sourceRequest;

    body.addAll({'filter': filter});

    if (projection?.isNotEmpty ?? false) {
      body.addAll({'projection': projection});
    }

    if (sort?.isNotEmpty ?? false) {
      body.addAll({'sort': sort});
    }

    if (limit is int) {
      body.addAll({'limit': limit});
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
  Future<Map<String, dynamic>?> findOne(
    dynamic filter, {Map<String, dynamic>? projection, Map<String, dynamic>? sort,}) async {

    final Map<String, dynamic> body = sourceRequest;

    body.addAll({'filter': filter});

    if (projection?.isNotEmpty ?? false) {
      body.addAll({'projection': projection});
    }

    if (sort?.isNotEmpty ?? false) {
      body.addAll({'sort': sort});
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
  Future<InsertedMany> insertMany(List<Map<String, dynamic>> documents) async{
   
    final Map<String, dynamic> body = sourceRequest;

    body.addAll({'documents': documents});
    
    final Uint8List bodyBytes = body.toJson.utf8ToBytes;

    final MongoDBRequestResult result = await ClientService.post(
      uri: _uriInsertMany,
      body: bodyBytes,
      headers: headersRequest(bodyBytes),
    );

    return result.dataReceived.insertedMany;
    
  }

  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/updateOne
  @override
  Future<InsertedOne> insertOne(Map<String, dynamic> document) async{
    
    final Map<String, dynamic> body = sourceRequest;

    body.addAll({'document': document});

    final Uint8List bodyBytes = body.toJson.utf8ToBytes;

    final MongoDBRequestResult result = await ClientService.post(
      uri: _uriInsertOne,
      body: bodyBytes,
      headers: headersRequest(bodyBytes),
    );

    return result.dataReceived.insertedOne;
    
  }

  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/updateMany
  @override
  Future<Updated> updateMany({
    required dynamic filter, required dynamic update, bool? upsert,}) async{

    final Map<String, dynamic> body = sourceRequest;

    body.addAll({'filter': filter});

    body.addAll({'update': update});

    if (upsert is bool) {
      body.addAll({'upsert': upsert});
    }

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
    required dynamic filter, required dynamic update, bool? upsert,}) async{
    
    final Map<String, dynamic> body = sourceRequest;

    body.addAll({'filter': filter});

    body.addAll({'update': update});

    if (upsert is bool) {
      body.addAll({'upsert': upsert});
    }

    final Uint8List bodyBytes = body.toJson.utf8ToBytes;

    final MongoDBRequestResult result = await ClientService.post(
      uri: _uriUpdateOne,
      body: bodyBytes,
      headers: headersRequest(bodyBytes),
    );

    return result.dataReceived.updated;

  }
  
  /// quantidade total dos documentos, sem filtro
  /// 
  /// final int count = await events.amountOfDocuments();
  /// 
  /// quantidade total de documentos que corresponde ao filtro
  /// 
  /// final int count = await events.amountOfDocuments({
  ///   'country': 'BR', // ou 'country': {'\$eq': 'BR'},
  ///   'uf': 'RJ', // ou 'uf': {'\$eq': 'RJ'} 
  /// });
  @override
  Future<int> amountOfDocuments([Map<String, dynamic>? match]) async{
    // quantidade de documentos existentes
    /*
      [{'\$count': 'count'}]
    */

    // quantidade de documentos filtrados
    /*
      [
        {
          '\$match': {
            'country': 'BR',
            'uf': 'RJ'
          }
        },
        {
          '\$count': 'count',
        },
      ]
    */

    final List<Map<String, dynamic>> pipeline = [{'\$count': 'count'}];

    if (match is Map<String, dynamic> && match.isNotEmpty) {
      pipeline.insert(0, {'\$match': match});
    }

    final List<Map<String, dynamic>> data = await aggregate(pipeline);

    return data.firstWhere(
      (m) => m.containsKey('count'),
      orElse: () => {'count': 0},
    )['count'] ?? 0;

  }
  
}

final class CollectionExeception implements Exception {
  final String message;
  const CollectionExeception(this.message);
  @override
  String toString() => message;
}