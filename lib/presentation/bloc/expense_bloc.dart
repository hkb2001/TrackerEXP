import 'package:flutter/foundation.dart';
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
    on<SearchExpenses>(_onSearchExpenses);
  }

  Future<void> _onAddExpense(
      AddExpense event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());
    try {
      final expense = Expense()
        ..amount = event.amount
        ..title = event.title
        ..category = event.category
        ..date = event.dateTime
        ..userEmail = event.userEmail;

      await _isar.writeTxnSync(() async {
        await _isar.expenses.putSync(expense);
        await _loadExpenses(emit);
      });
    } catch (e) {
      emit(ExpenseError(error: e.toString()));
    }
  }

  Future<void> _onLoadExpenses(
      LoadExpenses event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());
    try {
      final expenses =
          await _isar.expenses.filter().userEmailEqualTo(_userEmail).findAll();

      debugPrint('expenses =: $expenses');

      final totalBalance = expenses.fold(0.0, (sum, e) => sum + e.amount);

      emit(ExpenseLoaded(expenses: expenses, totalBalance: totalBalance));
    } catch (e) {
      emit(ExpenseError(error: e.toString()));
    }
  }

  Future<void> _onUpdateExpense(
      UpdateExpense event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());
    try {
      final updatedExpense = Expense()
        ..id = event.newExpense.id
        ..amount = event.newExpense.amount
        ..title = event.newExpense.title
        ..category = event.newExpense.category
        ..date = event.newExpense.date
        ..userEmail = event.newExpense.userEmail;

      await _isar.writeTxnSync(() async {
        await _isar.expenses.putSync(updatedExpense);
        await _loadExpenses(emit);
      });
    } catch (e) {
      emit(ExpenseError(error: e.toString()));
    }
  }

  Future<void> _onExpenseDelete(
      ExpenseDelete event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());
    try {
      await _isar.writeTxnSync(() async {
        await _isar.expenses.deleteSync(event.expense.id);
      });

      await _loadExpenses(emit);
    } catch (e) {
      emit(ExpenseError(error: e.toString()));
    }
  }

  Future<void> _onSearchExpenses(
      SearchExpenses event, Emitter<ExpenseState> emit) async {
    if (state is ExpenseLoaded) {
      final allExpenses = (state as ExpenseLoaded).expenses;

      List<Expense> filteredExpenses;
      if (event.query.isEmpty) {
        filteredExpenses = allExpenses;
      } else {
        filteredExpenses = allExpenses
            .where((expense) =>
                expense.title.toLowerCase().contains(event.query.toLowerCase()))
            .toList();
      }
      final totalBalance =
          filteredExpenses.fold(0.0, (sum, e) => sum + e.amount);

      emit(ExpenseLoaded(
          expenses: filteredExpenses, totalBalance: totalBalance));
    }
  }

  Future<void> _loadExpenses(Emitter<ExpenseState> emit) async {
    try {
      debugPrint('Querying expenses for userEmail: $_userEmail');

      final expenses =
          await _isar.expenses.filter().userEmailEqualTo(_userEmail).findAll();

      debugPrint('Fetched expenses =: $expenses');

      final totalBalance = expenses.fold(0.0, (sum, e) => sum + e.amount);

      emit(ExpenseLoaded(expenses: expenses, totalBalance: totalBalance));
    } catch (e) {
      emit(ExpenseError(error: e.toString()));
    }
  }
}
