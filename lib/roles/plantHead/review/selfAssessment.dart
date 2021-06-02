import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:mahindraCSC/roles/plantHead/plantHeadDashboard.dart';

import 'package:mahindraCSC/roles/plantHead/review/plantHeadAssessmentProvider.dart';
import 'package:mahindraCSC/utilities.dart';
import 'package:provider/provider.dart';
//import 'package:readmore/readmore.dart';

import 'package:url_launcher/url_launcher.dart';

class PlantHeadAssessment extends StatefulWidget {
  @override
  _PlantHeadAssessmentState createState() => _PlantHeadAssessmentState();
}

class _PlantHeadAssessmentState extends State<PlantHeadAssessment> {
  String groupValue = '1';
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
    final provider = Provider.of<PlantProvider>(context);

    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              backgroundColor: utilities.mainColor,
              titleSpacing: 0.0,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  SizedBox(width: 300),
                  provider.dataExists
                      ? Text(
                          "Self Assessment: " +
                              provider.name +
                              ',' +
                              provider.location,
                          style: TextStyle(fontSize: 25),
                        )
                      : SizedBox()
                ],
              ),
              actions: [
                !provider.loading && provider.dataExists
                    ? Row(children: [
                        FlatButton(
                            child: Text('Approve',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
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
                                            await provider.approveAssessment();
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                              builder: (context) =>
                                                  PlantHeadDashboard(),
                                            ));
                                          },
                                        )
                                      ],
                                    );
                                  });
                            })
                      ])
                    : SizedBox()
              ],
            ),
            body: (provider.loading)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : 
                provider.dataExists
                    ? 
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
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
                                                child: Text('Result Parameter'),
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
                                  ]),
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      containerDecision(groupValue, provider)
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ])
                    : Center(
                        child: Container(
                          child: Text(
                            'Self Assessment is yet to be Uploaded.\nPlease try after Self Assessment uploaded for your plant.',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                      ),
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

  Widget containerDecision(String groupValue, PlantProvider provider) {
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

  Widget selfProcessContainer(PlantProvider provider) {
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
                                                provider.selfAssessmentList[
                                                    index]['level'],
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
                                                  provider.selfAssessmentList[
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
                                                      provider.selfAssessmentList[
                                                                      index]
                                                                  ['fileUrl'] !=
                                                              null
                                                          ? RaisedButton(
                                                              onPressed: () {
                                                                launchURL(provider
                                                                            .selfAssessmentList[
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

  Widget selfResultContainer(PlantProvider provider) {
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
                                                provider.selfAssessmentList[
                                                    index]['level'],
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
                                                  provider.selfAssessmentList[
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
                                                      provider.selfAssessmentList[
                                                                      index]
                                                                  ['fileUrl'] !=
                                                              null
                                                          ? RaisedButton(
                                                              onPressed: () {
                                                                launchURL(provider
                                                                            .selfAssessmentList[
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

  Widget selfFireContainer(PlantProvider provider) {
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
                        child: (provider.selfAssessmentFireList[0]['fileUrl'] !=
                                null)
                            ? RaisedButton(
                                onPressed: () {
                                  launchURL(provider.selfAssessmentFireList[0]
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
                                              (provider.selfAssessmentFireList[
                                                              index + 1]
                                                          ['answer'] ==
                                                      'no')
                                                  ? 'No'
                                                  : (provider.selfAssessmentFireList[
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
                                                  provider.selfAssessmentFireList[
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

  Widget selfOfficeContainer(PlantProvider provider) {
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
                                            (provider.selfAssessmentOfficeList[
                                                        index]['answer'] ==
                                                    'no')
                                                ? 'No'
                                                : (provider.selfAssessmentOfficeList[
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
}
