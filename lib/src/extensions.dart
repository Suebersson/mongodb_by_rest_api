// ignore_for_file: unused_element

final String _idFieldWithUnderscore = '_id';
final String _idFieldWithoutUnderscore = 'id';

extension _ComplementForData on Map<String, dynamic> {
  
  void addUnderscoreInIdField() {
    if (containsKey(_idFieldWithoutUnderscore) && !containsKey(_idFieldWithUnderscore)) {
      addAll({_idFieldWithUnderscore: this[_idFieldWithoutUnderscore]});
      remove(_idFieldWithoutUnderscore);
    }
  }

}

extension _ComplementForListString on List<String> {

  List<String> get addUnderscoreInIdField {
    if (contains(_idFieldWithoutUnderscore) && !contains(_idFieldWithUnderscore)) {
      final List<String> copy = [...this];
      copy.remove(_idFieldWithoutUnderscore);
      copy.insert(0, _idFieldWithUnderscore);
      return copy;
    } else {
      return this;
    }
  }

  List<String> get removeUnderscoreInIdField {
    if (contains(_idFieldWithUnderscore) && !contains(_idFieldWithoutUnderscore)) {
      final List<String> copy = [...this];
      copy.remove(_idFieldWithUnderscore);
      copy.insert(0, _idFieldWithoutUnderscore);
      return copy;
    } else {
      return this;
    }
  }

}