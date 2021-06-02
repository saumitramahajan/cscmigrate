import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mahindraCSC/assessments/siteAssessment/siteAssessment.dart';
import 'package:mahindraCSC/roles/assessee/annualData/MonthlySafetyReportIT.dart';
import 'package:mahindraCSC/roles/assessee/annualData/monthly_safety_report.dart';

import 'loginProvider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class Activities extends StatefulWidget {
  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String assesseeUid = '';
  String loc = '';

  getCurrentUser(String cycleId) async {
    final User user = await auth.currentUser;
    final uid = user.uid;
    // Similarly we can get email as well
    //final uemail = user.email;b
    print(uid);
    assesseeUid = uid;
    getAssesseeLocation(cycleId);
    //print(uemail);
  }

  Future<String> getAssesseeLocation(String cycleId) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('locations');
    QuerySnapshot eventsQuery =
        await ref.where("assessee", isEqualTo: assesseeUid).get();
    loc = eventsQuery.docs[0]['category'];
    String locationName = eventsQuery.docs[0]['location'];
    var isIT = loc.indexOf("IT");
    if (isIT == -1) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return MonthlySafetyReport(
          type: 'assessment',
          cycleId: cycleId,
          locationName: locationName,
        );
      }));
    } else {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return MonthlySafetyReportIT(
          type: 'assessment',
          cycleId: cycleId,
          locationName: locationName,
        );
      }));
      return loc;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ActivitiesProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Activities'),
        ),
        body: Center(
            child: Container(
          child: Column(children: [
            Expanded(
                child: ListView.builder(
                    itemCount: provider.listOfDetails.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Card(
                          elevation: 5.0,
                          margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Content: ' +
                                            provider.listOfDetails[index]
                                                ['content']),
                                        Text('Date: ' +
                                            provider.listOfDetails[index]
                                                    ['date']
                                                .toString()),
                                        Text('CycleDocumentID: ' +
                                            provider.listOfDetails[index]
                                                ['cycleDocumentID']),
                                      ])),
                            ],
                          ),
                        ),
                        onTap: () {
                          switch (provider.listOfDetails[index]['type']) {
                            case 'annualData':
                              {
                                getCurrentUser(provider.listOfDetails[index]
                                    ['cycleDocumentID']);
                              }
                              break;

                            case 'selfAssessment':
                              {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) => SiteAssessment(
                                      'self',
                                      provider.listOfDetails[index]
                                          ['cycleDocumentID']),
                                ));
                              }
                              break;
                          }
                        },
                      );
                    })),
          ]),
        )));
  }
}
