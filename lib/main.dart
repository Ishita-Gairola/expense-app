import 'package:expense/widget/new_transactions.dart';
import 'package:expense/widget/transaction_list.dart';
import 'package:flutter/services.dart';
import './widget/chart.dart';
import 'package:flutter/material.dart';
import './widget/transaction_list.dart';
import './widget/new_transactions.dart';
import './models/transaction.dart';

void main() {
  //when you want to lock application in portrait mode
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //root widget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Where did my money go?',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.lime,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [];
  bool _showChart = false;
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransactions(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    ); //builder returns function which is inside modalbottomsheet
    //_ gets the package of meta information from showModalbottom of widget being built
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere(
          (tx) => tx.id == id); //removes item when certain conditionis met
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    //appBar variable has the height of the appBar hence can be accessed anywhere
    final appBar = AppBar(
      title: Text('Where did my money go?'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        )
      ],
    );
    final txListWidget = Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: <Widget>[
            //if({}) is not used since it's in a list
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Show Chart'),
                  Switch(
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      }),
                ],
              ),

            if (!isLandscape)
              Container(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.3,
                child: Chart(_recentTransactions),
              ),

            if (!isLandscape) txListWidget,

            //if true then shows chart else the list
            if (isLandscape)
              _showChart
                  ? Container(
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.3,
                      child: Chart(_recentTransactions),
                    )
                  : txListWidget
          ],
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat, //plus button in the bottom
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
