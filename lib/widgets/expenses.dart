import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  State<Expenses> createState() {
    return _ExpensesStates();
  }
}

class _ExpensesStates extends State<Expenses> {
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      context: context, 
      builder: (ctx) => NewExpense(onAddExpense: _addExpense,),
      isScrollControlled: true,
    );
  }

  void _addExpense(Expense expense){
    setState((){
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense){
    int expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Expense Deleted!'),
      duration: Duration(seconds:3 ),
      action: SnackBarAction(label: 'Undo', onPressed: (){
        setState((){
          _registeredExpenses.insert(expenseIndex, expense);
        });
      }),
      )
    );
    
  }
  final List<Expense> _registeredExpenses = [
    Expense(
      title: "Cheeseburger",
      amount: 12.49,
      date: DateTime.now(),
      category: Category.food,
    ),
    Expense(
      title: "Movie Ticket",
      amount: 18.99,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    print("Width ${MediaQuery.of(context).size.width}");
    print("Height ${MediaQuery.of(context).size.height}");

    Widget mainContent = const Center(child: Text("Click the + button to add an Expense!"),);
    if(_registeredExpenses.isNotEmpty){
      mainContent = ExpensesList(expenses: _registeredExpenses, onRemoveExpense: _removeExpense,);
    }
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text("Expense Tracker")),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add)
          ),
        ],
      ),
      body: width < 600 
      ? Column(
          children: [
            Chart(expenses: _registeredExpenses), 
            Expanded(child: mainContent),
          ],
        )
      : Row(
          children: [
            Expanded(child: Chart(expenses: _registeredExpenses),),
            Expanded(child: mainContent),
          ],
        ),
        
    );
  }
}