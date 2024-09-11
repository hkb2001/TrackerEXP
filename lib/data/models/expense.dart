import 'package:isar/isar.dart';
part 'expense.g.dart';
@Collection()
class Expense {
  Id id = Isar.autoIncrement;

  late String userEmail;
  late double amount;
  late String title;
  late String category;
  late DateTime date;
}