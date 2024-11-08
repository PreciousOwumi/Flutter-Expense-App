import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';

import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();

enum Category { food, travel, leisure, work }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();
  /*The category is actually being passed as an argument to the constructor, 
  which is this.category when you create an ExpenseBucket object using this 
  named constructor forCategory.

  this.category refers to the variable of the named arguement (category) in the 
  ExpenseBucket class.

  The category parameter or arguement is passed to the constructor as an 
  argument when you call ExpenseBucket.forCategory.

  Here's how it works:
  When you use the constructor ExpenseBucket.forCategory(allExpenses, 'Food'), 
  you are passing two things:

  allExpenses: A list of all expenses, which might contain multiple categories
  (e.g., "Food", "Entertainment", etc.).
  'Food': A specific category you want to filter the expenses by.
  The category parameter in the constructor (this.category) gets assigned the
  value 'Food' (or whatever category you provide). This value is used in the 
  .where() function to filter expenses.

  This category argument is used to filter the expenses that belong to that 
  specific category from the list of allExpenses.

  This code can be understood as 'where the expense.category of each expense in
  allExpenses (a list of expenses) is the same with this.category, the expense 
  will be saved to the named arguement expenses' */

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount /*same as sum = sum + expense.amount;*/;
    }
    return sum;

    /*This is a getter method for calculating the total expenses for 
  the category.

  sum: A local variable that starts at 0. This will accumulate the total of all
  expenses.

  The for loop iterates over each expense in the expenses list. For each 
  expense, it adds the amount of that expense to the sum..

  After iterating through all the expenses, the method returns the total sum. 
  So, this method calculates the total amount of money spent in the category 
  associated with the ExpenseBucket. */
  }
}

/*the only thing i dont understand here is how and when the named arguement
category in the ExpenseBucket class receives its variable */