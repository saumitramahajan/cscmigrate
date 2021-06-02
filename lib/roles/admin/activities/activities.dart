import 'package:mahindraCSC/roles/admin/annualData/annualData.dart';

import 'loginProvider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class Activities extends StatefulWidget {
  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
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
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) => AnnualData(),
                                ));
                              }
                              break;

                            case 'selfAssessment':
                              {
                                //navigate to self assessment review page
                              }
                              break;

                            case 'siteAssessment':
                              {
                                //navigate to site assessment Review Page
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
