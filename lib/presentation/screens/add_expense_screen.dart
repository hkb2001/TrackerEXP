import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../data/models/expense.dart';
import '../bloc/authentication_state.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/authentication_bloc.dart'; // Import AuthenticationBloc

class AddExpenseScreen extends StatefulWidget {
  final Expense? expense;

  const AddExpenseScreen({super.key, this.expense});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  late DateTime _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  @override
  void dispose() {
    // context
    //     .read<ExpenseBloc>()
    //     .add(LoadExpenses());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.expense != null) {
      final expense = widget.expense!;
      _selectedDate = expense.date;
      _dateController.text = DateFormat.yMMMd().format(expense.date);
      _amountController.text = expense.amount.toString();
      _titleController.text = expense.title;
      _categoryController.text = expense.category;
    } else {
      _selectedDate = DateTime.now();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
        _dateController.text = DateFormat.yMMMd().format(_selectedDate);
      });
    }
  }

  void _saveExpense() {
    final double amount = double.tryParse(_amountController.text) ?? 0.0;
    final String title = _titleController.text;
    final String category = _categoryController.text;
    final DateTime date = _selectedDate;

    final authState = context.read<AuthenticationBloc>().state;
    if (authState is AuthenticationAuthenticated) {
      final userEmail = authState.email;

      if (widget.expense != null) {
        context.read<ExpenseBloc>().add(UpdateExpense(
          oldExpense: widget.expense!,
          newExpense: Expense()
            ..id = widget.expense!.id
            ..amount = amount
            ..title = title
            ..category = category
            ..date = date
            ..userEmail = userEmail,
        ));
      } else {
        context.read<ExpenseBloc>().add(AddExpense(
          amount: amount,
          title: title,
          category: category,
          dateTime: date,
          userEmail: userEmail,
        ));
      }

      Navigator.pop(context, true);
      context.read<ExpenseBloc>().add(LoadExpenses());

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not authenticated')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expense != null ? 'Edit Expense' : 'Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: SizedBox(
                width: 200,
                height: 60,
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Expense",
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: "Category"),
            ),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(labelText: "Date"),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveExpense,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
