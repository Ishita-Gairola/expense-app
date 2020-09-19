import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label; //detects weedDay
  final double spendingAmount;
  final double spendingPctOfTotal;

  ChartBar(this.label, this.spendingAmount, this.spendingPctOfTotal);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
            '\u{20B9} ${spendingPctOfTotal.toStringAsFixed(0)}'), //present rounded percentage coz of toStringAsFixed
        SizedBox(
          height: 4,
        ), //spacing
        //main bar
        Container(
          height: 60,
          width: 10,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  color: Color.fromRGBO(220, 220, 220, 1), //background color
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                heightFactor: spendingPctOfTotal, //value can be between 0 and 1
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 4,
        ), //for spacing
        Text(label), //weekday
      ],
    );
  }
}
