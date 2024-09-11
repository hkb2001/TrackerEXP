import 'package:equatable/equatable.dart';
import '../../data/models/expense.dart';

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
