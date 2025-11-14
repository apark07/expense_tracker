import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  const ChartBar({super.key, required this.fill});
  final double fill;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: FractionallySizedBox(
          heightFactor: fill,
          child: DecoratedBox(
            decoration: BoxDecoration(
              //color: isDarkMode ? Colors.tealAccent : Colors.teal,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              shape: BoxShape.rectangle,
              color: isDarkMode ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary,
            ),
          )
        ),
      )
    );
  }

}