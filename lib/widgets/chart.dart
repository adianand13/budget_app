import 'package:budget_app/models/transaction.dart';
import 'package:budget_app/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;

  Chart(this.recentTransaction);

  List<Map<String, Object>> get groupedTransaction {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(
        days: index,
      ));
      double totalSum = 0.0;

      for (var i = 0; i < recentTransaction.length; i++) {
        if (recentTransaction[i].date.day == weekDay.day &&
            recentTransaction[i].date.month == weekDay.month &&
            recentTransaction[i].date.year == weekDay.year) {
          totalSum += recentTransaction[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get maxTotal {
    return groupedTransaction.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Padding(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: groupedTransaction.map((data) {
                return Flexible(
                    fit: FlexFit.tight,
                    child: ChartBar(
                      data['day'],
                      data['amount'],
                      maxTotal == 0.0
                          ? 0.0
                          : (data['amount'] as double) / maxTotal,
                    ));
              }).toList()),
          padding: EdgeInsets.all(10),
        ),
      ),
    );
  }
}
