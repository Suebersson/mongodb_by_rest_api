import 'dart:typed_data' show Uint8List;

import 'converters/extension.dart';
import './interfaces/operators/operators_query.dart';
import './interfaces/operators/operators_update.dart';

Query get query => Query();

final class Query implements OperatorsQuery, OperatorsUpdate {

  final Map<String, dynamic> filter = {};
  String get filterJson => filter.toJson;
  Uint8List get filterBytes => filter.toJson.utf8ToBytes;

  final Map<String, int> projection = {};
  String get projectionJson => projection.toJson;
  Uint8List get projectionBytes => projection.toJson.utf8ToBytes;

  final Map<String, int> sort = {};
  String get sortJson => sort.toJson;
  Uint8List get sortBytes => sort.toJson.utf8ToBytes;

  Object? free;
  bool isFree = false;
  String get freeJson {
    if (free is List || free is Map) {
      return free?.toJson ?? '{}';
    } else {
      return '{}';
    }
  }
  Uint8List get freeBytes => freeJson.utf8ToBytes;

  /// final Query where = query.$eq('data.name', 'João');
  ///
  /// print(where.filterJson); // {"data.name":{"$eq":"João"}}
  /// 
  /// final Query where = query.$eq('tags', ['A', 'B']);
  /// print(where.filterJson); // {"tags":{"$eq":["A","B"]}}
  @override
  Query $eq(dynamic value, {String? field}) {

    if (field is String) {
      filter.update(
        field, 
        (_) => {'\$eq': value}, //value,
        ifAbsent: () => {'\$eq': value}, //value,
      );
    } else {
      filter.update(
        '\$eq', 
        (_) => value,
        ifAbsent: () => value,
      );      
    }

    return this;
  }
  
  @override
  Query $gt(dynamic value, {String? field}) {

    if (field is String) {
      filter.update(
        field, 
        (_) => {'\$gt': value},
        ifAbsent: () => {'\$gt': value},
      );
    } else {
      filter.update(
        '\$gt', 
        (_) => value,
        ifAbsent: () => value,
      );      
    }

    return this;
  }
  
  @override
  Query $gte(dynamic value, {String? field}) {
    
    if (field is String) {
      filter.update(
        field, 
        (_) => {'\$gte': value},
        ifAbsent: () => {'\$gte': value},
      );
    } else {
      filter.update(
        '\$gte', 
        (_) => value,
        ifAbsent: () => value,
      );      
    }

    return this;
  }
  
  @override
  Query $in(String field, List<dynamic> value) {
    filter.update(
      field, 
      (_) => {'\$in': value},
      ifAbsent: () => {'\$in': value},
    );
    return this;
  }
  
  @override
  Query $lt(dynamic value, {String? field}) {

    if (field is String) {
      filter.update(
        field, 
        (_) => {'\$lt': value},
        ifAbsent: () => {'\$lt': value},
      );
    } else {
      filter.update(
        '\$lt', 
        (_) => value,
        ifAbsent: () => value,
      );      
    }

    return this;
  }
  
  @override
  Query $lte(dynamic value, {String? field}) {

    if (field is String) {
      filter.update(
        field, 
        (_) => {'\$lte': value},
        ifAbsent: () => {'\$lte': value},
      );
    } else {
      filter.update(
        '\$lte', 
        (_) => value,
        ifAbsent: () => value,
      );      
    }

    return this;
  }
  
  @override
  Query $ne(dynamic value, {String? field}) {

    if (field is String) {
      filter.update(
        field, 
        (_) => {'\$ne': value},
        ifAbsent: () => {'\$ne': value},
      );
    } else {
      filter.update(
        '\$ne', 
        (_) => value,
        ifAbsent: () => value,
      );      
    }

    return this;
  }
  
  /// final Query where = query.$free([query.$nin('quantity', [5, 15]), query.$eq('_id', '1')]);
  ///
  ///  print(where.freeJson); // [{"quantity":{"$nin":[5,15]}},{"_id":{"$eq":"1"}}]
  ///
  /// final Query where = query.$free([query.$nin('tags', ['school']), query.$set({'exclude': true})]);
  ///
  /// print(where.freeJson); // [{"tags":{"$nin":["school"]}},{"$set":{"exclude":true}}]
  @override
  Query $nin(String field, List<dynamic> value) {
    filter.update(
      field, 
      (_) => {'\$nin': value},
      ifAbsent: () => {'\$nin': value},
    );
    return this;
  }
  
