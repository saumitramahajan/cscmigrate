import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:mahindraCSC/roles/admin/review/levelBox.dart';

import 'package:url_launcher/url_launcher.dart';
import '../../../utilities.dart';
import 'assessmentProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:readmore/readmore.dart';
import 'package:firebase/firebase.dart' as fb;
import 'dart:html' as html;

class SelfAssessment extends StatefulWidget {
  String documentId;
  String nameofSite;
  String location;

  SelfAssessment({
    Key key,
    @required this.documentId,
    @required this.nameofSite,
    @required this.location,
  }) : super(key: key);
  @override
  _SelfAssessmentState createState() => _SelfAssessmentState();
}



class _SelfAssessmentState extends State<SelfAssessment> {
  String groupValue = '1';
  double displayTotal = 0;
  String displayTotalText = 'displayText';
  bool _value = false;
  String _valueLastAssessmentStage = '';
  String _valueProcessLevel = '';
  String _valueResultLevel = '';
  double overAllTotal = 0;
  double processTotal = 0;
  double resultTotal = 0;
  double fireTotal = 0;
  double officeTotal = 0;
  String url = '';
  Widget displayContainer = Container();
  Utilities utilities = Utilities();
  ScrollController _controller = ScrollController();
  fb.UploadTask _uploadTask;
   List<Map<String, dynamic>> listOfFireAssessment = [];
  

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _onChanged(bool value) {
    setState(() {
      _value = value;
    });
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
                Row(
                  children: [
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
                    provider.assessmentType == 'self'
                        ? (provider.dataLoading == false
                            ? Row(
                                children: [
                                  Text(
                                    'Edit',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  Switch(
                                      value: _value,
                                      activeColor: Colors.red[50],
                                      onChanged: (bool value) {
                                        _onChanged(value);
                                      }),
                                ],
                              )
                            : SizedBox())
                        : (provider.dataLoading == false &&
                                    int.parse(groupValue) == 1 ||
                                int.parse(groupValue) == 2 ||
                                int.parse(groupValue) == 4 ||
                                int.parse(groupValue) == 6
                            ? Row(
                                children: [
                                  Text(
                                    'Edit',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  Switch(
                                      value: _value,
                                      activeColor: Colors.red[50],
                                      onChanged: (bool value) {
                                        _onChanged(value);
                                      }),
                                ],
                              )
                            : SizedBox())
                  ],
                )
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
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                provider.assessmentType == 'self'
                                    ? Row(
                                        children: [
                                          SizedBox(width: 120),
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
                                    : DropdownButton(
                                        value: groupValue,
                                        items: [
                                          DropdownMenuItem(
                                            child: Text("Process Parameter"),
                                            value: '1',
                                          ),
                                          DropdownMenuItem(
                                            child: Text("Result Parameter"),
                                            value: '2',
                                          ),
                                          DropdownMenuItem(
                                            child: Text("Site Risk Profile"),
                                            value: '3',
                                          ),
                                          DropdownMenuItem(
                                            child:
                                                Text("Fire Safety Assessment"),
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
                                            child:
                                                Text("Summary Of Risk Profile"),
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
                                            } else if (groupValue == '4') {
                                              displayTotal = provider.fireTotal;
                                              displayTotalText = 'Fire Total: ';
                                              _controller.jumpTo(0);
                                            } else if (groupValue == '6') {
                                              displayTotal =
                                                  provider.officeTotal;
                                              displayTotalText =
                                                  'Office Total: ';
                                              _controller.jumpTo(0);
                                            }
                                          });
                                        }),
                                // SizedBox(
                                //   width: 40,
                                // ),
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
                                    : SizedBox(),
                                // SizedBox(width: 40),as
                                provider.assessmentType == 'site'
                                    ? RaisedButton(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Approve',
                                              style: TextStyle(fontSize: 15)),
                                        ),
                                        onPressed: () async {
                                          await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ChangeNotifierProvider
                                                    .value(
                                                  value: provider,
                                                  child: LevelBox(
                                                      documentId:
                                                          widget.documentId),
                                                );
                                              });

                                          
                                        })
                                    : SizedBox(),
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
                              _value && groupValue != '8'
                                  ? RaisedButton(
                                      child: provider.uploadLoading
                                          ? CircularProgressIndicator()
                                          : Text('Save'),
                                      onPressed: () async {
                                        provider.locations(widget.documentId);
                                        


                                        
                                        provider.assessmentType == 'self'
                                            ? provider.editSelfUploadData(
                                                widget.documentId)
                                            : provider.editSiteUploadData(
                                                widget.documentId,
                                              );
                                             
                                        setState(() {
                                          _value = false;
                                        });
                                      })
                                  : SizedBox()
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
          displayTotal = provider.processTotal;
          displayTotalText = 'Process Total: ';
          // _controller.jumpTo(0);

          return selfProcessContainer(provider);
        }
        break;
      case '2':
        {
          displayTotal = provider.resultTotal;
          displayTotalText = 'Result Total: ';
          // _controller.jumpTo(0);

          return selfResultContainer(provider);
        }
        break;
      case '3':
        {
          displayTotal = provider.fireTotal;
          displayTotalText = 'Fire Total: ';
          // _controller.jumpTo(0);

          return selfFireContainer(provider);
        }
        break;
      default:
        {
          displayTotal = provider.officeTotal;
          displayTotalText = 'Office Total: ';
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
                                              child: _value == true
                                                  ? TextFormField(
                                                      initialValue: provider
                                                          .listOfAssessment[
                                                              index]['level']
                                                          .toString(),
                                                      onChanged: (value) {
                                                        provider.listOfAssessment[
                                                                index]
                                                            ['level'] = value;
                                                      },
                                                    )
                                                  : Text(
                                                      provider.listOfAssessment[
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
                                                child: _value == true
                                                    ? TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .multiline,
                                                        minLines: 1,
                                                        maxLines: null,
                                                        initialValue: provider
                                                            .listOfAssessment[
                                                                index]
                                                                ['comment']
                                                            .toString(),
                                                        onChanged: (value) {
                                                          provider.listOfAssessment[
                                                                      index]
                                                                  ['comment'] =
                                                              value;
                                                        },
                                                      )
                                                    : Text(
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
                                              child: _value == true
                                                  ? TextFormField(
                                                      initialValue: provider
                                                          .listOfAssessment[
                                                              index]['level']
                                                          .toString(),
                                                      onChanged: (value) {
                                                        provider.listOfAssessment[
                                                                index]
                                                            ['level'] = value;
                                                      },
                                                    )
                                                  : Text(
                                                      provider.listOfAssessment[
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
                                                child: _value == true
                                                    ? TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .multiline,
                                                        minLines: 1,
                                                        maxLines: null,
                                                        initialValue: provider
                                                            .listOfAssessment[
                                                                index]
                                                                ['comment']
                                                            .toString(),
                                                        onChanged: (value) {
                                                          provider.listOfAssessment[
                                                                      index]
                                                                  ['comment'] =
                                                              value;
                                                        },
                                                      )
                                                    : Text(
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
                                            child: _value == true
                                                ? Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Radio(
                                                              value: 'yes',
                                                              groupValue: provider
                                                                  .listOfFireAssessment[
                                                                      index + 1]
                                                                      ['answer']
                                                                  .toString(),
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  provider.listOfFireAssessment[
                                                                          index +
                                                                              1]
                                                                      [
                                                                      'answer'] = value;
                                                                });
                                                              }),
                                                          Text('Yes')
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Radio(
                                                              value: 'partial',
                                                              groupValue: provider
                                                                  .listOfFireAssessment[
                                                                      index + 1]
                                                                      ['answer']
                                                                  .toString(),
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  provider.listOfFireAssessment[
                                                                          index +
                                                                              1]
                                                                      [
                                                                      'answer'] = value;
                                                                });
                                                              }),
                                                          Text(
                                                              'Partially Completed')
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Radio(
                                                              value: 'no',
                                                              groupValue: provider
                                                                  .listOfFireAssessment[
                                                                      index + 1]
                                                                      ['answer']
                                                                  .toString(),
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  provider.listOfFireAssessment[
                                                                          index +
                                                                              1]
                                                                      [
                                                                      'answer'] = value;
                                                                });
                                                              }),
                                                          Text('No')
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                : Text(
                                                    (provider.listOfFireAssessment[
                                                                    index + 1]
                                                                ['answer'] ==
                                                            'no')
                                                        ? 'No'
                                                        : (provider.listOfFireAssessment[
                                                                        index +
                                                                            1][
                                                                    'answer'] ==
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
                                                child: _value == true
                                                    ? TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .multiline,
                                                        minLines: 1,
                                                        maxLines: null,
                                                        initialValue: provider
                                                            .listOfFireAssessment[
                                                                index + 1]
                                                                ['comment']
                                                            .toString(),
                                                        onChanged: (value) {
                                                          provider.listOfFireAssessment[
                                                                      index + 1]
                                                                  ['comment'] =
                                                              value;
                                                        },
                                                      )
                                                    : Text(
                                                        provider.listOfFireAssessment[
                                                                index + 1]
                                                            ['comment'],
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(children: [
                                        SizedBox(width: 120),
                                        SizedBox(
                                          width: 200,
                                          child: _value == true
                                              ? Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Radio(
                                                            value: 'yes',
                                                            groupValue: provider
                                                                .listOfOfficeAssessment[
                                                                    index]
                                                                    ['answer']
                                                                .toString(),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                provider.listOfOfficeAssessment[
                                                                            index]
                                                                        [
                                                                        'answer'] =
                                                                    value;
                                                              });
                                                            }),
                                                        Text('Yes')
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Radio(
                                                            value: 'partial',
                                                            groupValue: provider
                                                                .listOfOfficeAssessment[
                                                                    index]
                                                                    ['answer']
                                                                .toString(),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                provider.listOfOfficeAssessment[
                                                                            index]
                                                                        [
                                                                        'answer'] =
                                                                    value;
                                                              });
                                                            }),
                                                        Text(
                                                            'Partially Completed')
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Radio(
                                                            value: 'no',
                                                            groupValue: provider
                                                                .listOfOfficeAssessment[
                                                                    index]
                                                                    ['answer']
                                                                .toString(),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                provider.listOfOfficeAssessment[
                                                                            index]
                                                                        [
                                                                        'answer'] =
                                                                    value;
                                                              });
                                                            }),
                                                        Text('No')
                                                      ],
                                                    )
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      (provider.listOfOfficeAssessment[
                                                                      index]
                                                                  ['answer'] ==
                                                              'no')
                                                          ? 'No'
                                                          : (provider.listOfOfficeAssessment[
                                                                          index]
                                                                      [
                                                                      'answer'] ==
                                                                  'yes')
                                                              ? 'Yes'
                                                              : 'Partially Complete',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: SizedBox(
                  width: 200,
                  child: Text('Statement',
                      style: TextStyle(color: Colors.grey[600])),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    SizedBox(width: 50),
                    SizedBox(
                      width: 60,
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text('Level',
                              style: TextStyle(color: Colors.grey[600]))),
                    ),
                    SizedBox(width: 30),
                    SizedBox(
                      width: 70,
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Marks',
                            style: TextStyle(color: Colors.grey[600]),
                          )),
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
                            )),
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
                            )),
                      ),
                    ),
                    SizedBox(width: 20),
                    SizedBox(
                      width: 100,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: Text(
                              'View File',
                              style: TextStyle(color: Colors.grey[600]),
                            )),
                      ),
                    ),
                    SizedBox(width: 20),
                    SizedBox(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: Text(
                            'Comment',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ),
                    ),
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
                                              child: _value == true
                                                  ? TextFormField(
                                                      initialValue: provider
                                                          .listOfAssessment[
                                                              index]['level']
                                                          .toString(),
                                                      onChanged: (value) {
                                                        provider.listOfAssessment[
                                                                index]
                                                            ['level'] = value;
                                                      },
                                                    )
                                                  : Text(
                                                      provider.listOfAssessment[
                                                          index]['level'],
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          SizedBox(width: 30),
                                          SizedBox(
                                            width: 70,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: _value == true
                                                  ? TextFormField(
                                                      initialValue: provider
                                                          .listOfAssessment[
                                                              index]['answer']
                                                          .toString(),
                                                      onChanged: (value) {
                                                         
                                        
                                                        provider.listOfAssessment[
                                                                    index]
                                                                ['answer'] =
                                                            double.parse(value);

                                                           

                                                          
                                                            
                                                       
                                                      },
                                                    )
                                                  : Text(
                                                      provider.listOfAssessment[
                                                              index]['answer']
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
                                                child: _value == true
                                                    ? TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .multiline,
                                                        minLines: 1,
                                                        maxLines: null,
                                                        initialValue: provider
                                                            .listOfAssessment[
                                                                index]
                                                                ['comment']
                                                            .toString(),
                                                        onChanged: (value) {
                                                          provider.listOfAssessment[
                                                                      index]
                                                                  ['comment'] =
                                                              value;
                                                        },
                                                      )
                                                    : Text(
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
                                                child: _value == true
                                                    ? TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .multiline,
                                                        minLines: 1,
                                                        maxLines: null,
                                                        initialValue: provider
                                                            .listOfAssessment[
                                                                index]
                                                                ['suggestion']
                                                            .toString(),
                                                        onChanged: (value) {
                                                          provider.listOfAssessment[
                                                                      index][
                                                                  'suggestion'] =
                                                              value;
                                                        },
                                                      )
                                                    : Text(
                                                        provider.listOfAssessment[
                                                                index]
                                                            ['suggestion'],
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
                                          SizedBox(width: 20),
                                          SizedBox(
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.1,
                                                child: Text(
                                                  provider.listOfAssessment[
                                                      index]['coComment'],
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
    return Container(
        width: MediaQuery.of(context).size.width * 0.95,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: SizedBox(
                  width: 200,
                  child: Text('Statement',
                      style: TextStyle(color: Colors.grey[600])),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    SizedBox(width: 70),
                    SizedBox(
                      width: 60,
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text('Level',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ))),
                    ),
                    SizedBox(width: 30),
                    SizedBox(
                      width: 70,
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text('Marks',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ))),
                    ),
                    SizedBox(width: 30),
                    SizedBox(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: Text('Observations',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ))),
                      ),
                    ),
                    SizedBox(width: 30),
                    SizedBox(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: Text('Suggestions',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ))),
                      ),
                    ),
                    SizedBox(width: 20),
                    SizedBox(
                      width: 100,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Text('View File',
                            style: TextStyle(
                              color: Colors.grey[600],
                            )),
                      ),
                    ),
                    SizedBox(width: 20),
                    SizedBox(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: Text(
                            'Comment',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    )
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
                                          SizedBox(width: 70),
                                          SizedBox(
                                            width: 60,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: _value == true
                                                  ? TextFormField(
                                                      initialValue: provider
                                                          .listOfAssessment[
                                                              index]['level']
                                                          .toString(),
                                                      onChanged: (value) {
                                                        provider.listOfAssessment[
                                                                index]
                                                            ['level'] = value;
                                                      },
                                                    )
                                                  : Text(
                                                      provider.listOfAssessment[
                                                          index]['level'],
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          SizedBox(width: 30),
                                          SizedBox(
                                            width: 70,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: _value == true
                                                  ? TextFormField(
                                                      initialValue: provider
                                                          .listOfAssessment[
                                                              index]['answer']
                                                          .toString(),
                                                      onChanged: (value) {
                                                        provider.listOfAssessment[
                                                                    index]
                                                                ['answer'] =
                                                            double.parse(value);
                                                      },
                                                    )
                                                  : Text(
                                                      provider.listOfAssessment[
                                                              index]['answer']
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
                                                child: _value == true
                                                    ? TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .multiline,
                                                        minLines: 1,
                                                        maxLines: null,
                                                        initialValue: provider
                                                            .listOfAssessment[
                                                                index]
                                                                ['comment']
                                                            .toString(),
                                                        onChanged: (value) {
                                                          provider.listOfAssessment[
                                                                      index]
                                                                  ['comment'] =
                                                              value;
                                                        },
                                                      )
                                                    : Text(
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
                                                child: _value == true
                                                    ? TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .multiline,
                                                        minLines: 1,
                                                        maxLines: null,
                                                        initialValue: provider
                                                            .listOfAssessment[
                                                                index]
                                                                ['suggestion']
                                                            .toString(),
                                                        onChanged: (value) {
                                                          provider.listOfAssessment[
                                                                      index][
                                                                  'suggestion'] =
                                                              value;
                                                        },
                                                      )
                                                    : Text(
                                                        provider.listOfAssessment[
                                                                index]
                                                            ['suggestion'],
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
                                          SizedBox(width: 20),
                                          SizedBox(
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.1,
                                                child: Text(
                                                  provider.listOfAssessment[
                                                      index]['coComment'],
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: Text('Statement',
                      style: TextStyle(color: Colors.grey[600])),
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
                          child: Text('Marks',
                              style: TextStyle(color: Colors.grey[600]))),
                    ),
                    SizedBox(width: 30),
                    SizedBox(
                        width: 200,
                        child: Text('Response',
                            style: TextStyle(color: Colors.grey[600]))),
                    SizedBox(width: 30),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: Text('Observations',
                                style: TextStyle(color: Colors.grey[600]))),
                      ),
                    ),
                    SizedBox(width: 20),
                    SizedBox(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: Text('Comments',
                              style: TextStyle(color: Colors.grey[600])),
                        ),
                      ),
                    ),
                  ]),
                ],
              )
            ]),
            SizedBox(
              height: MediaQuery.of(context).size.height * .7,
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
                                              child: _value == true
                                                  ? TextFormField(
                                                      initialValue: provider
                                                          .listOfFireAssessment[
                                                              index + 1]
                                                              ['marks']
                                                          .toString(),
                                                      onChanged: (value) {
                                                        provider.listOfFireAssessment[
                                                                    index + 1]
                                                                ['marks'] =
                                                            double.parse(value);
                                                      },
                                                    )
                                                  : Text(
                                                      provider
                                                          .listOfFireAssessment[
                                                              index + 1]
                                                              ['marks']
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          SizedBox(width: 30),
                                          SizedBox(
                                            width: 200,
                                            child: _value == true
                                                ? Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Radio(
                                                              value: 'yes',
                                                              groupValue: provider
                                                                  .listOfFireAssessment[
                                                                      index + 1]
                                                                      ['answer']
                                                                  .toString(),
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  provider.listOfFireAssessment[
                                                                          index +
                                                                              1]
                                                                      [
                                                                      'answer'] = value;
                                                                });
                                                              }),
                                                          Text('Yes')
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Radio(
                                                              value: 'partial',
                                                              groupValue: provider
                                                                  .listOfFireAssessment[
                                                                      index + 1]
                                                                      ['answer']
                                                                  .toString(),
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  provider.listOfFireAssessment[
                                                                          index +
                                                                              1]
                                                                      [
                                                                      'answer'] = value;
                                                                });
                                                              }),
                                                          Text(
                                                              'Partially Completed')
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Radio(
                                                              value: 'no',
                                                              groupValue: provider
                                                                  .listOfFireAssessment[
                                                                      index + 1]
                                                                      ['answer']
                                                                  .toString(),
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  provider.listOfFireAssessment[
                                                                          index +
                                                                              1]
                                                                      [
                                                                      'answer'] = value;
                                                                });
                                                              }),
                                                          Text('No')
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                : Text(
                                                    (provider.listOfFireAssessment[
                                                                    index + 1]
                                                                ['answer'] ==
                                                            'no')
                                                        ? 'No'
                                                        : (provider.listOfFireAssessment[
                                                                        index +
                                                                            1][
                                                                    'answer'] ==
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.25,
                                                child: _value == true
                                                    ? TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .multiline,
                                                        minLines: 1,
                                                        maxLines: null,
                                                        initialValue: provider
                                                            .listOfFireAssessment[
                                                                index]
                                                                ['comment']
                                                            .toString(),
                                                        onChanged: (value) {
                                                          provider.listOfFireAssessment[
                                                                      index]
                                                                  ['comment'] =
                                                              value;
                                                        },
                                                      )
                                                    : Text(
                                                        provider.listOfFireAssessment[
                                                                index + 1]
                                                            ['comment'],
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
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                                child: Text(
                                                  provider.listOfFireAssessment[
                                                      index]['coComment'],
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                              style: TextStyle(color: Colors.grey[600]))),
                    ),
                    SizedBox(width: 30),
                    SizedBox(
                        width: 200,
                        child: Text('Response',
                            style: TextStyle(color: Colors.grey[600]))),
                    SizedBox(width: 20),
                    SizedBox(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: Text(
                              'Comment',
                              style: TextStyle(color: Colors.grey[600]),
                            )),
                      ),
                    ),
                  ]),
                ],
              )
            ]),
            SizedBox(
              height: MediaQuery.of(context).size.height * .8,
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
                                              child: _value == true
                                                  ? TextFormField(
                                                      initialValue: provider
                                                          .listOfOfficeAssessment[
                                                              index]['marks']
                                                          .toString(),
                                                      onChanged: (value) {
                                                        provider.listOfOfficeAssessment[
                                                                    index]
                                                                ['marks'] =
                                                            double.parse(value);
                                                      },
                                                    )
                                                  : Text(
                                                      provider
                                                          .listOfOfficeAssessment[
                                                              index]['marks']
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          SizedBox(width: 30),
                                          SizedBox(
                                            width: 200,
                                            child: _value == true
                                                ? Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Radio(
                                                              value: 'yes',
                                                              groupValue: provider
                                                                  .listOfOfficeAssessment[
                                                                      index]
                                                                      ['answer']
                                                                  .toString(),
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  provider.listOfOfficeAssessment[
                                                                          index]
                                                                      [
                                                                      'answer'] = value;
                                                                });
                                                              }),
                                                          Text('Yes')
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Radio(
                                                              value: 'partial',
                                                              groupValue: provider
                                                                  .listOfOfficeAssessment[
                                                                      index]
                                                                      ['answer']
                                                                  .toString(),
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  provider.listOfOfficeAssessment[
                                                                          index]
                                                                      [
                                                                      'answer'] = value;
                                                                });
                                                              }),
                                                          Text(
                                                              'Partially Completed')
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Radio(
                                                              value: 'no',
                                                              groupValue: provider
                                                                  .listOfOfficeAssessment[
                                                                      index]
                                                                      ['answer']
                                                                  .toString(),
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  provider.listOfOfficeAssessment[
                                                                          index]
                                                                      [
                                                                      'answer'] = value;
                                                                });
                                                              }),
                                                          Text('No')
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                : Text(
                                                    (provider.listOfOfficeAssessment[
                                                                    index]
                                                                ['answer'] ==
                                                            'no')
                                                        ? 'No'
                                                        : (provider.listOfOfficeAssessment[
                                                                        index][
                                                                    'answer'] ==
                                                                'yes')
                                                            ? 'Yes'
                                                            : 'Partially Completed',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                          ),
                                          SizedBox(width: 20),
                                          SizedBox(
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                                child: Text(
                                                  provider.listOfOfficeAssessment[
                                                      index]['coComment'],
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
