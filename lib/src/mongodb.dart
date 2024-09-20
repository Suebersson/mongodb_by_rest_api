import 'dart:typed_data' show Uint8List;

import './collection.dart';
import './uri_methods.dart';
import './exception.dart';
import 'localhost/mongodb_localhost.dart';

// Referências:
// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/
// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/examples/
// https://www.mongodb.com/pt-br/docs/atlas/app-services/data-api/openapi/#section/Set-Up-the-Data-API
// https://www.mongodb.com/pt-br/docs/manual/reference/operator/query/
// https://www.mongodb.com/docs/atlas/app-services/data-api/examples/
// https://www.mongodb.com/docs/atlas/app-services/mongodb/crud-and-aggregation-apis/#query-operators
// https://www.mongodb.com/docs/atlas/app-services/data-api/authenticate/
// https://www.mongodb.com/docs/atlas/app-services/data-api/data-formats/

final class Mongodb {
  
  Mongodb({
    required this.endpoint,
    required this.headers,
    required this.source,
    this.signPayload = false,
    this.secretKeyBytes,
    this.localhost,
  });

  final String endpoint;
  final Uint8List? secretKeyBytes;
  final bool signPayload;

  final Map<String, String> headers;
  final Map<String, dynamic> source;

  Map<String, String> get copyHeaders => {...headers};
  Map<String, dynamic> get copySource => {...source};

  late final UriMethods uriMethods = UriMethods(endpoint);

  final MongodbLocalhost? localhost;

  // https://www.mongodb.com/docs/atlas/app-services/data-api/authenticate/#bearer-authentication
  factory Mongodb.authentication({
    required String authentication, 
    required String endpoint, 
    required String cluster, 
    required String dataBaseName,
  }) {
    return Mongodb(
      endpoint: endpoint, 
      headers: Map.unmodifiable({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Access-Control-Request-Headers': '*',
        'Authentication': authentication,
      }), 
      source: Map.unmodifiable({
        'database': dataBaseName,
        'dataSource': cluster,
      }),
    );
  }

  // https://www.mongodb.com/docs/atlas/app-services/data-api/authenticate/#api-key
  factory Mongodb.apiKey({
    required String apiKey, 
    required String endpoint, 
    required String cluster, 
    required String dataBaseName,
  }) {
    return Mongodb(
      endpoint: endpoint, 
      headers: Map.unmodifiable({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Access-Control-Request-Headers': '*',
        'api-key': apiKey,
      }), 
      source: Map.unmodifiable({
        'database': dataBaseName,
        'dataSource': cluster,
      }),
    );
  }

  // https://www.mongodb.com/docs/atlas/app-services/data-api/authenticate/#email-password
  factory Mongodb.emailPassword({
    required String email,
    required String password, 
    required String endpoint, 
    required String cluster, 
    required String dataBaseName,
  }) {
    return Mongodb(
      endpoint: endpoint, 
      headers: Map.unmodifiable({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Access-Control-Request-Headers': '*',
        'email': email,
        'password': password,
      }), 
      source: Map.unmodifiable({
        'database': dataBaseName,
        'dataSource': cluster,
      }),
    );
  }

  // https://www.mongodb.com/docs/atlas/app-services/data-api/authenticate/#custom-jwt
  factory Mongodb.jwtToken({
    required String jwtTokenString,
    required String endpoint, 
    required String cluster, 
    required String dataBaseName,
  }) {
    return Mongodb(
      endpoint: endpoint, 
      headers: Map.unmodifiable({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Access-Control-Request-Headers': '*',
        'jwtTokenString': jwtTokenString,
      }), 
      source: Map.unmodifiable({
        'database': dataBaseName,
        'dataSource': cluster,
      }),
    );
  }

  // https://www.mongodb.com/docs/atlas/app-services/data-api/generated-endpoints/#authorize-the-request
  /// Endpoint-Signature: sha256=...
  factory Mongodb.payloadSignature({
    required Uint8List secretKeyBytes, 
    required String endpoint, 
    required String cluster, 
    required String dataBaseName,
  }) {
    return Mongodb(
      endpoint: endpoint,
      secretKeyBytes: secretKeyBytes,
      signPayload: true,
      headers: Map.unmodifiable({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Access-Control-Request-Headers': '*',
        'Endpoint-Signature': 'sha256=...',
      }), 
      source: Map.unmodifiable({
        'database': dataBaseName,
        'dataSource': cluster,
      }),
    );
  }

  static Future<Mongodb> connectInLocalhost({
    required String dataBaseName,
    int port = 27017, 
  }) async{

    return Mongodb(
      endpoint: 'http://localhost:$port/$dataBaseName',
      signPayload: false,
      headers: Map.unmodifiable({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      }),
      source: Map.unmodifiable({
        'database': dataBaseName,
        'port': port,
      }),
      localhost: await MongodbLocalhost.connect(port),
    );

  }

  Collection collection(String name) => Collection(name: name, db: this);

  Future<void> createCollections(List<Collection> list) async{

    // final List<String> collectionsInDB = [];

    // list.removeWhere((c) => collectionsInDB.contains(c.name));

    // if (list.isNotEmpty) {
    //   await Future.wait(List<Future<void>>.generate(list.length, (index) async{
        
    //   },),);
    // }

    throw const MongoDBExeception('Implementação pendente');
    
  }

  Future<void> createIndexToRemoveExpiredDocuments({
    required Collection collection, 
    required String indexName, 
    required String fieldName, 
    int expireAfterSeconds = 60,
  }) async{

    throw const MongoDBExeception('Implementação pendente');

  }

}