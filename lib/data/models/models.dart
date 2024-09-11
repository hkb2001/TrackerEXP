import 'package:isar/isar.dart';

part 'models.g.dart';

@Collection()
class User {
  Id id = Isar.autoIncrement;

  late String email;
}


