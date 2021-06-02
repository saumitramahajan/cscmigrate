import 'dart:convert';
import 'dart:ui';
import 'dart:html' as html;

import 'package:csv/csv.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

import 'package:flutter/material.dart';
import 'package:mahindraCSC/roles/admin/annualData/annualDataProvider.dart';
import 'package:mahindraCSC/utilities.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ReviewAnnualData extends StatefulWidget {
  @override
  _ReviewAnnualDataState createState() => _ReviewAnnualDataState();
}

class _ReviewAnnualDataState extends State<ReviewAnnualData> {
  Utilities utilities = Utilities();
  ScrollController _controller = ScrollController();
  bool loading = false;

  String error = 'No Error';
  @override
  Widget build(BuildContext context) {
    getCsv(List<List<String>> rows) async {
      String csv = const ListToCsvConverter().convert(rows);

      final bytes = utf8.encode(csv);
      final blob = html.Blob([bytes], 'report/csv');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = 'finalReport.csv';
      html.document.body.children.add(anchor);
      anchor.click();
      html.document.body.children.remove(anchor);
      html.Url.revokeObjectUrl(url);
      // if (await canLaunch(url)) await launch(url);
      // html.window.open(url, "_blank");
      // html.Url.revokeObjectUrl(url);
    }

    final provider = Provider.of<AnnualDataProvider>(context);
    List<bool> view =
        List.generate(provider.listOfMonths.length, (index) => false);
    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              backgroundColor: utilities.mainColor,
              titleSpacing: 0.0,
              automaticallyImplyLeading: false,
            ),
            body: Center(
                child: provider.loading
                    ? CircularProgressIndicator()
                    : Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Column(children: [
                          Expanded(
                            child: DraggableScrollbar.rrect(
                              alwaysVisibleScrollThumb: true,
                              backgroundColor: utilities.mainColor,
                              controller: _controller,
                              child: ListView.builder(
                                  controller: _controller,
                                  itemCount: provider.listOfMonths.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        SizedBox(height: 30),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 120,
                                              child: Container(
                                                  padding: EdgeInsets.all(7),
                                                  decoration: new BoxDecoration(
                                                    borderRadius:
                                                        new BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    8),
                                                            topRight:
                                                                Radius.circular(
                                                                    8)),
                                                    color: utilities.mainColor,
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        provider.listOfMonths[
                                                            index]['monthName'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ],
                                        ),
                                        Card(
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                'Closure: ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                'Fatal: ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                'On-Duty Road Accidents(Fatal): ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                'Fire Incident (Major): ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                'Fire Incident (Minor): ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                'First Aid Accidents: ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                'Identified UA/UC: ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                'Kaizen/Poka-Yoke: ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                'Man Days Lost (RA): ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                provider
                                                                    .listOfMonths[
                                                                        index][
                                                                        'closureOf']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                provider
                                                                    .listOfMonths[
                                                                        index][
                                                                        'fatal']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                provider
                                                                    .listOfMonths[
                                                                        index][
                                                                        'fatalAccidents']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                provider
                                                                    .listOfMonths[
                                                                        index][
                                                                        'fireIncident']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                provider
                                                                    .listOfMonths[
                                                                        index][
                                                                        'fireIncidentMinor']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                provider
                                                                    .listOfMonths[
                                                                        index][
                                                                        'firstaidAccidents']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                provider
                                                                    .listOfMonths[
                                                                        index][
                                                                        'identified']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                provider
                                                                    .listOfMonths[
                                                                        index][
                                                                        'kaizen']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                provider
                                                                    .listOfMonths[
                                                                        index][
                                                                        'manDaysLost']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                            ],
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 100,
                                                  ),
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                'Man Days Lost (NRA): ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                'Man Power: ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                'Near Miss Incident: ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                'Non Reportable Accidents: ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                'Reportable Accidents: ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                'Safety Activity Rate: ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                'Serious Accidents: ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                'Theme Based Inspections: ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                'Total Accidents: ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              )
                                                            ],
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                  provider
                                                                      .listOfMonths[
                                                                          index]
                                                                          [
                                                                          'manDaysLostNra']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                  provider
                                                                      .listOfMonths[
                                                                          index]
                                                                          [
                                                                          'manPower']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                  provider
                                                                      .listOfMonths[
                                                                          index]
                                                                          [
                                                                          'nearMissIncident']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                  provider
                                                                      .listOfMonths[
                                                                          index]
                                                                          [
                                                                          'noReportableAccidents']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                  provider
                                                                      .listOfMonths[
                                                                          index]
                                                                          [
                                                                          'reportableAccidents']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                  provider
                                                                      .listOfMonths[
                                                                          index]
                                                                          [
                                                                          'safetyActivityRate']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                  provider
                                                                      .listOfMonths[
                                                                          index]
                                                                          [
                                                                          'seriousAccidents']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                  provider
                                                                      .listOfMonths[
                                                                          index]
                                                                          [
                                                                          'themeBasedInspections']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                provider
                                                                    .listOfMonths[
                                                                        index][
                                                                        'totalAccidents']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        RaisedButton(
                                          child: loading == true
                                              ? CircularProgressIndicator()
                                              : Text(
                                                  'Generate Report',
                                                ),
                                          onPressed: () async {
                                            await provider.locationCsv();

                                            setState(() {
                                              loading = true;
                                            });
                                            List<List<String>> rows =
                                                provider.getRows(index);
                                            await getCsv(rows);

                                            setState(() {
                                              loading = false;
                                            });
                                          },
                                        )
                                      ],
                                    );
                                  }),
                            ),
                          ),
                        ]),
                      ))),
        SizedBox(
          height: AppBar().preferredSize.height * 2,
          child: Image.asset(
            'assets/mahindraAppBar.png',
            fit: BoxFit.contain,
          ),
        )
      ],
    );
  }
}
