// ignore_for_file: avoid_print

import 'package:mongodb_by_rest_api/mongodb_by_rest_api.dart';

void main() async{

  final Mongodb db = Mongodb.apiKey(
    apiKey: '...', 
    endpoint: 'https://data.mongodb-api.com/app/.../endpoint/data/v1', 
    cluster: 'ClusterName', 
    dataBaseName: 'dbName',
  );

  final Collection events = db.collection('events');


  final Query where = query.$projection(['title', 'country', 'uf']) 
    .$or([
      query.$and(query.$eq('Op1006d209f4729f6349d756739dd700', field: '_id').$eq('country', field: 'BR').$eq('uf', field: 'RJ')),
      query.$and(query.$eq('Op1006d209f4729f6349d756739dd700', field: '_id')),
    ]);

  final data = await events.findOne(filter: where);

  print(data);

}
