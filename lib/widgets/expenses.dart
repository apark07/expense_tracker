import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
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
      builder: (ctx) => NewExpense(onAddExpense: _addExpense,),
      isScrollControlled: true,
    );
  }

  void _addExpense(Expense expense)
  {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }
  void _removeExpense(Expense expense){
    int expenseIndex = _registeredExpenses.indexOf(expense);
    setState((){
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Exoense Deleted'),
      duration: Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: (){
        setState(() {
          _registeredExpenses.insert(expenseIndex,expense);
      } );
      },
      ),
      ),
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
    Widget mainContent = const Center(
      child: Text("Click the + button to add an expense!"),);
    
      if(_registeredExpenses.isNotEmpty){
        mainContent = ExpensesList(
          expenses: _registeredExpenses, 
          onRemoveExpense: _removeExpense,
        );
      }
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
          Expanded(child: mainContent)
        ]
      ),
    );
  }
}
