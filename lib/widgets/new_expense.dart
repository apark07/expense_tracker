import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'dart:io';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _costController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _showDialog(){
    if(Platform.isIOS){
      showCupertinoDialog(
        context: context,
        builder: ((ctx) => CupertinoAlertDialog(
          title: const Text("Invalid Input"),
          content: const Text("Please make sure to have valid Title, Date and Amount!"),
          actions:[
            TextButton(onPressed: (){
              Navigator.pop(ctx);
            },
            child: const Text("Okay!"),)
            ],
          )
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: ((ctx) => AlertDialog(
          title: const Text("Invalid Input"),
          content: const Text("Please make sure to have valid Title, Date and Amount!"),
          actions:[
            TextButton(onPressed: (){
              Navigator.pop(ctx);
            },
            child: const Text("Okay!"),)
            ],
          )
        ),
      );
    }
  }

  @override
  void dispose(){
    _titleController.dispose();
    _costController.dispose();
    super.dispose();
  
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_costController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if(_titleController.text.trim().isEmpty || amountIsInvalid || _selectedDate == null){
      //show some error -> tell the user it cant be empty
      _showDialog();
      return;
    }
    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  void _presentDatePicker() async{
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,

    );
    setState((){
       _selectedDate = pickedDate;
    });
   
    
  }
  
  @override
  Widget build(BuildContext context) {
    // final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(label: Text("Title")),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _costController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [],
                  decoration: InputDecoration(
                    prefixText: "\$",
                    label: Text("Cost"),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(_selectedDate == null ? 'Select a Date' : formatter.format(_selectedDate!)),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ]
                ),
              ),
            ],
          ),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items: Category.values.map(
                  (category) => DropdownMenuItem(
                    value: category,
                    child: Text(category.name.toString().toUpperCase(),),),
                  ).toList(),
                onChanged: (value){
                  if(value == null){
                    return;
                  }
                  setState((){
                    _selectedCategory = value;
                    print(_selectedCategory);
                  });
                },
              ),
              Spacer(),
              ElevatedButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Cancel")),
              ElevatedButton(
                onPressed: _submitExpenseData,
                child: Text("Save expense")
              ),
            ],
          )
        ],
      ),
    );
  }
}