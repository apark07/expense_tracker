import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/chart/chart_bar.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.expenses});

  final List<Expense> expenses;

  List<ExpenseBucket> get buckets {
    return [
      ExpenseBucket.forCategory(expenses, Category.food),
      ExpenseBucket.forCategory(expenses, Category.travel),
      ExpenseBucket.forCategory(expenses, Category.leisure),
      ExpenseBucket.forCategory(expenses, Category.work),
    ];
  }

  double get maxTotalExpenses {
    double maxTotalExpenses = 0;
    for (final bucket in buckets) {
      if (bucket.totalExpenses > maxTotalExpenses) {
        maxTotalExpenses = bucket.totalExpenses;
      }
    }
    return maxTotalExpenses;
  }
  
  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      width: double.infinity,
      height: 180, // fixed height for the chart
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.3), 
            Theme.of(context).colorScheme.primary.withValues(alpha: 0)
            ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final bucket in buckets)
                  ChartBar(
                    fill: bucket.totalExpenses == 0 ? 0 : bucket.totalExpenses / maxTotalExpenses,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: buckets.map((bucket) => 
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  categoryIcons[bucket.category],
                  color: isDarkMode ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                ),
              ),
            )).toList(),
          )
        ]
      )
    );
  }
}