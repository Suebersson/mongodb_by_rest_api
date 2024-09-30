import './id_field.dart';

extension ComplementMongoDBForData on Map<String, dynamic> {
  
  void addUnderscoreInIdField() {
    if (containsKey(IdField.withoutUnderscore) && !containsKey(IdField.withUnderscore)) {
      addAll({IdField.withUnderscore: this[IdField.withoutUnderscore]});
      remove(IdField.withoutUnderscore);
    }
  }

  void addQueryFieldWithTest({
    required bool test, required String key, required dynamic value,}) {
    if (test) {
      update(
        key, (_) => value,
        ifAbsent: () => value,
      );
    }
  }

  // https://www.mongodb.com/pt-br/docs/manual/reference/operator/update/positional/
  //
  /// O operador $ posicional identifica um elemento em uma array para atualizar sem 
  /// especificar explicitamente a posição do elemento na array
  Map<String, dynamic> $(final String arrayName) {
    final Map<String, dynamic> data = {};
    forEach((key, value) {
      data.addAll({'$arrayName.\$.$key': value});
    },);
    return data;
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