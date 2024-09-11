import 'package:equatable/equatable.dart';

import '../../data/models/expense.dart';

abstract class ExpenseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddExpense extends ExpenseEvent {
  final double amount;
  final String title;
  final String category;
  final DateTime dateTime;
  final String userEmail;

  AddExpense({
    required this.userEmail,
    required this.amount,
    required this.title,
    required this.category,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [amount, title, category, dateTime, userEmail];
}

class SearchExpenses extends ExpenseEvent {
  final String query;

  SearchExpenses(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadExpenses extends ExpenseEvent {}

class ExpenseDelete extends ExpenseEvent {
  final Expense expense;

  ExpenseDelete(this.expense);

  @override
  List<Object?> get props => [expense];
}

class UpdateExpense extends ExpenseEvent {
  final Expense oldExpense;
  final Expense newExpense;

  UpdateExpense({
    required this.oldExpense,
    required this.newExpense,
  });

  @override
  List<Object?> get props => [oldExpense, newExpense];
}
