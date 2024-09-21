import './id_field.dart';

extension ComplementMongoDBForData on Map<String, dynamic> {
  
  void addUnderscoreInIdField() {
    if (containsKey(IdField.withoutUnderscore) && !containsKey(IdField.withUnderscore)) {
      addAll({IdField.withUnderscore: this[IdField.withoutUnderscore]});
      remove(IdField.withoutUnderscore);
    }
  }

}

extension ComplementMongoDBForListString on List<String> {

  List<String> get addUnderscoreInIdField {
    if (contains(IdField.withoutUnderscore) && !contains(IdField.withUnderscore)) {
      final List<String> copy = [...this];
      copy.remove(IdField.withoutUnderscore);
      copy.insert(0, IdField.withUnderscore);
      return copy;
    } else {
      return this;
    }
  }

  List<String> get removeUnderscoreInIdField {
    if (contains(IdField.withUnderscore) && !contains(IdField.withoutUnderscore)) {
      final List<String> copy = [...this];
      copy.remove(IdField.withUnderscore);
      copy.insert(0, IdField.withoutUnderscore);
      return copy;
    } else {
      return this;
    }
  }

}