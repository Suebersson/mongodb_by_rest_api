import '../../query.dart';

// https://www.mongodb.com/docs/manual/reference/operator/query/
abstract interface class OperatorsQuery {

  // https://www.mongodb.com/pt-br/docs/manual/reference/operator/query/#query-selectors
  Query $eq(dynamic value, {String? field});
  Query $gt(dynamic value, {String? field});
  Query $gte(dynamic value, {String? field});
  Query $lt(dynamic value, {String? field});
  Query $lte(dynamic value, {String? field});
  Query $ne(dynamic value, {String? field});
  Query $in(String field, List<dynamic> values);
  Query $nin(String field, List<dynamic> values);

  // https://www.mongodb.com/pt-br/docs/manual/reference/operator/query/#logical
  Query $and(Query and);
  Query $not(String field, dynamic value);
  Query $nor(List<dynamic> values);
  Query $or(List<Query> or);

  Query $exists(String field, [bool value = false]);

  Query $regex(String field, RegExp regExp);

}