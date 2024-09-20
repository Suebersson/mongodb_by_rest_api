import '../mongodb.dart';
import '../mongodb_request_data.dart';

abstract interface class Collection {

  String get name; 
  Mongodb get db;

  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/findOne
  Future<List<Map<String, dynamic>>> find({
    dynamic filter, Map<String, dynamic>? projection, Map<String, dynamic>? sort, int? limit,});
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/find
  Future<Map<String, dynamic>?> findOne({
    required dynamic filter, Map<String, dynamic>? projection, Map<String, dynamic>? sort,});

  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/insertOne
  Future<InsertedOne> insertOne(Map<String, dynamic> document);
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/insertMany
  Future<InsertedMany> insertMany(List<Map<String, dynamic>> documents);

  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/updateOne
  /// https://www.mongodb.com/pt-br/docs/manual/reference/method/db.collection.update/#std-label-upsert-behavior
  Future<Updated> updateOne({
    required dynamic filter, required dynamic update, bool? upsert,});
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/updateMany
  /// https://www.mongodb.com/pt-br/docs/manual/reference/method/db.collection.update/#std-label-upsert-behavior
  Future<Updated> updateMany({
    required dynamic filter, required dynamic update, bool? upsert,});
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/deleteOne
  Future<Deleted> deleteOne(dynamic filter);
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/deleteMany 
  Future<Deleted> deleteMany(dynamic filter);
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/aggregate
  Future<List<Map<String, dynamic>>> aggregate(List<Map<String, dynamic>> pipeline);

  Future<int> amountOfDocuments([Map<String, dynamic>? match]);
  
}

final class CollectionExeception implements Exception {
  final String message;
  const CollectionExeception(this.message);
  @override
  String toString() => message;
}