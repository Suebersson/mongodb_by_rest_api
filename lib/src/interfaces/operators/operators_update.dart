import '../../query.dart';

// https://www.mongodb.com/docs/manual/reference/operator/update/
abstract interface class OperatorsUpdate {

  // https://www.mongodb.com/docs/manual/reference/operator/update/set/#mongodb-update-up.-set
  Query $set(Map<String, dynamic> data);

  // https://www.mongodb.com/pt-br/docs/manual/reference/operator/update/push/
  Query $push({required String field, dynamic value});

  // https://www.mongodb.com/pt-br/docs/manual/reference/operator/update/pull/
  Query $pull({required String field, dynamic value});

  // https://www.mongodb.com/pt-br/docs/manual/reference/operator/update/inc/
  Query $inc({required String field, dynamic value});

}