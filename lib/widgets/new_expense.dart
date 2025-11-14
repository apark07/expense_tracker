import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/cupertino.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _showErrorDialogue(String message) {
    showDialog(context: context,
      builder: (context) => AlertDialog(
        title: Text("Invalid Input"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _submitExpenseData() {
    if (_titleController.text.trim().isEmpty) {
      _showErrorDialogue("Please enter a valid title.");
      return;
    }
    final enteredAmnt = double.tryParse(_amountController.text);
    if (enteredAmnt == null || enteredAmnt <= 0) {
      _showErrorDialogue("Please enter a valid amount.");
      return;
    }

    if (_selectedDate == null) {
      _showErrorDialogue("Please choose a date.");
      return;
    }

    widget.onAddExpense(
      Expense(
        amount: enteredAmnt,
        date: _selectedDate!,
        title: _titleController.text,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final chosenDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: DateTime.now(),
    );
    setState(() {
      _selectedDate = chosenDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom; // Get the space taken by the keyboard
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 48.0, 16.0, keyboardSpace + 16.0), // Add padding at the bottom equal to keyboard space so that content is not hidden
      child: Column(
        children: [
          TextField(
            maxLength: 50,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(label: Text("Title")),
            controller: _titleController,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    prefixText: "\$ ",
                    label: Text("Amount"),
                  ),
                  controller: _amountController,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end, // Align to the right
                  crossAxisAlignment: CrossAxisAlignment.center, // Center vertically
                  children: [
                    Text(_selectedDate == null
                        ? "No Date Chosen"
                        : formatter.format(_selectedDate!)), // note to self: ! means "this nullable variable isnt null, trust me", so dart wont throw potential null exceptions/errors
                    IconButton(
                      onPressed: () {
                        _presentDatePicker();
                      },
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
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
                    child: Text(category.name.toUpperCase()),
                  ),
                ).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  _submitExpenseData();
                },
                child: Text("Save"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}