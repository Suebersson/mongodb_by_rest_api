import '../mongodb_request_data.dart';
import '../query.dart';

abstract interface class CollectionMethods {
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/findOne
  Future<List<Map<String, dynamic>>> find(Query query, {TypeQuery type = TypeQuery.filter, int? limit});
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/find
  Future<Map<String, dynamic>?> findOne(Query query, {TypeQuery type = TypeQuery.filter});
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/insertOne
  Future<Inserted> insertOne({required Query query, required Map<String, dynamic> document});
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/insertMany
  Future<Inserted> insertMany({
    required Query query, required List<Map<String, dynamic>> documents,});

  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/updateOne
  /// https://www.mongodb.com/pt-br/docs/manual/reference/method/db.collection.update/#std-label-upsert-behavior
  Future<Updated> updateOne({
    required Query query, required Map<String, dynamic> data, TypeQuery type = TypeQuery.filter, bool? upsert,});
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/updateMany
  /// https://www.mongodb.com/pt-br/docs/manual/reference/method/db.collection.update/#std-label-upsert-behavior
  Future<Updated> updateMany({
    required Query query, required Map<String, dynamic> data, TypeQuery type = TypeQuery.filter, bool? upsert,});
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/deleteOne
  Future<Deleted> deleteOne(Query query);
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/deleteMany 
  Future<Deleted> deleteMany(Query query);
  
  /// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#operation/aggregate
  Future<Map<String, dynamic>?> aggregate(Query query);
  
}