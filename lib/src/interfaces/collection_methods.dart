import '../query.dart';

abstract interface class CollectionMethods {
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/findOne
  Future<Map<String, dynamic>?> find(Query query, {int? limit});
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/find
  Future<Map<String, dynamic>?> findOne(Query query, {TypeQuery type = TypeQuery.filter});
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/insertOne
  Future<Map<String, dynamic>?> insertOne({required Query query, required Map<String, dynamic> document});
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/insertMany
  Future<Map<String, dynamic>?> insertMany({
    required Query query, required List<Map<String, dynamic>> documents,});

  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/updateOne
  Future<Map<String, dynamic>?> updateOne({
    required Query query, required Map<String, dynamic> data, TypeQuery type = TypeQuery.filter, bool? upsert,});
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/updateMany
  Future<Map<String, dynamic>?> updateMany(Query query, {bool? upsert});
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/deleteOne
  Future<Map<String, dynamic>?> deleteOne(Query query);
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/deleteMany 
  Future<Map<String, dynamic>?> deleteMany(Query query);
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/aggregate
  Future<Map<String, dynamic>?> aggregate(Query query);
  
}