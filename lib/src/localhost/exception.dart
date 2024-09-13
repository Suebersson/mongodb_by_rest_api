final class MongoDBLocalhostExeception implements Exception {
  final String message;
  const MongoDBLocalhostExeception(this.message);
  @override
  String toString() => message;
}