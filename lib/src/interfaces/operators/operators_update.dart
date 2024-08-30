import '../../query.dart';

// https://www.mongodb.com/docs/manual/reference/operator/update/
abstract interface class OperatorsUpdate {

  // https://www.mongodb.com/docs/manual/reference/operator/update/set/#mongodb-update-up.-set
  Query $set(Map<String, dynamic> data);

}