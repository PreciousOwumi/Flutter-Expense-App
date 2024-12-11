import 'package:competence/models/expense.dart';

import 'package:competence/widget/expenses_item.dart';

import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.onRemovedExpense});

  final List<Expense> expenses;

  final void Function(Expense expense) onRemovedExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) => Dismissible(
        key: ValueKey(
          expenses[index],
        ),
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.75),
          margin: EdgeInsets.symmetric(
            horizontal: Theme.of(context).cardTheme.margin!.horizontal,
            /* Here we are simply importing the set horizontal value that
            was used while creating the cardtheme instead of seting another 
            horizontal value*/
          ),
        ),
        onDismissed: (direction) {
          onRemovedExpense(
            expenses[index],
            /* onRemovedExpense is the logic attached to the dismissible
             widget to ensure that the swiped item is also deleted not 
             only on the UI but also on the data model (list of expenses) */
          );
        },
        child: ExpenseItem(
          expenses[index],
          /* in the expense list we determine or set how all the argument
          values in each Expense widget are to be arranged in the
           ListView.builder*/
        ),
      ),
    );
  }
}
