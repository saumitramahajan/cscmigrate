
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UploadAnnualData extends StatefulWidget {
  @override
  _UploadAnnualDataState createState() => _UploadAnnualDataState();
}

class _UploadAnnualDataState extends State<UploadAnnualData> {
  Future<void> annualData() async {
    for (int i = 1; i < 13; i++) {
      FirebaseFirestore.instance
          .collection('locations')
          .doc('fnvDF4f7E7YJYytG5vuM')
          .collection('monthlyData')
          .doc('month$i')
          .set({
        "adCategory": 'category1',
        "manPower": i,
        "fatal": i,
        "fatalAccidents": i,
        'seriousAccidents': i,
        "reportableAccidents": i,
        "manDaysLost": i,
        "noReportableAccidents": i,
        "manDaysLostNra": i,
        "firstaidAccidents": i,
        "totalAccidents": i,
        "fireIncident": i,
        "fireIncidentMinor": i,
        "kaizen": i,
        "identified": i,
        "safetyActivityRate": i,
        "closureOf": i,
        "themeBasedInspections": i,
        "nearMissIncident": i
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(onPressed: () {
          annualData();
        }),
      ),
    );
  }
}
