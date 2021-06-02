import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mahindraCSC/assessments/siteAssessment/fireSafetyManagementProfile.dart';
import 'package:mahindraCSC/assessments/siteAssessment/officeAssessment.dart';
import 'package:mahindraCSC/assessments/siteAssessment/siteAssessmentProvider.dart';
import 'package:provider/provider.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:firebase/firebase.dart' as fb;
import 'package:url_launcher/url_launcher.dart';
import '../../utilities.dart';

class FireAssessment extends StatefulWidget {
  final List<Map<String, dynamic>> preFilledData;
  FireAssessment({Key key, this.preFilledData}) : super(key: key);
  @override
  _FireAssessmentState createState() => _FireAssessmentState();
}

class _FireAssessmentState extends State<FireAssessment> {
  
  List<int> marks = [0, 5, 10, 10, 10, 20, 10, 20, 15];
  List<Map<String, dynamic>> answers = [];
  List<TextEditingController> _textController =
      List.generate(9, (index) => TextEditingController());
  List<TextEditingController> _marksController =
      List.generate(9, (index) => TextEditingController());

  Utilities utilities = Utilities();
  ScrollController _controller = ScrollController();
  fb.UploadTask _uploadTask;
  bool docLoading = false;
  String url;

  @override
  void initState() {
    super.initState();
    answers = widget.preFilledData;
    for (int i = 0; i < answers.length; i++) {
      _textController[i].text = answers[i]['comment'];
      _marksController[i].text = answers[i]['marks'].toString();
    }
  }

  void uploadFile() {
    html.InputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      final file = files[0];
      final reader = new html.FileReader();
      reader.readAsDataUrl(file);

      reader.onLoadEnd.listen(
        (loadEndEvent) async {
          uploadToFirebase(file);
        },
      );
    });
  }

  uploadToFirebase(html.File imageFile) async {
    final filePath = 'documents/${DateTime.now()}.pdf';

    setState(() {
      _uploadTask = fb
          .storage()
          .refFromURL('gs://mahindracsc-e5468.appspot.com')
          .child(filePath)
          .put(imageFile);
    });
    setUrl(filePath);
  }

  setUrl(String filePath) async {
    await _uploadTask.future;
    Uri uri = await fb
        .storage()
        .refFromURL('gs://mahindracsc-e5468.appspot.com')
        .child(filePath)
        .getDownloadURL();

    setState(() {
      docLoading = true;
      url = uri.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final assessmentProvider = Provider.of<SiteAssessmentProvider>(context);
   
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: utilities.mainColor,
            titleSpacing: 0.0,
            actions: [
             
              FlatButton(
                child: Text('Next',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                onPressed: () async {
                  // if (int.parse(_textController[1].text) <=
                  //         marks[1] &&
                  //     int.parse(_textController[2].text) <=
                  //         marks[2] &&
                  //     int.parse(_textController[3].text) <=
                  //         marks[3] &&
                  //     int.parse(_textController[4].text) <=
                  //         marks[4] &&
                  //     int.parse(_textController[5].text) <=
                  //         marks[5] &&
                  //     int.parse(_textController[6].text) <=
                  //         marks[6] &&
                  //     int.parse(_textController[7].text) <=
                  //         marks[7] &&
                  //     int.parse(_textController[8].text) <=
                  //         marks[8]) {
                   assessmentProvider.setFireAssessment(answers, url);
                  assessmentProvider.getOfficeQuestions();
                  if (assessmentProvider.assessmentType == 'site') {
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return FireSafetyRiskProfile(
                          cycleId: assessmentProvider.cycleId,
                          fireTotal: assessmentProvider.fireTotal,
                          preFilledData: assessmentProvider.fireRiskProfile,
                        );
                      },
                    ));
                  }
                  await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return ChangeNotifierProvider.value(
                        value: assessmentProvider,
                        child: OfficeAssessment(
                            preFilledData: assessmentProvider.officeAnswers),
                      );
                    },
                  ));
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
                            'Fire Safety Assessment',
                            style: TextStyle(fontSize: 25),
                          ),
                           
                          Expanded(
                            child: DraggableScrollbar.rrect(
                              alwaysVisibleScrollThumb: true,
                              backgroundColor: utilities.mainColor,
                              controller: _controller,
                              child: ListView.builder(
                                controller: _controller,
                                itemCount:
                                    assessmentProvider.fireQuestions.length,
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
                                                          .fireQuestions[index]
                                                      ['statement'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20)),
                                              Text('(Guidance: ' +
                                                  assessmentProvider
                                                          .fireQuestions[index]
                                                      ['validation'] +
                                                  ')'),
                                              Row(
                                                children: [
                                                  Radio(
                                                      value: 'yes',
                                                      groupValue:answers[index]
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
                                                  Text('Partially Completed')
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
                                                                      .fireQuestions[
                                                                  index]
                                                              ['condition'] !=
                                                          'null')
                                                  ? Text(assessmentProvider
                                                          .fireQuestions[index]
                                                      ['condition'])
                                                  : SizedBox(),
                                              (answers[index]['answer'] !=
                                                          'no' &&
                                                      assessmentProvider
                                                                  .fireQuestions[
                                                              index]['condition'] !=
                                                          'null')
                                                  ? TextField(
                                                      controller:
                                                          _textController[
                                                              index],
                                                      minLines: 1,
                                                      maxLines: null,
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                      onChanged: (v) {
                                                        answers[index]
                                                            ['comment'] = v;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                              labelText:
                                                                  'Comment'),
                                                    )
                                                  : SizedBox(),
                                              (assessmentProvider
                                                              .assessmentType ==
                                                          'site' &&
                                                      index > 0)
                                                  ? TextFormField(
                                                      controller:
                                                          _marksController[
                                                              index],
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                      ],
                                                      validator: (value) {
                                                        if (int.parse(value) >
                                                            marks[index]) {
                                                          return 'Marks more than maximum marks';
                                                        } else {
                                                          return null;
                                                        }
                                                      },
                                                      decoration: InputDecoration(
                                                          labelText:
                                                              'Enter marks out of ${marks[index].toString()}'),
                                                      onChanged: (value) {
                                                        if (int.parse(
                                                                _marksController[
                                                                        index]
                                                                    .text) >
                                                            marks[index]) {
                                                          _marksController[
                                                                      index]
                                                                  .text =
                                                              marks[index]
                                                                  .toString();
                                                          answers[index]
                                                                  ['marks'] =
                                                              marks[index]
                                                                  .toString();
                                                        } else {
                                                          answers[index]
                                                              ['marks'] = value;
                                                        }
                                                      },
                                                    )
                                                  : SizedBox(),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          RaisedButton(
                              child: docLoading
                                  ? Text('File Uploaded')
                                  : Text('Upload Supporting Documents'),
                              onPressed: () async {
                                uploadFile();
                              }),
                          GestureDetector(
                            child: (url != null)
                                ? Text(url,
                                    style: TextStyle(
                                        color: Colors.blue[700],
                                        decoration: TextDecoration.underline))
                                : SizedBox(),
                            onTap: () async {
                              if (await canLaunch(url)) await launch(url);
                            },
                          ),
                        ],
                      )),
                ),
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
}
