import 'package:expense_tracker/presentation/bloc/expense_event.dart';
import 'package:expense_tracker/presentation/bloc/expense_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final List<Expense> _expenses = [];
  double _totalBalance = 0.0;

  ExpenseBloc() : super(ExpenseInitial()) {
    on<AddExpense>((event, emit) async {
      emit(ExpenseLoading());
      try {
        _expenses.add(Expense(
          amount: event.amount,
          title: event.title,
          category: event.category,
          date: event.dateTime,
        ));
        _totalBalance += event.amount;

        emit(ExpenseLoaded(
          expenses: _expenses,
          totalBalance: _totalBalance,
        ));
      } catch (e) {
        emit(ExpenseError(error: e.toString()));
      }
    });

    on<LoadExpenses>((event, emit) {
      emit(ExpenseLoaded(
        expenses: _expenses,
        totalBalance: _totalBalance,
      ));
    });

    on<SearchExpenses>((event, emit) {
      final query = event.query.toLowerCase();
      final filteredExpenses = _expenses.where((expense) {
        return expense.title.toLowerCase().contains(query) ||
            expense.category.toLowerCase().contains(query);
      }).toList();

      emit(ExpenseLoaded(
        expenses: filteredExpenses,
        totalBalance: _totalBalance,
      ));
    });

    on<ExpenseDelete>((event, emit) {
      _expenses.remove(event.expense);
      _totalBalance -= event.expense.amount;

      emit(ExpenseLoaded(
        expenses: _expenses,
        totalBalance: _totalBalance,
      ));
    });

    on<UpdateExpense>((event, emit) {
      final oldExpenseAmount = event.oldExpense.amount;
      final newExpenseAmount = event.newExpense.amount;
      final index = _expenses.indexOf(event.oldExpense);

      if (index != -1) {
        final difference = newExpenseAmount - oldExpenseAmount;
        _totalBalance += difference;
        _expenses[index] = event.newExpense;

        emit(ExpenseLoaded(
          expenses: _expenses,
          totalBalance: _totalBalance,
        ));
      }
    });
  }
}
