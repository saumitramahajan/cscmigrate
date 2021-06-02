import 'package:flutter/material.dart';
import 'package:mahindraCSC/roles/admin/annualData/monthlyAnnualData.dart';
import 'package:provider/provider.dart';

import 'annualDataProvider.dart';

class AnnualDataForm extends StatefulWidget {
  @override
  _AnnualDataFormState createState() => _AnnualDataFormState();
}

class _AnnualDataFormState extends State<AnnualDataForm> {
  @override
  Widget build(BuildContext context) {
    final adProvider = Provider.of<AnnualDataProvider>(context);
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
      body: Container(
        child: Column(
          children: [
            /*RaisedButton(
              child: Text('Assessment Annual Data'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    adProvider.getAnnualDataAssessement();
                    return ChangeNotifierProvider.value(
                      value: adProvider,
                      child: AssessmentAnnualData(),
                    );
                  },
                ));
              },
            ),*/
            RaisedButton(
              child: Text('Monthly Annual Data'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return ChangeNotifierProvider.value(
                      value: adProvider,
                      child: MonthlyAnnualData(),
                    );
                  },
                ));
              },
            )
          ],
        ),
      ),
    );
  }
}
