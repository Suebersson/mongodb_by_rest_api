final class MongoDBExeception implements Exception {
  final String message;
  const MongoDBExeception(this.message);
  static T generate<T>(final String message) => throw MongoDBExeception(message); 
  @override
  String toString() => message;
}