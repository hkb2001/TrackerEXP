import 'package:expense_tracker/presentation/bloc/expense_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/presentation/bloc/authentication_bloc.dart';
import 'package:expense_tracker/presentation/bloc/expense_bloc.dart'; // Import your ExpenseBloc
import 'package:expense_tracker/presentation/screens/login_screen.dart';
import 'package:expense_tracker/presentation/screens/expense_home_screen.dart';
import 'package:expense_tracker/presentation/screens/add_expense_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationBloc(),
        ),
        BlocProvider(
          create: (context) => ExpenseBloc()..add(LoadExpenses()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense Tracker',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const ExpenseHomeScreen(email: 'default@example.com'),
          '/add': (context) => const AddExpenseScreen(),
        },
      ),
    );
  }
}
