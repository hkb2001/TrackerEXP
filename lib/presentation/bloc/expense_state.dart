import 'package:equatable/equatable.dart';


abstract class ExpenseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<Expense> expenses;
  final double totalBalance;

  ExpenseLoaded({
    required this.expenses,
    required this.totalBalance,
  });

  @override
  List<Object?> get props => [expenses, totalBalance];
}

class ExpenseError extends ExpenseState {
  final String error;

  ExpenseError({required this.error});

  @override
  List<Object?> get props => [error];
}

class Expense extends Equatable {
  final double amount;
  final String title;
  final String category;
  final DateTime date;

  const Expense({
    required this.amount,
    required this.title,
    required this.category,
    required this.date,
  });

  @override
  List<Object?> get props => [amount, title, category, date];
}
