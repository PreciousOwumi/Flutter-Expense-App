import 'package:flutter/material.dart';

import 'package:competence/chart_bar.dart';

import 'package:competence/models/expense.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.expenses});

  final List<Expense> expenses;

  List<ExpenseBucket> get buckets {
    return [
      ExpenseBucket.forCategory(expenses, Category.food),
      ExpenseBucket.forCategory(expenses, Category.leisure),
      ExpenseBucket.forCategory(expenses, Category.travel),
      ExpenseBucket.forCategory(expenses, Category.work),
    ];
  } /* buckets here returns a List<ExpenseBucket> of each of the categories 
  respectively, there making it a type List<ExpenseBucket> because it returns
   a List<ExpenseBucket> of each of the categories respectively.*/

  double get maxTotalExpense {
    double maxTotalExpense = 0;

    for (final bucket in buckets) {
      if (bucket.totalExpenses > maxTotalExpense) {
        maxTotalExpense = bucket.totalExpenses;
      }
    }
    /* bucket here by implication is of type ExpenseBuckets because it is 
    only single ExpenseBuckets that you can find in a LIst<ExpenseBucket>
    
    Initialization: A local variable maxTotalExpense is initialized to 0. This 
    will hold the maximum value as we loop through the buckets.

    Loop Through Buckets: The for (final bucket in buckets) loop iterates over
    each ExpenseBucket in the buckets list. For each bucket:

    The totalExpenses of the current bucket is compared to the maxTotalExpense
    value.
    If the totalExpenses of the current bucket is greater than maxTotalExpense, 
    then maxTotalExpense is updated to this new value.
    Final Value: After the loop has finished, maxTotalExpense will hold the 
    highest total expense found in any of the buckets because of the
    comparison logic in the getter. It checks each bucket's totalExpenses 
    and updates the maxTotalExpense whenever a larger value is found. This 
    ensures that at the end of the iteration, maxTotalExpense contains the
    largest expense among all categories, which is then used to scale the
    bars in the chart proportionally.*/

    return maxTotalExpense;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    /*isDarkMode checks if the current platform's brightness is dark mode. 
        This is done using MediaQuery.of(context).platformBrightness. If the 
        current brightness is Brightness.dark, isDarkMode will be true, and app
        ChartBar will be viewed in dark mode and if false ChartBar will be 
        viewed in light mode.*/
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
            Theme.of(context).colorScheme.primary.withOpacity(0.0)
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final bucket in buckets) // alternative to map()
                  ChartBar(
                    fill: bucket.totalExpenses == 0
                        ? 0
                        : bucket.totalExpenses / maxTotalExpense,
                  )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: buckets
                .map(
                  (bucket) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Icon(
                        categoryIcons[bucket.category],
                        color: isDarkMode
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.7),
                      ),
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
