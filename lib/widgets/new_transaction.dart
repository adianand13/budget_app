import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function _newTransaction;

  NewTransaction(this._newTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  final FocusNode _titleFocus = FocusNode();
  final FocusNode _amountFocus = FocusNode();

  void _submitData() {
    final title = _titleController.text;
    final amount = double.parse(_amountController.text);
    final selectedDate = _selectedDate;

    //validation
    if (title.isEmpty || amount <= 0 || _selectedDate == null) return;

    widget._newTransaction(
      title,
      amount,
      selectedDate,
    );
    Navigator.of(context).pop();
  }

  void _datePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return null;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  controller: _titleController,
                  autocorrect: true,
                  focusNode: _titleFocus,
                  autofocus: true,
                  onSubmitted: (term) {
                    _titleFocus.unfocus();
                    FocusScope.of(context).requestFocus(_amountFocus);
                  }),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                autocorrect: true,
                // i get the mandatory argument, but I dont need it
                onSubmitted: (_) => _submitData,
                focusNode: _amountFocus,
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(_selectedDate == null
                            ? 'No Date Chosen'
                            : 'picked date : ${DateFormat.yMd().format(_selectedDate)}')),
                    FlatButton(
                      child: Text(
                        'Choose Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: _datePicker,
                      textColor: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ),
              RaisedButton(
                child: Text('Add Transaction'),
                onPressed: _submitData,
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
              )
            ],
          ),
        ));
  }
}
