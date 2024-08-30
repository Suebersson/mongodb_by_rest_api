import 'dart:developer' show log;

final class MongoDBRequestData {

  const MongoDBRequestData({
    required this.document,
    required this.deletedCount,
    required this.matchedCount,
    required this.modifiedCount,
    required this.insertedId,
    required this.insertedIds,
  });

  /// será um objeto [null], [List] ou [Map] 
  final dynamic document;

  final int 
    deletedCount, /// documentos excluidos
    matchedCount, /// fields/campos localizados
    modifiedCount; /// fields/campos modificados

  /// id do documento inserido
  final String insertedId;

  /// Lista de ids dos documentos inseridos
  final List<String> insertedIds;

  static final List<String> _emptyListString = List.unmodifiable([]);
  static final int _count = 0;
  static final String _emptyString = '';

  factory MongoDBRequestData.fromMap(Map<String, dynamic> map) {

    try {

      return MongoDBRequestData(
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