abstract mixin class IdField {

  // https://www.mongodb.com/docs/manual/core/document/#field-names
  static final String withUnderscore = '_id';
  static final String withoutUnderscore = 'id';
  static final List<String> exclude = List.unmodifiable([withUnderscore]);

  final String idField = withUnderscore;
  final List<String> excludeId = exclude;

}