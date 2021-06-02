import 'package:flutter/material.dart';

class MonthlyAnnualData extends StatefulWidget {
  @override
  _MonthlyAnnualDataState createState() => _MonthlyAnnualDataState();
}

class _MonthlyAnnualDataState extends State<MonthlyAnnualData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff4001c),
        title: SizedBox(
          height: AppBar().preferredSize.height,
          child: Image.asset(
            'assets/mahindraAppBar.png',
            fit: BoxFit.contain,
          ),
        ),
        titleSpacing: 0.0,
        automaticallyImplyLeading: false,
      ),
      body: Container(),
    );
  }
}
