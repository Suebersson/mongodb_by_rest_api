
final class UriMethods {
  
  const UriMethods._({
    required this.findOne, 
    required this.find, 
    required this.insertOne, 
    required this.insertMany, 
    required this.updateOne, 
    required this.updateMany, 
    required this.deleteOne, 
    required this.deleteMany, 
    required this.aggregate,
  });

  factory UriMethods(String endpoint) {
    return UriMethods._(
      findOne: Uri.parse('$endpoint/action/findOne'), // post
      find: Uri.parse('$endpoint/action/find'), // post
      insertOne: Uri.parse('$endpoint/action/insertOne'), // post
      insertMany: Uri.parse('$endpoint/action/insertMany'), // post
      updateOne: Uri.parse('$endpoint/action/updateOne'), // post
      updateMany: Uri.parse('$endpoint/action/updateMany'), // post
      deleteOne: Uri.parse('$endpoint/action/deleteOne'), // post
      deleteMany: Uri.parse('$endpoint/action/deleteMany'), // post
      aggregate: Uri.parse('$endpoint/action/aggregate'),// post
    );
  }

  final Uri 
    findOne,
    find,
    insertOne,
    insertMany,
    updateOne,
    updateMany,
    deleteOne,
    deleteMany,
    aggregate;

}