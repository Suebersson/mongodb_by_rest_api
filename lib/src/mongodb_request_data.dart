import 'dart:developer' show log;

typedef Updated = ({bool requestSuccess, int matchedCount, int modifiedCount});
typedef Deleted = ({bool requestSuccess, int deletedCount});
typedef InsertedMany = ({bool requestSuccess, List<String> ids});
typedef InsertedOne = ({bool requestSuccess, String id});

final class MongoDBRequestData {

  MongoDBRequestData({
    required this.requestSuccess,
    required this.document,
    required this.deletedCount,
    required this.matchedCount,
    required this.modifiedCount,
    required this.insertedId,
    required this.insertedIds,
  });

  final bool requestSuccess;

  /// será um objeto [null], [List<dynamic>], [Map<String, dynamic>] 
  final dynamic document;

  final int 
    deletedCount, /// documentos excluidos
    matchedCount, /// fields/campos localizados
    modifiedCount; /// fields/campos modificados

  /// id do documento inserido
  final String insertedId;

  /// Lista de ids dos documentos inseridos
  final List<String> insertedIds;

  // Alocar variavéis vazias constantes na mémoria para retorno de objetos não nulos, 
  // isso eveta criar novas instâncias considerando que está classe será 
  // construida para cada requisição
  static final List<String> _emptyListString = List.unmodifiable([]);
  static final List<Map<String, dynamic>> _emptyListMapStringDynamic = List.unmodifiable([]);
  static final Map<String, dynamic> _emptyMapStringDynamic = Map.unmodifiable({});
  static final int _count = 0;
  static final String _emptyString = '';

  late final Updated updated = (requestSuccess: requestSuccess, matchedCount: matchedCount, modifiedCount: modifiedCount);
  late final Deleted deleted = (requestSuccess: requestSuccess, deletedCount: deletedCount);
  late final InsertedMany insertedMany = (requestSuccess: requestSuccess, ids: insertedIds);
  late final InsertedOne insertedOne = (requestSuccess: requestSuccess, id: insertedId);

  List<Map<String, dynamic>> parseDocumentsList() {
    if (document is List<dynamic> && document.isNotEmpty) {
      return [...document];// retornar uma nova instância do tipo desejado 
    } else {
      return _emptyListMapStringDynamic;
    }
  }

  Map<String, dynamic> parseDocumentMap() {
    if (document is Map<String, dynamic>) {
      return document;
    } else {
      return _emptyMapStringDynamic;
    }
  }

  Map<String, dynamic>? parseDocumentMapOrNull() {
    // if (document is Map<String, dynamic>) {
    //   return document;
    // } else {
    //   return null;
    // }
    try {
      return document as Map<String, dynamic>;
    } on TypeError {
      return null;
    } catch (_) {
      return null;
    }
  }

  factory MongoDBRequestData.fromMap(Map<String, dynamic> map) {

    try {

      map.update(
        'insertedIds', 
        (ids) => <String>[...ids],
        ifAbsent: () => _emptyListString,
      );

      return MongoDBRequestData(
        requestSuccess: map['success'] ?? false,
        document: map['document'] ?? map['documents'],
        deletedCount: map['deletedCount'] ?? _count,
        matchedCount: map['matchedCount'] ?? _count,
        modifiedCount: map['modifiedCount'] ?? _count,
        insertedId: map['insertedId'] ?? _emptyString,
        insertedIds: map['insertedIds'] ?? _emptyListString,
      );

    } on TypeError catch (error, stackTrace) {
      final String message = 'Erro ao tentar definir/atribuir um objeto em uma '
        'variavel/atributo com tipo diferente';
      log(
        message,
        name: '$MongoDBRequestData.fromMap',
        error: error,
        stackTrace: stackTrace, 
      );
      throw MongoDBRequestDataExeception(message);
    } catch (error, stackTrace) {
      final String message = 'Erro não tratado ao tentar ler os dados recebidos da requisição MongoDB';
      log(
        message,
        name: '$MongoDBRequestData.fromMap',
        error: error,
        stackTrace: stackTrace, 
      );
      throw MongoDBRequestDataExeception(message);
    }

  }

}

final class MongoDBRequestDataExeception implements Exception {
  final String message;
  const MongoDBRequestDataExeception(this.message);
  @override
  String toString() => message;
}