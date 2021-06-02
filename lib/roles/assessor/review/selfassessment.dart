import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:mahindraCSC/roles/assessor/assessorDashboard.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utilities.dart';
import 'assessmentProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:readmore/readmore.dart';

class SelfAssessment extends StatefulWidget {
  String documentId;
  String nameofSite;
  String location;
String role;
  
  SelfAssessment(
      {Key key,
      @required this.documentId,
      @required this.nameofSite,
      @required this.location,
       @required this.role,
      })
      : super(key: key);
  @override
  _SelfAssessmentState createState() => _SelfAssessmentState();
}

class _SelfAssessmentState extends State<SelfAssessment> {
  String groupValue = '1';
  double displayTotal = 0;
  String displayTotalText = 'displayText';

  Widget displayContainer = Container();
  Utilities utilities = Utilities();
  ScrollController _controller = ScrollController();

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssessmentProvider>(context);

    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              backgroundColor: utilities.mainColor,
              titleSpacing: 0.0,
              automaticallyImplyLeading: false,
              title: (provider.assessmentType == 'self')
                  ? Row(
                      children: [
                        SizedBox(width: 300),
                        provider.dataLoading == false
                            ? Text(
                                "Self Assessment: " +
                                    widget.nameofSite +
                                    ',' +
                                    widget.location,
                                style: TextStyle(fontSize: 25),
                              )
                            : SizedBox()
                      ],
                    )
                  : Row(
                      children: [
                        SizedBox(width: 300),
                        provider.dataLoading == false
                            ? Text(
                                'Site Assessment: ' +
                                    widget.nameofSite +
                                    ',' +
                                    widget.location,
                                style: TextStyle(fontSize: 25))
                            : SizedBox(),
                      ],
                    ),
              actions: [
                Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: (provider.assessmentType == 'site' &&
                            provider.dataLoading == false)
                        ? Text(
                            'Overall Total: ' +
                                provider.overAllTotal.toString(),
                            style: TextStyle(fontSize: 22),
                          )
                        : SizedBox(),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  (provider.assessmentType == 'site'&&
                            provider.dataLoading == false && widget.role=='coAssessor')
                      ? FlatButton(
                          child: Text('Approve',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: new Text(
                                        'Have you reviewed all the Parameters?\nAre you sure you want to Approve?'),
                                    actions: <Widget>[
                                      new FlatButton(
                                        child: new Text('No'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      FlatButton(
                                        child: new Text('Yes'),
                                        onPressed: () async {
                                          await provider.approveAssessment(
                                              widget.documentId);
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                            builder: (context) =>
                                                AssessorDashboard(),
                                          ));
                                        },
                                      )
                                    ],
                                  );
                                });
                          })
                      : SizedBox()
                ])
              ],
            ),
            body: (provider.dataLoading)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                provider.assessmentType == 'self'
                                    ? Row(
                                        children: [
                                          SizedBox(width: 160),
                                          DropdownButton(
                                              value: groupValue,
                                              items: [
                                                DropdownMenuItem(
                                                  child:
                                                      Text('Process Parameter'),
                                                  value: '1',
                                                ),
                                                DropdownMenuItem(
                                                  child:
                                                      Text('Result Parameter'),
                                                  value: '2',
                                                ),
                                                DropdownMenuItem(
                                                  child: Text(
                                                      'Fire Safety Parameter'),
                                                  value: '3',
                                                ),
                                                DropdownMenuItem(
                                                  child: Text(
                                                      'Office Safety Parameter'),
                                                  value: '4',
                                                ),
                                              ],
                                              onChanged: (value) {
                                                setState(() {
                                                  groupValue = value;
                                                  _controller.jumpTo(0);
                                                });
                                              }),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          SizedBox(width: 190),
                                          DropdownButton(
                                              value: groupValue,
                                              items: [
                                                DropdownMenuItem(
                                                  child:
                                                      Text("Process Parameter"),
                                                  value: '1',
                                                ),
                                                DropdownMenuItem(
                                                  child:
                                                      Text("Result Parameter"),
                                                  value: '2',
                                                ),
                                                DropdownMenuItem(
                                                  child:
                                                      Text("Site Risk Profile"),
                                                  value: '3',
                                                ),
                                                DropdownMenuItem(
                                                  child: Text(
                                                      "Fire Safety Assessment"),
                                                  value: '4',
                                                ),
                                                DropdownMenuItem(
                                                  child: Text(
                                                      "Fire Safety Management Profile"),
                                                  value: '5',
                                                ),
                                                DropdownMenuItem(
                                                  child: Text(
                                                      "Office Safety Assessment"),
                                                  value: '6',
                                                ),
                                                DropdownMenuItem(
                                                  child: Text(
                                                      "Office Safety Risk Profile"),
                                                  value: '7',
                                                ),
                                                DropdownMenuItem(
                                                  child: Text(
                                                      "Summary Of Risk Profile"),
                                                  value: '8',
                                                ),
                                              ],
                                              onChanged: (value) {
                                                setState(() {
                                                  groupValue = value;

                                                  if (groupValue == '2') {
                                                    displayTotal =
                                                        provider.resultTotal;
                                                    displayTotalText =
                                                        'Result Total: ';
                                                    _controller.jumpTo(0);
                                                  } else if (groupValue ==
                                                      '4') {
                                                    displayTotal =
                                                        provider.fireTotal;
                                                    displayTotalText =
                                                        'Fire Total: ';
                                                    _controller.jumpTo(0);
                                                  } else if (groupValue ==
                                                      '6') {
                                                    displayTotal =
                                                        provider.officeTotal;
                                                    displayTotalText =
                                                        'Office Total: ';
                                                    _controller.jumpTo(0);
                                                  }
                                                });
                                              }),
                                        ],
                                      ),
                                SizedBox(
                                  width: 180,
                                ),
                                provider.assessmentType == 'site' &&
                                        (int.parse(groupValue) == 1 ||
                                            int.parse(groupValue) == 2 ||
                                            int.parse(groupValue) == 4 ||
                                            int.parse(groupValue) == 6)
                                    ? (groupValue == '2' ||
                                            groupValue == '4' ||
                                            groupValue == '6')
                                        ? Text(
                                            displayTotalText +
                                                displayTotal.toString(),
                                            style: TextStyle(fontSize: 25))
                                        : Text(
                                            'Process Total: ' +
                                                provider.processTotal
                                                    .toString(),
                                            style: TextStyle(fontSize: 25))
                                    : SizedBox()
                              ]),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  provider.assessmentType == 'self'
                                      ? containerDecision(groupValue, provider)
                                      : containerSiteDecision(
                                          groupValue, provider)
                                ],
                              ),
                            ],
                          ),
                        )
                      ])),
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

  Widget containerDecision(String groupValue, AssessmentProvider provider) {
    switch (groupValue) {
      case '1':
        {
          // displayTotal = provider.processTotal;
          // displayTotalText = 'Process Total: ';
          // _controller.jumpTo(0);

          return selfProcessContainer(provider);
        }
        break;
      case '2':
        {
          // displayTotal = provider.resultTotal;
          // displayTotalText = 'Result Total: ';
          // _controller.jumpTo(0);

          return selfResultContainer(provider);
        }
        break;
      case '3':
        {
          // displayTotal = provider.fireTotal;
          // displayTotalText = 'Fire Total: ';
          // _controller.jumpTo(0);

          return selfFireContainer(provider);
        }
        break;
      default:
        {
          // displayTotal = provider.officeTotal;
          // displayTotalText = 'Office Total: ';
          // _controller.jumpTo(0);

          return selfOfficeContainer(provider);
        }
        break;
    }
  }

  Widget containerSiteDecision(String groupValue, AssessmentProvider provider) {
    switch (groupValue) {
      case '1':
        {
          displayTotal = provider.processTotal;
          displayTotalText = 'Process Total: ';
          // _controller.jumpTo(0);

          return siteProcessContainer(provider);
        }
        break;
      case '2':
        {
          displayTotal = provider.resultTotal;
          displayTotalText = 'Result Total: ';
          //_controller.jumpTo(0);

          return siteResultContainer(provider);
        }
        break;
      case '3':
        {
          _controller.jumpTo(0);
          return siteRiskProfileContainer(provider);
        }
        break;
      case '4':
        {
          displayTotal = provider.fireTotal;
          displayTotalText = 'Fire Total: ';
          // _controller.jumpTo(0);

          return siteFireContainer(provider);
        }
        break;
      case '5':
        {
          _controller.jumpTo(0);
          return fireSafetyManagementProfileContainer(provider);
        }
        break;
      case '6':
        {
          displayTotal = provider.officeTotal;
          displayTotalText = 'Office Total: ';
          // _controller.jumpTo(0);

          return siteOfficeContainer(provider, widget.documentId);
        }
        break;
      case '7':
        {
          _controller.jumpTo(0);
          return officeSafetyProfileContainer(provider);
        }
        break;
      default:
        {
          _controller.jumpTo(0);
          return summaryOfRiskProfileContainer(provider);
        }
        break;
    }
  }

  Widget selfProcessContainer(AssessmentProvider provider) {
    setState(() {
      displayTotal = provider.processTotal;
      displayTotalText = 'Process Total: ';
    });
    return Container(
        width: MediaQuery.of(context).size.width * 0.95,
        child: Column(
          children: [
            SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                      child: Text(
                        'Statement',
                        style: TextStyle(color: Colors.grey[600]),
                      )),
                  Container(
                      padding: EdgeInsets.fromLTRB(180, 10, 10, 10),
                      child: Text(
                        'Level',
                        style: TextStyle(color: Colors.grey[600]),
                      )),
                  Container(
                      padding: EdgeInsets.fromLTRB(110, 10, 10, 10),
                      child: Text(
                        'Justification',
                        style: TextStyle(color: Colors.grey[600]),
                      )),
                  Container(
                      padding: EdgeInsets.fromLTRB(370, 10, 10, 10),
                      child: Text(
                        'View File',
                        style: TextStyle(color: Colors.grey[600]),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .8,
              child: DraggableScrollbar.rrect(
                alwaysVisibleScrollThumb: true,
                backgroundColor: utilities.mainColor,
                controller: _controller,
                child: ListView.builder(
                  controller: _controller,
                  itemCount: provider.listOfStatement.length,
                  itemBuilder: (context, index) {
                    return (index < 25)
                        ? Card(
                            elevation: 5.0,
                            margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        child: SizedBox(
                                          width: 180,
                                          child: Text(
                                            provider.listOfStatement[index]
                                                ['statement'],
                                            style: TextStyle(
                                              color: Colors.red[700],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          SizedBox(width: 70),
                                          SizedBox(
                                            width: 50,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                provider.listOfAssessment[index]
                                                    ['level'],
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 105),
                                          SizedBox(
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.25,
                                                child: Text(
                                                  provider.listOfAssessment[
                                                      index]['comment'],
                                                  // trimLines: 3,
                                                  // colorClickableText:
                                                  //     utilities.mainColor,
                                                  // trimMode: TrimMode.Line,
                                                  // trimCollapsedText:
                                                  //     '...Show more',
                                                  // trimExpandedText:
                                                  //     ' show less',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 70),
                                          SizedBox(
                                            width: 100,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.15,
                                                  child:
                                                      provider.listOfAssessment[
                                                                      index]
                                                                  ['fileUrl'] !=
                                                              null
                                                          ? RaisedButton(
                                                              onPressed: () {
                                                                launchURL(provider
                                                                            .listOfAssessment[
                                                                        index][
                                                                    'fileUrl']);
                                                              },
                                                              child: Text(
                                                                  'View File'),
                                                            )
                                                          : Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Nil',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              ],
                                                            )),
                                            ),
                                          ),
                                        ]),
                                      ],
                                    )
                                  ]),
                            ))
                        : SizedBox();
                  },
                ),
              ),
            )
          ],
        ));
  }

  Widget selfResultContainer(AssessmentProvider provider) {
    setState(() {});
    return Container(
        width: MediaQuery.of(context).size.width * 0.95,
        child: Column(
          children: [
            SingleChildScrollView(
              child: Row(
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                      child: Text(
                        'Statement',
                        style: TextStyle(color: Colors.grey[600]),
                      )),
                  Container(
                      padding: EdgeInsets.fromLTRB(200, 10, 10, 10),
                      child: Text(
                        'Level',
                        style: TextStyle(color: Colors.grey[600]),
                      )),
                  Container(
                      padding: EdgeInsets.fromLTRB(110, 10, 10, 10),
                      child: Text(
                        'Justification',
                        style: TextStyle(color: Colors.grey[600]),
                      )),
                  Container(
                      padding: EdgeInsets.fromLTRB(370, 10, 10, 10),
                      child: Text(
                        'View File',
                        style: TextStyle(color: Colors.grey[600]),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .65,
              child: DraggableScrollbar.rrect(
                alwaysVisibleScrollThumb: true,
                backgroundColor: utilities.mainColor,
                controller: _controller,
                child: ListView.builder(
                  controller: _controller,
                  itemCount: provider.listOfStatement.length,
                  itemBuilder: (context, index) {
                    return (index > 24)
                        ? Card(
                            elevation: 5.0,
                            margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        child: SizedBox(
                                          width: 200,
                                          child: Text(
                                            provider.listOfStatement[index]
                                                ['statement'],
                                            style: TextStyle(
                                              color: Colors.red[700],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          SizedBox(width: 70),
                                          SizedBox(
                                            width: 50,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                provider.listOfAssessment[index]
                                                    ['level'],
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 105),
                                          SizedBox(
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.25,
                                                child: Text(
                                                  provider.listOfAssessment[
                                                      index]['comment'],
                                                  // trimLines: 3,
                                                  // colorClickableText:
                                                  //     utilities.mainColor,
                                                  // trimMode: TrimMode.Line,
                                                  // trimCollapsedText:
                                                  //     '...Show more',
                                                  // trimExpandedText:
                                                  //     ' show less',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 70),
                                          SizedBox(
                                            width: 100,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.15,
                                                  child:
                                                      provider.listOfAssessment[
                                                                      index]
                                                                  ['fileUrl'] !=
                                                              null
                                                          ? RaisedButton(
                                                              onPressed: () {
                                                                launchURL(provider
                                                                            .listOfAssessment[
                                                                        index][
                                                                    'fileUrl']);
                                                              },
                                                              child: Text(
                                                                  'View File'),
                                                            )
                                                          : Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Nil',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              ],
                                                            )),
                                            ),
                                          ),
                                        ]),
                                      ],
                                    )
                                  ]),
                            ))
                        : SizedBox();
                  },
                ),
              ),
            )
          ],
        ));
  }

  Widget selfFireContainer(AssessmentProvider provider) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.95,
        child: Column(
          children: [
            Card(
              elevation: 5.0,
              margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Text('View Supporting Documents')),
                    ],
                  ),
                  SizedBox(
                    width: 700,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: (provider.listOfFireAssessment[0]['fileUrl'] !=
                                null)
                            ? RaisedButton(
                                onPressed: () {
                                  launchURL(provider.listOfFireAssessment[0]
                                      ['fileUrl']);
                                },
                                child: Text('View'),
                              )
                            : Text('Not Uploaded'),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              child: Row(
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                      child: Text(
                        'Statement',
                        style: TextStyle(color: Colors.grey[600]),
                      )),
                  Container(
                      padding: EdgeInsets.fromLTRB(290, 10, 10, 10),
                      child: Text(
                        'Response',
                        style: TextStyle(color: Colors.grey[600]),
                      )),
                  Container(
                      padding: EdgeInsets.fromLTRB(250, 10, 10, 10),
                      child: Text(
                        'Justification',
                        style: TextStyle(color: Colors.grey[600]),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .55,
              child: DraggableScrollbar.rrect(
                alwaysVisibleScrollThumb: true,
                backgroundColor: utilities.mainColor,
                controller: _controller,
                child: ListView.builder(
                  controller: _controller,
                  itemCount: provider.listOfStatementFire.length,
                  itemBuilder: (context, index) {
                    return (index < 25)
                        ? Card(
                            elevation: 5.0,
                            margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        child: SizedBox(
                                          width: 300,
                                          child: Text(
                                            provider.listOfStatementFire[index]
                                                ['statement'],
                                            style: TextStyle(
                                              color: Colors.red[700],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          SizedBox(width: 70),
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              (provider.listOfFireAssessment[
                                                              index + 1]
                                                          ['answer'] ==
                                                      'no')
                                                  ? 'No'
                                                  : (provider.listOfFireAssessment[
                                                                  index + 1]
                                                              ['answer'] ==
                                                          'yes')
                                                      ? 'Yes'
                                                      : 'Partially Completed',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 105),
                                          SizedBox(
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.25,
                                                child: Text(
                                                  provider.listOfFireAssessment[
                                                      index + 1]['comment'],
                                                  // trimLines: 3,
                                                  // colorClickableText:
                                                  //     utilities.mainColor,
                                                  // trimMode: TrimMode.Line,
                                                  // trimCollapsedText:
                                                  //     '...Show more',
                                                  // trimExpandedText:
                                                  //     ' show less',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ],
                                    )
                                  ]),
                            ))
                        : SizedBox();
                  },
                ),
              ),
            )
          ],
        ));
  }

  Widget selfOfficeContainer(AssessmentProvider provider) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.95,
        child: Column(
          children: [
            SingleChildScrollView(
              child: Row(
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                      child: Text(
                        'Statement',
                        style: TextStyle(color: Colors.grey[600]),
                      )),
                  Container(
                      padding: EdgeInsets.fromLTRB(600, 10, 10, 10),
                      child: Text(
                        'Response',
                        style: TextStyle(color: Colors.grey[600]),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .65,
              child: DraggableScrollbar.rrect(
                alwaysVisibleScrollThumb: true,
                backgroundColor: utilities.mainColor,
                controller: _controller,
                child: ListView.builder(
                  controller: _controller,
                  itemCount: provider.listOfStatementOffice.length,
                  itemBuilder: (context, index) {
                    return (true)
                        ? Card(
                            elevation: 5.0,
                            margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 10, 10, 10),
                                      child: SizedBox(
                                        width: 540,
                                        child: Text(
                                          provider.listOfStatementOffice[index]
                                              ['statement'],
                                          style: TextStyle(
                                            color: utilities.mainColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        SizedBox(width: 120),
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            (provider.listOfOfficeAssessment[
                                                        index]['answer'] ==
                                                    'no')
                                                ? 'No'
                                                : (provider.listOfOfficeAssessment[
                                                            index]['answer'] ==
                                                        'yes')
                                                    ? 'Yes'
                                                    : 'Partially Complete',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ],
                                  )
                                ]))
                        : SizedBox();
                  },
                ),
              ),
            )
          ],
        ));
  }

  Widget siteProcessContainer(AssessmentProvider provider) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.95,
        child: Column(
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: SizedBox(
                  width: 200,
                  child: Text(
                    'Statement',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    SizedBox(width: 50),
                    SizedBox(
                      width: 50,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'level',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    SizedBox(
                      width: 70,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Marks',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    SizedBox(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: Text(
                            'Observations',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    SizedBox(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: Text(
                            'Suggestions',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    SizedBox(
                      width: 100,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: Text(
                              'View File',
                              style: TextStyle(color: Colors.grey[600]),
                            )),
                      ),
                    ),
                    SizedBox(width: 20),
                   widget.role=='coAssessor'? SizedBox(
                      child: Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: Text(
                            'Comments',
                            style: TextStyle(color: Colors.grey[600]),
                          )),
                    ):SizedBox(),
                  ]),
                ],
              )
            ]),
            SizedBox(
              height: MediaQuery.of(context).size.height * .65,
              child: DraggableScrollbar.rrect(
                alwaysVisibleScrollThumb: true,
                backgroundColor: utilities.mainColor,
                controller: _controller,
                child: ListView.builder(
                  controller: _controller,
                  itemCount: provider.listOfStatement.length,
                  itemBuilder: (context, index) {
                    return (index < 25)
                        ? Card(
                            elevation: 5.0,
                            margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 10, 10, 10),
                                      child: SizedBox(
                                        width: 200,
                                        child: Text(
                                          provider.listOfStatement[index]
                                              ['statement'],
                                          style: TextStyle(
                                            color: Colors.red[700],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          SizedBox(width: 50),
                                          SizedBox(
                                            width: 50,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                provider.listOfAssessment[index]
                                                    ['level'],
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 30),
                                          SizedBox(
                                            width: 50,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                provider.listOfAssessment[index]
                                                        ['answer']
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 30),
                                          SizedBox(
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                                child: Text(
                                                  provider.listOfAssessment[
                                                      index]['comment'],
                                                  // trimLines: 3,
                                                  // colorClickableText:
                                                  //     Colors.red,
                                                  // trimMode: TrimMode.Line,
                                                  // trimCollapsedText:
                                                  //     '...Show more',
                                                  // trimExpandedText:
                                                  //     ' show less',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 30),
                                          SizedBox(
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                                child: Text(
                                                  provider.listOfAssessment[
                                                      index]['suggestion'],
                                                  // trimLines: 3,
                                                  // colorClickableText:
                                                  //     Colors.red,
                                                  // trimMode: TrimMode.Line,
                                                  // trimCollapsedText:
                                                  //     '...Show more',
                                                  // trimExpandedText:
                                                  //     ' show less',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          SizedBox(
                                            width: 100,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                  child:
                                                      provider.listOfAssessment[
                                                                      index]
                                                                  ['fileUrl'] !=
                                                              null
                                                          ? RaisedButton(
                                                              onPressed: () {
                                                                launchURL(provider
                                                                            .listOfAssessment[
                                                                        index][
                                                                    'fileUrl']);
                                                              },
                                                              child: Text(
                                                                  'View File'),
                                                            )
                                                          : Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Nil',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              ],
                                                            )),
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                         widget.role=='coAssessor'? SizedBox(
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15,
                                              child: TextFormField(
                                                initialValue: provider
                                                    .listOfAssessment[index]
                                                        ['coComment']
                                                    .toString(),
                                                minLines: 1,
                                                maxLines: null,
                                                keyboardType:
                                                    TextInputType.multiline,
                                                onChanged: (value) {
                                                  provider.listOfAssessment[
                                                          index]['coComment'] =
                                                      value;
                                                },
                                              ),
                                            ),
                                          ):SizedBox()
                                        ]),
                                      ],
                                    )
                                  ]),
                            ))
                        : SizedBox();
                  },
                ),
              ),
            )
          ],
        ));
  }

  Widget siteResultContainer(AssessmentProvider provider) {
    setState(() {});
    return Container(
        width: MediaQuery.of(context).size.width * 0.95,
        child: Column(
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: SizedBox(
                  width: 200,
                  child: Text(
                    'Statement',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    SizedBox(width: 50),
                    SizedBox(
                      width: 50,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'level',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    SizedBox(
                      width: 70,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Marks',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    SizedBox(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: Text(
                            'Observations',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    SizedBox(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: Text(
                            'Suggestions',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    SizedBox(
                      width: 100,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: Text(
                              'View File',
                              style: TextStyle(color: Colors.grey[600]),
                            )),
                      ),
                    ),
                    SizedBox(width: 30),
                   widget.role=='coAssessor'? SizedBox(
                      child: Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: Text(
                            'Comments',
                            style: TextStyle(color: Colors.grey[600]),
                          )),
                    ):SizedBox(),
                  ]),
                ],
              )
            ]),
            SizedBox(
              height: MediaQuery.of(context).size.height * .65,
              child: DraggableScrollbar.rrect(
                backgroundColor: utilities.mainColor,
                alwaysVisibleScrollThumb: true,
                controller: _controller,
                child: ListView.builder(
                  controller: _controller,
                  itemCount: provider.listOfStatement.length,
                  itemBuilder: (context, index) {
                    return (index > 24)
                        ? Card(
                            elevation: 5.0,
                            margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 10, 10, 10),
                                      child: SizedBox(
                                        width: 200,
                                        child: Text(
                                          provider.listOfStatement[index]
                                              ['statement'],
                                          style: TextStyle(
                                            color: Colors.red[700],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          SizedBox(width: 50),
                                          SizedBox(
                                            width: 50,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                provider.listOfAssessment[index]
                                                    ['level'],
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 30),
                                          SizedBox(
                                            width: 50,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                provider.listOfAssessment[index]
                                                        ['answer']
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 30),
                                          SizedBox(
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                                child: Text(
                                                  provider.listOfAssessment[
                                                      index]['comment'],
                                                  // trimLines: 3,
                                                  // colorClickableText:
                                                  //     Colors.red,
                                                  // trimMode: TrimMode.Line,
                                                  // trimCollapsedText:
                                                  //     '...Show more',
                                                  // trimExpandedText:
                                                  //     ' show less',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 30),
                                          SizedBox(
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                                child: Text(
                                                  provider.listOfAssessment[
                                                      index]['suggestion'],
                                                  // trimLines: 3,
                                                  // colorClickableText:
                                                  //     Colors.red,
                                                  // trimMode: TrimMode.Line,
                                                  // trimCollapsedText:
                                                  //     '...Show more',
                                                  // trimExpandedText:
                                                  //     ' show less',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 30),
                                          SizedBox(
                                            width: 100,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                  child:
                                                      provider.listOfAssessment[
                                                                      index]
                                                                  ['fileUrl'] !=
                                                              null
                                                          ? RaisedButton(
                                                              onPressed: () {
                                                                launchURL(provider
                                                                            .listOfAssessment[
                                                                        index][
                                                                    'fileUrl']);
                                                              },
                                                              child: Text(
                                                                  'View File'),
                                                            )
                                                          : Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Nil',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              ],
                                                            )),
                                            ),
                                          ),
                                          SizedBox(width: 30),
                                         widget.role=='coAssessor'? SizedBox(
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15,
                                              child: TextFormField(
                                                initialValue: provider
                                                    .listOfAssessment[index]
                                                        ['coComment']
                                                    .toString(),
                                                minLines: 1,
                                                maxLines: null,
                                                keyboardType:
                                                    TextInputType.multiline,
                                                onChanged: (value) {
                                                  provider.listOfAssessment[
                                                          index]['coComment'] =
                                                      value;
                                                },
                                              ),
                                            ),
                                          ):SizedBox()
                                        ]),
                                      ],
                                    )
                                  ]),
                            ))
                        : SizedBox();
                  },
                ),
              ),
            )
          ],
        ));
  }

  Widget siteFireContainer(AssessmentProvider provider) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.95,
        child: Column(
          children: [
            Card(
              elevation: 5.0,
              margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Text('View Supporting Documents')),
                    ],
                  ),
                  SizedBox(
                    width: 700,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: (provider.listOfFireAssessment[0]['fileUrl'] !=
                                null)
                            ? RaisedButton(
                                onPressed: () {
                                  launchURL(provider.listOfFireAssessment[0]
                                      ['fileUrl']);
                                },
                                child: Text('View'),
                              )
                            : Text('Not Uploaded'),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: SizedBox(
                  width: 300,
                  child: Text(
                    'statement',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    SizedBox(width: 60),
                    SizedBox(
                      width: 70,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Marks',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ),
                    SizedBox(width: 40),
                    SizedBox(
                      width: 200,
                      child: Text(
                        'Response',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    SizedBox(width: 30),
                    SizedBox(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: Text(
                            'Observations',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    widget.role=='coAssessor'?SizedBox(
                      child: Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: Text(
                            'Comments',
                            style: TextStyle(color: Colors.grey[600]),
                          )),
                    ):SizedBox()
                  ]),
                ],
              )
            ]),
            SizedBox(
              height: MediaQuery.of(context).size.height * .55,
              child: DraggableScrollbar.rrect(
                alwaysVisibleScrollThumb: true,
                backgroundColor: utilities.mainColor,
                controller: _controller,
                child: ListView.builder(
                  controller: _controller,
                  itemCount: provider.listOfStatementFire.length,
                  itemBuilder: (context, index) {
                    return (true)
                        ? Card(
                            elevation: 5.0,
                            margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 10, 10, 10),
                                      child: SizedBox(
                                        width: 300,
                                        child: Text(
                                          provider.listOfStatementFire[index]
                                              ['statement'],
                                          style: TextStyle(
                                            color: Colors.red[700],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          SizedBox(width: 60),
                                          SizedBox(
                                            width: 70,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                provider.listOfFireAssessment[
                                                        index + 1]['marks']
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 40),
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              (provider.listOfFireAssessment[
                                                              index + 1]
                                                          ['answer'] ==
                                                      'no')
                                                  ? 'No'
                                                  : (provider.listOfFireAssessment[
                                                                  index + 1]
                                                              ['answer'] ==
                                                          'yes')
                                                      ? 'Yes'
                                                      : 'Partially Completed',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 30),
                                          SizedBox(
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                                child: Text(
                                                  provider.listOfFireAssessment[
                                                      index + 1]['comment'],
                                                  // trimLines: 3,
                                                  // colorClickableText:
                                                  //     Colors.red,
                                                  // trimMode: TrimMode.Line,
                                                  // trimCollapsedText:
                                                  //     '...Show more',
                                                  // trimExpandedText:
                                                  //     ' show less',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 30),
                                          widget.role=='coAssessor'?SizedBox(
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15,
                                              child: TextFormField(
                                                initialValue: provider
                                                    .listOfFireAssessment[
                                                        index + 1]['coComment']
                                                    .toString(),
                                                minLines: 1,
                                                maxLines: null,
                                                keyboardType:
                                                    TextInputType.multiline,
                                                onChanged: (value) {
                                                  provider.listOfFireAssessment[
                                                          index + 1]
                                                      ['coComment'] = value;
                                                },
                                              ),
                                            ),
                                          ):SizedBox()
                                        ]),
                                      ],
                                    )
                                  ]),
                            ))
                        : SizedBox();
                  },
                ),
              ),
            )
          ],
        ));
  }

  Widget siteOfficeContainer(AssessmentProvider provider, String cycleId) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.95,
        child: Column(
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: SizedBox(
                    width: 550,
                    child: Text('Statement',
                        style: TextStyle(color: Colors.grey[600])),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    SizedBox(width: 100),
                    SizedBox(
                      width: 70,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Text('Marks',
                            style: TextStyle(color: Colors.grey[600])),
                      ),
                    ),
                    SizedBox(width: 60),
                    SizedBox(
                      width: 200,
                      child: Text('Response',
                          style: TextStyle(color: Colors.grey[600])),
                    ),
                    SizedBox(width: 30),
                    widget.role=='coAssessor'?SizedBox(
                      child: Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: Text('Comments',
                              style: TextStyle(color: Colors.grey[600]))),
                    ):SizedBox()
                  ]),
                ],
              )
            ]),
            SizedBox(
              height: MediaQuery.of(context).size.height * .65,
              child: DraggableScrollbar.rrect(
                alwaysVisibleScrollThumb: true,
                backgroundColor: utilities.mainColor,
                controller: _controller,
                child: ListView.builder(
                  controller: _controller,
                  itemCount: provider.listOfStatementOffice.length,
                  itemBuilder: (context, index) {
                    return (true)
                        ? Card(
                            elevation: 5.0,
                            margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        child: SizedBox(
                                          width: 550,
                                          child: Text(
                                            provider.listOfStatementOffice[
                                                index]['statement'],
                                            style: TextStyle(
                                              color: utilities.mainColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          SizedBox(width: 100),
                                          SizedBox(
                                            width: 70,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                provider.listOfOfficeAssessment[
                                                        index]['marks']
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 60),
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              (provider.listOfOfficeAssessment[
                                                          index]['answer'] ==
                                                      'no')
                                                  ? 'No'
                                                  : (provider.listOfOfficeAssessment[
                                                                  index]
                                                              ['answer'] ==
                                                          'yes')
                                                      ? 'Yes'
                                                      : 'Partially Completed',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 30),
                                         widget.role=='coAssessor'? SizedBox(
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15,
                                              child: TextFormField(
                                                initialValue: provider
                                                    .listOfOfficeAssessment[
                                                        index]['coComment']
                                                    .toString(),
                                                minLines: 1,
                                                maxLines: null,
                                                keyboardType:
                                                    TextInputType.multiline,
                                                onChanged: (value) {
                                                  provider.listOfOfficeAssessment[
                                                          index]['coComment'] =
                                                      value;
                                                },
                                              ),
                                            ),
                                          ):SizedBox()
                                        ]),
                                      ],
                                    )
                                  ]),
                            ))
                        : SizedBox();
                  },
                ),
              ),
            ),
          ],
        ));
  }

  Widget siteRiskProfileContainer(AssessmentProvider provider) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      child: Column(
        children: [
          Text(
            'Site Risk - Based on Hazardous Processes and Chemicals',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * .7,
              child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Card(
                            elevation: 5.0,
                            margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Positive Observation Specific to Site Risk - Based on Hazardous Processes and Chemicals',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22)),
                                  SizedBox(height: 10),
                                  Text(provider.listOfSiteRiskProfile[0]
                                      ['point1']),
                                  SizedBox(height: 10),
                                  Text(provider.listOfSiteRiskProfile[0]
                                      ['point2']),
                                  SizedBox(height: 10),
                                  Text(provider.listOfSiteRiskProfile[0]
                                      ['point3']),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Card(
                            elevation: 5.0,
                            margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Major observation specific to Site Risk - Based on Hazardous Processes and Chemicals',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22)),
                                  SizedBox(height: 10),
                                  Text(provider.listOfSiteRiskProfile[1]
                                      ['point1']),
                                  SizedBox(height: 10),
                                  Text(provider.listOfSiteRiskProfile[1]
                                      ['point2']),
                                  SizedBox(height: 10),
                                  Text(provider.listOfSiteRiskProfile[1]
                                      ['point3']),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Card(
                            elevation: 5.0,
                            margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Suggestion For Improvement Specific to Site Risk - Based on Hazardous Processes and Chemicals',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22)),
                                  SizedBox(height: 10),
                                  Text(provider.listOfSiteRiskProfile[2]
                                      ['point1']),
                                  SizedBox(height: 10),
                                  Text(provider.listOfSiteRiskProfile[2]
                                      ['point2']),
                                  SizedBox(height: 10),
                                  Text(provider.listOfSiteRiskProfile[2]
                                      ['point3']),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }))
        ],
      ),
    );
  }

  Widget summaryOfRiskProfileContainer(AssessmentProvider provider) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      child: Column(
        children: [
          Text(
            'Summary Of Risk Profile',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * .7,
              child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Card(
                            elevation: 5.0,
                            margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Positive Observation',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25)),
                                  SizedBox(height: 10),
                                  Text(provider.listOfSummaryRiskProfile[0]
                                      ['point1']),
                                  SizedBox(height: 10),
                                  Text(provider.listOfSummaryRiskProfile[0]
                                      ['point2']),
                                  SizedBox(height: 10),
                                  Text(provider.listOfSummaryRiskProfile[0]
                                      ['point3']),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Card(
                            elevation: 5.0,
                            margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Major observation',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25)),
                                  SizedBox(height: 10),
                                  Text(provider.listOfSummaryRiskProfile[1]
                                      ['point1']),
                                  SizedBox(height: 10),
                                  Text(provider.listOfSummaryRiskProfile[1]
                                      ['point2']),
                                  SizedBox(height: 10),
                                  Text(provider.listOfSummaryRiskProfile[1]
                                      ['point3']),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Card(
                            elevation: 5.0,
                            margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Suggestion For Improvement',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25)),
                                  SizedBox(height: 10),
                                  Text(provider.listOfSummaryRiskProfile[2]
                                      ['point1']),
                                  SizedBox(height: 10),
                                  Text(provider.listOfSummaryRiskProfile[2]
                                      ['point2']),
                                  SizedBox(height: 10),
                                  Text(provider.listOfSummaryRiskProfile[2]
                                      ['point3']),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }))
        ],
      ),
    );
  }

  Widget officeSafetyProfileContainer(AssessmentProvider provider) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      child: Column(
        children: [
          Text(
            'Office Safety Risk Profile',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * .7,
              child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Card(
                            elevation: 5.0,
                            margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Positive Observation Specific to office Safety Risk Profile',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(provider.listOfOfficeRiskProfile[0]
                                      ['point1']),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(provider.listOfOfficeRiskProfile[0]
                                      ['point2']),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(provider.listOfOfficeRiskProfile[0]
                                      ['point3']),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Card(
                            elevation: 5.0,
                            margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Major Observation Specific to office Safety Risk Profile',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(provider.listOfOfficeRiskProfile[1]
                                      ['point1']),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(provider.listOfOfficeRiskProfile[1]
                                      ['point2']),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(provider.listOfOfficeRiskProfile[1]
                                      ['point3']),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Card(
                            elevation: 5.0,
                            margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Suggestion For Improvement Specific to Office Safety Risk Profile',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(provider.listOfOfficeRiskProfile[2]
                                      ['point1']),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(provider.listOfOfficeRiskProfile[2]
                                      ['point2']),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(provider.listOfOfficeRiskProfile[2]
                                      ['point3']),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }))
        ],
      ),
    );
  }

  Widget fireSafetyManagementProfileContainer(AssessmentProvider provider) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      child: Column(
        children: [
          Text(
            'Fire Safety Management Profile',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * .7,
              child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Card(
                            elevation: 5.0,
                            margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Positive Observation Specific to fire Safety Risk Profile',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(provider.listOfFireRiskProfile[0]
                                      ['point1']),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(provider.listOfFireRiskProfile[0]
                                      ['point2']),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(provider.listOfFireRiskProfile[0]
                                      ['point3']),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Card(
                            elevation: 5.0,
                            margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Major Observation Specific to fire Safety Risk Profile',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(provider.listOfFireRiskProfile[1]
                                      ['point1']),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(provider.listOfFireRiskProfile[1]
                                      ['point2']),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(provider.listOfFireRiskProfile[1]
                                      ['point3']),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Card(
                            elevation: 5.0,
                            margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Suggestion For Improvement Specific to fire Safety Risk Profile',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(provider.listOfFireRiskProfile[2]
                                      ['point1']),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(provider.listOfFireRiskProfile[2]
                                      ['point2']),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(provider.listOfFireRiskProfile[2]
                                      ['point3']),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }))
        ],
      ),
    );
  }
}