  @override
  Query $and(Query and) {

    final List<Map<String, dynamic>> search = and.filter.entries
      .map((e) => {e.key: e.value}).toList();

    filter.update(
      '\$and', (value) {
        (value as List).addAll(search);
        return value;
      },
      ifAbsent: () => search,
    );

    return this;

  }
  
  @override
  Query $nor(List<dynamic> values) {
    filter.update(
      '\$nor', (_) => values,
      ifAbsent: () => values,
    );
    return this;
  }
  
  @override
  Query $not(String field, dynamic value) {
    // final Query where = query.$not('item', query.$gt(10)); 
    // print(where.filterJson); // {"item":{"$not":{"$gt":10}}}
    //
    // final Query where = query.$not('item', '/^p.*/'); 
    // print(where.filterJson); // {"item":{"$not":"/^p.*/"}}
    filter.update(
      field, 
      (_) => {'\$not': value},
      ifAbsent: () => {'\$not': value},
    );
    return this;
  }
  
  /// final Query where = query.$or([
  ///   query.$and(query.$eq('Op1006d209f4729f6349d756739dd700', field: '_id').$eq('BR', field: 'country').$eq('RJ', field: 'uf')),
  ///   query.$eq('Op1006d209f4729f6349d756739dd700', field: '_id'),
  /// ]);
  ///
  /// print(where.filterJson);
  /// 
  /// {"$or":[{"$and":[{"_id":{"$eq":"Op1006d209f4729f6349d756739dd700"}},{"country":{"$eq":"BR"}},{"uf":{"$eq":"RJ"}}]},{"_id":{"$eq":"Op1006d209f4729f6349d756739dd700"}}]}
  @override
  Query $or(List<Query> querys) {

    final List<Map<String, dynamic>> search = querys.map((e) => e.filter).toList();

    filter.update(
      '\$or', (value) {
        (value as List).addAll(search);
        return value;
      },
      ifAbsent: () => search,
    );

    return this;

  }

  ///  Campos requeridos no documento
  Query $projection(List<String> fields) {
    projection
      ..clear()
      ..addAll({for (String key in fields) key: 1})
      ..putIfAbsent('_id', () => 0);
    return this;
  }

  /// reordenar os campos
  Query $sort(List<String> fields) {
    sort
      ..clear()
      ..addAll({for (String key in fields) key: 1});
    return this;
  }

  /// Objetos esperados [List] ou [Map] para criar a query
  /// 
  /// final Query where =  query.$free([query.$gt(2, field: 'carrier.fee'), query.$set({ "price": 15.89})]);
  ///
  /// print(where.freeJson); // [{"carrier.fee":{"$gt":2}},{"$set":{"price":15.89}}]
  /// 
  /// final Query where = query.$free({'createdAt': query.$gte({'\$date': '2022-01-01T00:00:00.000Z'}).$lt({'\$date': '2023-01-01T00:00:00.000Z'})});
  ///
  /// print(where.freeJson); // {"createdAt":{"$gte":{"$date":"2022-01-01T00:00:00.000Z"},"$lt":{"$date":"2023-01-01T00:00:00.000Z"}}}
  Query $free(dynamic query) {
    free = query;
    isFree = true;
    return this;
  }

  /// final Query where = query.$set({'elements.name': 'João', 'item': 20, 'column': 4}); 
  /// print(where.filterJson); // {"$set":{"elements.name":"João","item":20,"column":4}}
  /// 
  /// final Query where = query.$gt(2, field: 'carrier.fee').$set({ "price": 15.89});
  /// print(where.filterJson); // {"carrier.fee":{"$gt":2},"$set":{"price":15.89}}
  @override
  Query $set(Map<String, dynamic> data) {
    filter.update(
      '\$set', 
      (_) => data,
      ifAbsent: () => data,
    );
    return this;
  }
  
  /// final Query where = query.$nor([{'item': 2}, {'price': 2.87}, {'price':{'\$exists':false}}]);
  /// final Query where = query.$nor([{'item': 2}, {'price': 2.87}, query.$exists('price', false).filter]);
  ///
  /// print(where.filterJson); // {"$nor":[{"item":2},{"price":2.87},{"price":{"$exists":false}}]}
  /// 
  /// final Query where = query.$exists('title');
  /// 
  /// {"title":{"$exists":false}}
  @override
  Query $exists(String field, [bool value = false]) {
    filter.update(
      field, 
      (_) => {'\$exists': value},
      ifAbsent: () => {'\$exists': value},
    );
    return this;
  }
  
}

enum TypeQuery {
  filter,
  free;
}
