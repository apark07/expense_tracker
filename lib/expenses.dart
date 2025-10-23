import 'package:expense_tracker/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => NewExpense(),
    );
  }
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Cheeseburger',
      amount: 12.45,
      date: DateTime.now(),
      category: Category.food,
    ),
    Expense(
      title: 'Movie ticket',
      amount: 15.00,
      date: DateTime.now(),
      category: Category.leisure,
    ),
    Expense(
      title: 'Train ticket',
      amount: 35.00,
      date: DateTime.now(),
      category: Category.travel,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Expense Tracker'),
          actions: [
            IconButton(
              onPressed: _openAddExpenseOverlay, 
              icon: const Icon(Icons.add))],
        ),
              body: Column(
                children: [
          Text("Chart"),
          Expanded(child: ExpensesList(expenses: _registeredExpenses))
        ]
      ),
    );
  }
}
