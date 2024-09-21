// ignore_for_file: unused_element

import '../interfaces/collection.dart';
import '../mongodb.dart';
import '../mongodb_request_data.dart';

class CollectionForLocalhost implements Collection {

  const CollectionForLocalhost._({
    required this.name, 
    required this.db,
  });

  @override
  final String name; 
  @override
  final Mongodb db;

  factory CollectionForLocalhost({required String name, required Mongodb db}) {

    return CollectionForLocalhost._(name: name, db: db);

  }

  T _generateException<T>(final String message) => throw CollectionExeception(message);

  @override
  Future<List<Map<String, dynamic>>> aggregate(List<Map<String, dynamic>> pipeline) async{
    throw const CollectionExeception('funções incompleta');
  }

  @override
  Future<Deleted> deleteMany(dynamic filter) async{
    throw const CollectionExeception('funções incompleta');
  }

  @override
  Future<Deleted> deleteOne(dynamic filter) async{
    throw const CollectionExeception('funções incompleta');
  }

  @override
  Future<List<Map<String, dynamic>>> find({
    dynamic filter, Map<String, dynamic>? projection, Map<String, dynamic>? sort, int? limit,}) async{
    throw const CollectionExeception('funções incompleta');
  }

  @override
  Future<Map<String, dynamic>?> findOne({
    required dynamic filter, Map<String, dynamic>? projection, Map<String, dynamic>? sort,}) async{
    throw const CollectionExeception('funções incompleta');
  }

  @override
  Future<InsertedMany> insertMany(List<Map<String, dynamic>> documents) async{
    throw const CollectionExeception('funções incompleta');
  }

  @override
  Future<InsertedOne> insertOne(Map<String, dynamic> document) async{
    throw const CollectionExeception('funções incompleta');
  }

  @override
  Future<Updated> updateMany({required dynamic filter, required dynamic update, bool? upsert}) async{
    throw const CollectionExeception('funções incompleta');
  }

  @override
  Future<Updated> updateOne({required dynamic filter, required dynamic update, bool? upsert}) async{
    throw const CollectionExeception('funções incompleta');
  }

  @override
  Future<int> amountOfDocuments([Map<String, dynamic>? match]) async{
    throw const CollectionExeception('funções incompleta');
  }
  
}