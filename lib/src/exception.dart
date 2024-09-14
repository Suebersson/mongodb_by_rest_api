final class MongoDBExeception implements Exception {
  final String message;
  const MongoDBExeception(this.message);
  @override
  String toString() => message;
}