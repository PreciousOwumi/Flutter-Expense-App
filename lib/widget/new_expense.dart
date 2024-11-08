import 'package:competence/models/expense.dart';

import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpense();
  }
}

class _NewExpense extends State<NewExpense> {
  final _titlecontroller = TextEditingController();
  final _amountcontroller = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountcontroller.text);
    /*.text property of the _amountcontroller (which is a TextEditingController)
     is used to convert the text entered by the user in the corresponding
     TextField to a String. 
     .trypase in double.trypase then converts or parse the string to a floating
     point number also know as a double (a number with a decimal point) if the 
     string is in the correct format(an int format e.g '23') but if the string 
     is not in the correct format(not in an int format e.g 'obi is a boy') then
     trypase() returns null */

    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titlecontroller.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
              'Please make sure a valid title, amount, date and category was entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
      return;
    }
    widget.onAddExpense(
      Expense(
          title: _titlecontroller.text,
          amount: enteredAmount,
          date: _selectedDate!,
          category: _selectedCategory),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titlecontroller.dispose();
    _amountcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titlecontroller,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text('Title'),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _amountcontroller,
                  decoration: const InputDecoration(
                    prefixText: '\$ ',
                    label: Text('Amount'),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'No date selected'
                          : formatter.format(_selectedDate!),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_month),
                      onPressed: _presentDatePicker,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                /*This binds the currently selected value of the dropdown
                 to the _selectedCategory variable. Initially, _selectedCategory
                 is set to Category.leisure as per the initialization. The 
                 DropdownButton will display this value (i.e., leisure) as the
                 selected item in the dropdown when the widget is rendered.*/
                items: Category
                    .values /*This creates the list of items (options) for the
                     dropdown.*/

                    .map(
                      (category) => DropdownMenuItem(
                        /* The map function is used to convert each enum value 
                        into a DropdownMenuItem widget. Each DropdownMenuItem 
                        represents a single item in the dropdown list and has a
                         value and a child.*/
                        value: category,
                        /* This is the arguement that stores the selected item
                        in the dropdownbutton and  this value will be passed to
                         the onChanged call back */
                        child: Text(
                          category.name.toUpperCase(),
                          /* This displays the name of the category 
                          (in uppercase) as the label for each dropdown item.
                           category.name gets the name of the enum value (for
                            example, leisure, food, etc.), and toUpperCase() 
                            converts it to uppercase for visual styling. */
                        ),
                      ),
                    )
                    .toList(),
                /*toList() is called at the end to convert the iterable 
                    returned by map into a list.*/
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(
                    () {
                      _selectedCategory = value;
                    },
                  );
                },
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _submitExpenseData,
                child: const Text('Save Expense'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
