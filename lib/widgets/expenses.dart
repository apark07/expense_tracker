import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      context: context,
      builder: (context) => NewExpense(onAddExpense: _addExpense),
      isScrollControlled: true,
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    int expenseIdx = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Expense deleted."),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIdx, expense);
            });
          },
        ),
      ),
    );
  }

  final List<Expense> _registeredExpenses = [
    Expense(
      title: "Cheeseburger",
      amount: 12.45,
      date: DateTime.now(),
      category: Category.food,
    ),
    Expense(
      title: "Spider-Man Movie",
      amount: 15.00,
      date: DateTime.now(),
      category: Category.leisure,
    ),
    Expense(
      title: "Office Supplies",
      amount: 75.23,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: "Flight to London",
      amount: 250.36,
      date: DateTime.now(),
      category: Category.travel,
    ),
  ];

  
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    Widget mainContent = const Center(child: Text("Click the + icon to add an expense"),);
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(expenses: _registeredExpenses, onRemoveExpense: _removeExpense);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: (width < 600) ?
        Column(
          children: [
            Chart(expenses: _registeredExpenses),
            Expanded(
              child: mainContent,
            ),
          ],
        )
      :
        Row(
          children: [
            Expanded(
              child: Chart(expenses: _registeredExpenses),
            ),
            Expanded(
              child: mainContent,
            ),
          ],
        ),
    );
  }
}