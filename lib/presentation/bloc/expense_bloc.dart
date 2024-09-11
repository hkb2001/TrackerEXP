import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:expense_tracker/data/models/expense.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final Isar _isar;
  final String _userEmail;

  ExpenseBloc(this._isar, this._userEmail) : super(ExpenseInitial()) {
    on<AddExpense>(_onAddExpense);
    on<LoadExpenses>(_onLoadExpenses);
    on<UpdateExpense>(_onUpdateExpense);
    on<ExpenseDelete>(_onExpenseDelete);
  }

  Future<void> _onAddExpense(AddExpense event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());
    try {
      final expense = Expense()
        ..amount = event.amount
        ..title = event.title
        ..category = event.category
        ..date = event.dateTime
        ..userEmail = event.userEmail;

      await _isar.writeTxn(() async {
        await _isar.expenses.put(expense);
      });

      add(LoadExpenses());
    } catch (e) {
      emit(ExpenseError(error: e.toString()));
    }
  }

  Future<void> _onLoadExpenses(LoadExpenses event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());
    try {
      final expenses = await _isar.expenses
          .filter()
          .userEmailEqualTo(_userEmail)
          .findAll();

      final totalBalance = expenses.fold(0.0, (sum, e) => sum + e.amount);

      emit(ExpenseLoaded(expenses: expenses, totalBalance: totalBalance));
    } catch (e) {
      emit(ExpenseError(error: e.toString()));
    }
  }

  Future<void> _onUpdateExpense(UpdateExpense event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());
    try {
      final updatedExpense = Expense()
        ..id = event.newExpense.id
        ..amount = event.newExpense.amount
        ..title = event.newExpense.title
        ..category = event.newExpense.category
        ..date = event.newExpense.date
        ..userEmail = event.newExpense.userEmail;

      await _isar.writeTxn(() async {
        await _isar.expenses.put(updatedExpense);
      });

      add(LoadExpenses());
    } catch (e) {
      emit(ExpenseError(error: e.toString()));
    }
  }

  Future<void> _onExpenseDelete(ExpenseDelete event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());
    try {
      await _isar.writeTxn(() async {
        await _isar.expenses.delete(event.expense.id);
      });

      add(LoadExpenses());
    } catch (e) {
      emit(ExpenseError(error: e.toString()));
    }
  }
}
