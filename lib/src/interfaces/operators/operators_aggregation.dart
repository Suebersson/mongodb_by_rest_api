import '../../query.dart';

// https://www.mongodb.com/pt-br/docs/manual/reference/operator/aggregation/
abstract interface class OperatorsAggregation {
  
  // https://www.mongodb.com/docs/v6.2/reference/operator/aggregation/match/
  Query $match(Map<String, dynamic> query);

}