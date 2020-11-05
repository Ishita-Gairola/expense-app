import 'package:flutter/material.dart';
import './chart_bar.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValue {
    return List.generate(
      7,
      (index) {
        final weekDay = DateTime.now().subtract(Duration(days: index));
        var totalSum = 0.0;

        for (var i = 0; i < recentTransactions.length; i++) {
          if (recentTransactions[i].date.day == weekDay.day &&
              recentTransactions[i].date.month == weekDay.month &&
              recentTransactions[i].date.year == weekDay.year) {
            totalSum += recentTransactions[i].amount;
          }
        }
        return {
          'day': DateFormat.E()
              .format(weekDay)
              .substring(0, 1), //substring for day first letter
          'amount': totalSum
        }; //intl package
      },
    );
  }

  double get totalSpending {
    return groupedTransactionValue.fold(0.0, (sum,
            item) //fold() helps to change list to another type with a logic we provide
        {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceAround, //spreading out the chart bar
          children: groupedTransactionValue.map((data) {
            return Flexible //Expanded <widget> is an alternative with FlexFit.tight as default
                (
              fit: FlexFit
                  .tight, //force child into its assigned size and it can't grow (for large amount values)
              child: ChartBar(
                data['day'],
                data['amount'],
                totalSpending == 0.0
                    ? 0.0
                    : (data['amount'] as double) / totalSpending,
              ),
            ); //string interpolation
          }).toList(),
        ),
      ),
    );
  }
}
