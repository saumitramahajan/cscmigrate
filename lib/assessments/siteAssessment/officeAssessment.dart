import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mahindraCSC/assessments/siteAssessment/officeSafetyProfile.dart';
import 'package:mahindraCSC/assessments/siteAssessment/siteAssessmentProvider.dart';
import 'package:mahindraCSC/assessments/siteAssessment/summaryOfRiskProfile.dart';
import 'package:mahindraCSC/roles/assessee/assesseeDashboard.dart';
import 'package:mahindraCSC/roles/assessee/assesseeProvider.dart';
import 'package:mahindraCSC/roles/assessor/assessorDashboard.dart';
import 'package:provider/provider.dart';

import '../../utilities.dart';

class OfficeAssessment extends StatefulWidget {
  final List<Map<String, dynamic>> preFilledData;
  OfficeAssessment({Key key, this.preFilledData}) : super(key: key);
  @override
  _OfficeAssessmentState createState() => _OfficeAssessmentState();
}

class _OfficeAssessmentState extends State<OfficeAssessment> {
  List<Map<String, dynamic>> answers = [];
  List<TextEditingController> _textController =
      List.generate(10, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    answers = widget.preFilledData;
    for (int i = 0; i < answers.length; i++) {
      _textController[i].text = answers[i]['marks'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final assessmentProvider = Provider.of<SiteAssessmentProvider>(context);
    Utilities utilities = Utilities();
    ScrollController _controller = ScrollController();
    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              backgroundColor: utilities.mainColor,
              titleSpacing: 0.0,
              actions: [
                FlatButton(
                  child: (assessmentProvider.assessmentType == 'site')
                      ? Text('Next',
                          style: TextStyle(color: Colors.white, fontSize: 20))
                      : Text('Submit',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                  onPressed: () async {
                    // if (int.parse(_textController[1].text) <= 10 &&
                    //     int.parse(_textController[2].text) <= 10 &&
                    //     int.parse(_textController[3].text) <= 10 &&
                    //     int.parse(_textController[4].text) <= 10 &&
                    //     int.parse(_textController[5].text) <= 10 &&
                    //     int.parse(_textController[6].text) <= 10 &&
                    //     int.parse(_textController[7].text) <= 10 &&
                    //     int.parse(_textController[8].text) <= 10) {
                    await assessmentProvider.setOfficeAssessment(answers);
                    if (assessmentProvider.assessmentType == 'site') {
                      await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return OfficeSafetyRiskProfile(
                            cycleId: assessmentProvider.cycleId,
                            officeTotal: assessmentProvider.officeTotal,
                            preFilledData: assessmentProvider.officeRiskProfile,
                          );
                        },
                      ));
                      await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return SummaryOfRiskProfile(
                              cycleId: assessmentProvider.cycleId,
                              preFilledData:
                                  assessmentProvider.summaryOfRiskProfile,
                              type: assessmentProvider.assessmentType);
                        },
                      ));
                    }
                    if (assessmentProvider.assessmentType == 'site') {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => AssessorDashboard(),
                      ));
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content:
                                  new Text('Do you want to save or submit?'),
                              actions: <Widget>[
                                new FlatButton(
                                  child: new Text('Save'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: new Text('Submit'),
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('cycles')
                                        .doc(assessmentProvider.cycleId)
                                        .update({
                                      'currentStatus':
                                          'Self Assessment Uploaded'
                                    });
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(builder: (context) {
                                      return ChangeNotifierProvider<
                                          AssesseeProvider>(
                                        create: (_) => AssesseeProvider(),
                                        child: AssesseeDashboard(),
                                      );
                                    }));
                                  },
                                )
                              ],
                            );
                          });
                    }
                    // } else {
                    //   showDialog(
                    //       context: context,
                    //       builder: (BuildContext context) {
                    //         return AlertDialog(
                    //           content: new Text(
                    //               'Please enter marks less than maximum marks'),
                    //           actions: <Widget>[
                    //             new FlatButton(
                    //               child: new Text('Ok'),
                    //               onPressed: () {
                    //                 Navigator.of(context).pop();
                    //               },
                    //             )
                    //           ],
                    //         );
                    //       });
                    // }
                  },
                )
              ],
            ),
            body: assessmentProvider.loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Center(
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Column(
                        children: [
                          Text(
                            'Office Safety Assessment',
                            style: TextStyle(fontSize: 25),
                          ),
                          Expanded(
                            child: DraggableScrollbar.rrect(
                              alwaysVisibleScrollThumb: true,
                              backgroundColor: utilities.mainColor,
                              controller: _controller,
                              child: ListView.builder(
                                controller: _controller,
                                itemCount: 10,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      (index != 0)
                                          ? SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.025,
                                            )
                                          : SizedBox(),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 60,
                                            child: Container(
                                                padding: EdgeInsets.all(7),
                                                decoration: new BoxDecoration(
                                                  borderRadius: new BorderRadius
                                                          .only(
                                                      topLeft:
                                                          Radius.circular(8),
                                                      topRight:
                                                          Radius.circular(8)),
                                                  color: utilities.mainColor,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '${index + 1}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ],
                                      ),
                                      Card(
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              Text(
                                                  assessmentProvider
                                                          .officeQuestions[
                                                      index]['statement'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20)),
                                              Text(assessmentProvider
                                                      .officeQuestions[index]
                                                  ['validation']),
                                              Row(
                                                children: [
                                                  Radio(
                                                      value: 'yes',
                                                      groupValue: answers[index]
                                                          ['answer'],
                                                      onChanged: (v) {
                                                        setState(() {
                                                          answers[index]
                                                                  ['answer'] =
                                                              'yes';
                                                        });
                                                      }),
                                                  Text('Yes')
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Radio(
                                                      value: 'partial',
                                                      groupValue: answers[index]
                                                          ['answer'],
                                                      onChanged: (v) {
                                                        setState(() {
                                                          answers[index]
                                                                  ['answer'] =
                                                              'partial';
                                                        });
                                                      }),
                                                  Text('Partially Complete')
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Radio(
                                                      value: 'no',
                                                      groupValue: answers[index]
                                                          ['answer'],
                                                      onChanged: (v) {
                                                        setState(() {
                                                          answers[index]
                                                              ['answer'] = 'no';
                                                        });
                                                      }),
                                                  Text('No')
                                                ],
                                              ),
                                              (answers[index]['answer'] !=
                                                          'no' &&
                                                      assessmentProvider
                                                              .assessmentType ==
                                                          'site')
                                                  ? TextFormField(
                                                      controller:
                                                          _textController[
                                                              index],
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly
                                                      ],
                                                      decoration: InputDecoration(
                                                          labelText:
                                                              'Enter marks out of 10'),
                                                      onChanged: (value) {
                                                        answers[index]
                                                            ['marks'] = value;
                                                      },
                                                      validator: (value) {
                                                        if (int.parse(value) >
                                                            10) {
                                                          return 'Marks more than 10';
                                                        } else {
                                                          return null;
                                                        }
                                                      },
                                                      keyboardType: TextInputType
                                                          .numberWithOptions(
                                                              decimal: true),
                                                    )
                                                  : SizedBox(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
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
