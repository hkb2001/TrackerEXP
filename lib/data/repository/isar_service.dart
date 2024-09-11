import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/expense.dart';
import '../models/models.dart';

class IsarService {
  static Isar? _isar;
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [UserSchema, ExpenseSchema],
      directory: dir.path,
    );
  }

  static Isar get instance {
    if (_isar == null) {
      throw Exception('IsarService is not initialized. Call init() before accessing the instance.');
    }
    return _isar!;
  }
}
