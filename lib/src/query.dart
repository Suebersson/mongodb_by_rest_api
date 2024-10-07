import 'dart:typed_data' show Uint8List;
import 'package:convert_json/convert_json_lib.dart' show ToJson;

import './converters/extension.dart';
import './interfaces/operators/operators_query.dart';
import './interfaces/operators/operators_update.dart';
import './interfaces/operators/operators_aggregation.dart';
import './id_field.dart';

Query get query => Query();

final class Query implements OperatorsQuery, OperatorsUpdate, OperatorsAggregation, ToJson {

  @override
  late final Map<String, dynamic> toMap = {};
  @override
  String get toJson => toMap.toJson;
  Uint8List get toBytes => toJson.utf8ToBytes;

  // Objetos esperados [List] ou [Map] para criar a query
  // 
  // final List where =  [query.$gt(2, field: 'carrier.fee'), query.$set({ "price": 15.89})];
  //
  // print(where.toJson); // [{"carrier.fee":{"$gt":2}},{"$set":{"price":15.89}}]
  //
  // final Map where = {'createdAt': query.$gte({'\$date': '2022-01-01T00:00:00.000Z'}).$lt({'\$date': '2023-01-01T00:00:00.000Z'})};
  // 
  // print(where.toJson); // {"createdAt":{"$gte":{"$date":"2022-01-01T00:00:00.000Z"},"$lt":{"$date":"2023-01-01T00:00:00.000Z"}}}

  /// final Query where = query.$eq('data.name', 'João');
  ///
  /// print(where.filterJson); // {"data.name":{"$eq":"João"}}
  /// 
  /// final Query where = query.$eq('tags', ['A', 'B']);
  /// print(where.filterJson); // {"tags":{"$eq":["A","B"]}}
  @override
  Query $eq(dynamic value, {String? field}) {
    if (field is String) {
      toMap.update(
        field, 
        (_) => {'\$eq': value}, //value,
        ifAbsent: () => {'\$eq': value}, //value,
      );
    } else {
      toMap.update(
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
      toMap.update(
        field, 
        (_) => {'\$gt': value},
        ifAbsent: () => {'\$gt': value},
      );
    } else {
      toMap.update(
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
      toMap.update(
        field, 
        (_) => {'\$gte': value},
        ifAbsent: () => {'\$gte': value},
      );
    } else {
      toMap.update(
        '\$gte', 
        (_) => value,
        ifAbsent: () => value,
      );      
    }
    return this;
  }
  
  @override
  Query $in(String field, List<dynamic> value) {
    toMap.update(
      field, 
      (_) => {'\$in': value},
      ifAbsent: () => {'\$in': value},
    );
    return this;
  }
  
  @override
  Query $lt(dynamic value, {String? field}) {
    if (field is String) {
      toMap.update(
        field, 
        (_) => {'\$lt': value},
        ifAbsent: () => {'\$lt': value},
      );
    } else {
      toMap.update(
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
      toMap.update(
        field, 
        (_) => {'\$lte': value},
        ifAbsent: () => {'\$lte': value},
      );
    } else {
      toMap.update(
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
      toMap.update(
        field, 
        (_) => {'\$ne': value},
        ifAbsent: () => {'\$ne': value},
      );
    } else {
      toMap.update(
        '\$ne', 
        (_) => value,
        ifAbsent: () => value,
      );      
    }
    return this;
  }
  
  /// final Query where = query.$free([query.$nin('quantity', [5, 15]), query.$eq('_id', '1')]);
  ///
  /// print(where.freeJson); // [{"quantity":{"$nin":[5,15]}},{"_id":{"$eq":"1"}}]
  ///
  /// final Query where = query.$free([query.$nin('tags', ['school']), query.$set({'exclude': true})]);
  ///
  /// print(where.freeJson); // [{"tags":{"$nin":["school"]}},{"$set":{"exclude":true}}]
  @override
  Query $nin(String field, List<dynamic> value) {
    toMap.update(
      field, 
      (_) => {'\$nin': value},
      ifAbsent: () => {'\$nin': value},
    );
    return this;
  }
  
  @override
  Query $and(Query and) {

    final List<Map<String, dynamic>> search = and.toMap.entries
      .map((e) => {e.key: e.value}).toList();

    toMap.update(
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
    toMap.update(
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
    toMap.update(
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

    final List<Map<String, dynamic>> search = querys.map((e) => e.toMap).toList();

    toMap.update(
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
    toMap
      ..clear()
      ..addAll({for (String key in fields) key: 1})
      ..putIfAbsent(IdField.withUnderscore, () => 0);
    return this;
  }

  /// reordenar os campos
  Query $sort(List<String> fields) {
    toMap
      ..clear()
      ..addAll({for (String key in fields) key: 1});
    return this;
  }

  /// final Query where = query.$nor([{'item': 2}, {'price': 2.87}, {'price':{'\$exists':false}}]);
  /// final Query where = query.$nor([{'item': 2}, {'price': 2.87}, query.$exists('price', false).operators]);
  ///
  /// print(where.filterJson); // {"$nor":[{"item":2},{"price":2.87},{"price":{"$exists":false}}]}
  /// 
  /// final Query where = query.$exists('title');
  /// 
  /// {"title":{"$exists":false}}
  @override
  Query $exists(String field, [bool value = false]) {
    toMap.update(
      field, 
      (_) => {'\$exists': value},
      ifAbsent: () => {'\$exists': value},
    );
    return this;
  }
  
  /// final Query where = query.$set({'elements.name': 'João', 'item': 20, 'column': 4}); 
  /// print(where.filterJson); // {"$set":{"elements.name":"João","item":20,"column":4}}
  /// 
  /// final Query where = query.$gt(2, field: 'carrier.fee').$set({ "price": 15.89});
  /// print(where.filterJson); // {"carrier.fee":{"$gt":2},"$set":{"price":15.89}}
  @override
  Query $set(Map<String, dynamic> data) {
    toMap.update(
      '\$set', 
      (_) => data,
      ifAbsent: () => data,
    );
    return this;
  }

  @override
  Query $inc({required String field, value}) {
    toMap.update(
      '\$inc', 
      (data) {
        (data as Map<String, dynamic>).addAll({field: value});
        return data;
      },
      ifAbsent: () => {field: value},
    );
    return this;
  }
  
  @override
  Query $pull({required String field, value}) {
    toMap.update(
      '\$pull', 
      (data) {
        (data as Map<String, dynamic>).addAll({field: value});
        return data;
      },
      ifAbsent: () => {field: value},
    );
    return this;
  }
  
  /// final Query where = query
  ///   .$push(field: 'confirmedPresences', value: {'_id': 'gfnc4b78re7gt5d'})
  ///   .$inc(field: 'field', value: 1);
  /// 
  /// print(where.toMap.toJson); // {"$push":{"confirmedPresences":{"_id":"gfnc4b78re7gt5d"}},"$inc":{"field":1}}
  @override
  Query $push({required String field, value}) {
    toMap.update(
      '\$push', 
      (data) {
        (data as Map<String, dynamic>).addAll({field: value});
        return data;
      },
      ifAbsent: () => {field: value},
    );
    return this;
  }

  @override
  Query $match(Map<String, dynamic> data) {
    toMap.update(
      '\$match', 
      (_) => data,
      ifAbsent: () => data,
    );
    return this;
  }
  
  /// https://www.mongodb.com/pt-br/docs/manual/reference/operator/query/regex/
  @override
  Query $regex(String field, RegExp regExp) {
    toMap.update(
      field, 
      (_) => regExp,
      ifAbsent: () => regExp,
    );
    return this;
  }
  
}
