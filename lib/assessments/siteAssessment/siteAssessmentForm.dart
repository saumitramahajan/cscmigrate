import 'dart:html';

//import 'package:file_picker_web/file_picker_web.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:mahindraCSC/assessments/siteAssessment/beforeSubmit.dart';
import 'package:mahindraCSC/assessments/siteAssessment/siteAssessmentProvider.dart';
import 'package:provider/provider.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:firebase/firebase.dart' as fb;
import 'package:url_launcher/url_launcher.dart';
import '../../utilities.dart';

class SiteAssessmentForm extends StatefulWidget {
  @override
  _SiteAssessmentFormState createState() => _SiteAssessmentFormState();
}

class _SiteAssessmentFormState extends State<SiteAssessmentForm> {
  TextEditingController _justificationController = TextEditingController();
  TextEditingController _suggestionController = TextEditingController();
  List<DropdownMenuItem<double>> ddlist = [];
  File file;
  String level = '1';
  double marks = 0;
  fb.UploadTask _uploadTask;
  bool docLoading = false;
  String url;

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
    Utilities utilities = Utilities();
    ScrollController _controller = ScrollController();
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: utilities.mainColor,
            titleSpacing: 0.0,
            automaticallyImplyLeading: false,
          ),
          body: assessmentProvider.loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  color: (assessmentProvider.i == 3 ||
                          assessmentProvider.i == 11 ||
                          assessmentProvider.i == 14 ||
                          assessmentProvider.i == 17)
                      ? Colors.red[100]
                      : Colors.white,
                  child: DraggableScrollbar.rrect(
                    alwaysVisibleScrollThumb: true,
                    backgroundColor: utilities.mainColor,
                    controller: _controller,
                    child: ListView.builder(
                      controller: _controller,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .15,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .7,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height * .1,
                                  ),
                                  (assessmentProvider.i < 26)
                                      ? Text(
                                          'Process Parameter: ' +
                                              assessmentProvider
                                                  .currentQuestion['statement'],
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Text(
                                          'Result Parameter: ' +
                                              assessmentProvider
                                                  .currentQuestion['statement'],
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                  (assessmentProvider.i == 3 ||
                                          assessmentProvider.i == 11 ||
                                          assessmentProvider.i == 14 ||
                                          assessmentProvider.i == 17)
                                      ? SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .025,
                                        )
                                      : SizedBox(),
                                  (assessmentProvider.i == 3 ||
                                          assessmentProvider.i == 11 ||
                                          assessmentProvider.i == 14 ||
                                          assessmentProvider.i == 17)
                                      ? Text('Identified Critical Parameter')
                                      : SizedBox(),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        .05,
                                  ),
                                  Image.network(
                                    assessmentProvider
                                        .currentQuestion['imageLink'],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        .05,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Select Level:',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  RadioListTile(
                                      title: Text('Level 1'),
                                      value: '1',
                                      groupValue: level,
                                      onChanged: (String value) {
                                        setState(() {
                                          level = value;
                                          marks = 0.0;
                                          ddlist = assessmentProvider
                                              .currentQuestion['levelMarks'][0];
                                        });
                                      }),
                                  RadioListTile(
                                      title: Text('Level 2'),
                                      value: '2',
                                      groupValue: level,
                                      onChanged: (String value) {
                                        setState(() {
                                          level = value;
                                          marks = assessmentProvider
                                                  .currentQuestion[
                                                      'levelMarksBase'][0]
                                                  .toDouble() +
                                              0.5;
                                          ddlist = assessmentProvider
                                              .currentQuestion['levelMarks'][1];
                                        });
                                      }),
                                  RadioListTile(
                                      title: Text('Level 3'),
                                      value: '3',
                                      groupValue: level,
                                      onChanged: (String value) {
                                        setState(() {
                                          level = value;
                                          marks = assessmentProvider
                                                  .currentQuestion[
                                                      'levelMarksBase'][1]
                                                  .toDouble() +
                                              0.5;
                                          print(marks.toString() + '\n\n');
                                          ddlist = assessmentProvider
                                              .currentQuestion['levelMarks'][2];
                                        });
                                      }),
                                  RadioListTile(
                                      title: Text('Level 4'),
                                      value: '4',
                                      groupValue: level,
                                      onChanged: (String value) {
                                        setState(() {
                                          level = value;
                                          marks = assessmentProvider
                                                  .currentQuestion[
                                                      'levelMarksBase'][2]
                                                  .toDouble() +
                                              0.5;
                                          ddlist = assessmentProvider
                                              .currentQuestion['levelMarks'][3];
                                        });
                                      }),
                                  RadioListTile(
                                      title: Text('Level 5'),
                                      value: '5',
                                      groupValue: level,
                                      onChanged: (String value) {
                                        setState(() {
                                          level = value;
                                          marks = assessmentProvider
                                                  .currentQuestion[
                                                      'levelMarksBase'][3]
                                                  .toDouble() +
                                              0.5;
                                        });
                                        setState(() {
                                          ddlist = assessmentProvider
                                              .currentQuestion['levelMarks'][4];
                                        });
                                      }),
                                  (assessmentProvider.assessmentType == 'site')
                                      ? SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .05,
                                        )
                                      : SizedBox(),
                                  (assessmentProvider.assessmentType == 'site')
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Select Score- ',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            DropdownButton<double>(
                                              items: (level != '1')
                                                  ? ddlist
                                                  : assessmentProvider
                                                          .currentQuestion[
                                                      'levelMarks'][0],
                                              onChanged: (value) {
                                                setState(() {
                                                  marks = value;
                                                  print(marks);
                                                });
                                              },
                                              value: marks,
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
                                  TextField(
                                    minLines: 1,
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    controller: _justificationController,
                                    decoration: InputDecoration(
                                        labelText: (assessmentProvider
                                                    .assessmentType ==
                                                'site')
                                            ? 'Observations'
                                            : 'Justification'),
                                  ),
                                  (assessmentProvider.assessmentType == 'site')
                                      ? TextField(
                                          minLines: 1,
                                          maxLines: null,
                                          keyboardType: TextInputType.multiline,
                                          controller: _suggestionController,
                                          decoration: InputDecoration(
                                              labelText:
                                                  'Suggestions for Moving to Next Level'),
                                        )
                                      : SizedBox(),
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
                                                decoration:
                                                    TextDecoration.underline))
                                        : SizedBox(),
                                    onTap: () async {
                                      if (await canLaunch(url))
                                        await launch(url);
                                    },
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      (assessmentProvider.i > 1)
                                          ? RaisedButton(
                                              child: Text('Previous'),
                                              onPressed: () {
                                                setState(() {
                                                  _controller.animateTo(0,
                                                      duration: Duration(
                                                          milliseconds: 500),
                                                      curve:
                                                          Curves.fastOutSlowIn);
                                                  Map<String, dynamic> map =
                                                      assessmentProvider
                                                          .previousPressed();

                                                  level = map['level'];

                                                  ddlist = assessmentProvider
                                                              .currentQuestion[
                                                          'levelMarks']
                                                      [(int.parse(level)) - 1];

                                                  marks =
                                                      map['value'].toDouble();

                                                  _justificationController
                                                      .text = map['comment'];
                                                  _suggestionController.text =
                                                      map['suggestion'];
                                                  url = map['fileUrl'];
                                                  if (url == null) {
                                                    docLoading = false;
                                                  } else {
                                                    docLoading = true;
                                                  }
                                                });
                                              },
                                            )
                                          : SizedBox(),
                                      (assessmentProvider.i < 33)
                                          ? RaisedButton(
                                              child: Text('Next'),
                                              onPressed: () {
                                                setState(() {
                                                  _controller.animateTo(0,
                                                      duration: Duration(
                                                          milliseconds: 500),
                                                      curve:
                                                          Curves.fastOutSlowIn);
                                                  Map<String, dynamic> map =
                                                      assessmentProvider
                                                          .setAssessment(
                                                    value: (assessmentProvider
                                                                .assessmentType ==
                                                            'site')
                                                        ? marks
                                                        : 0,
                                                    comment:
                                                        _justificationController
                                                            .text,
                                                    level: level,
                                                    suggestion:
                                                        _suggestionController
                                                            .text,
                                                    fileurl: url,
                                                  );

                                                  level = map['level'];

                                                  ddlist = assessmentProvider
                                                              .currentQuestion[
                                                          'levelMarks']
                                                      [(int.parse(level)) - 1];

                                                  marks =
                                                      map['value'].toDouble();
                                                  _justificationController
                                                      .text = map['comment'];
                                                  _suggestionController.text =
                                                      map['suggestion'];
                                                  url = map['fileUrl'];
                                                  if (url == null) {
                                                    docLoading = false;
                                                  } else {
                                                    docLoading = true;
                                                  }
                                                });
                                              })
                                          : RaisedButton(
                                              child: Text('Submit'),
                                              onPressed: () async {
                                                assessmentProvider.submited(
                                                    value: (assessmentProvider
                                                                .assessmentType ==
                                                            'site')
                                                        ? 0
                                                        : marks,
                                                    comment:
                                                        _justificationController
                                                            .text,
                                                    level: level,
                                                    suggestion:
                                                        _suggestionController
                                                            .text,
                                                    fileUrl: url);
                                                await Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                        builder: (_) {
                                                  return ChangeNotifierProvider
                                                      .value(
                                                    value: assessmentProvider,
                                                    child: BeforeSubmit(),
                                                  );
                                                }));
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )),
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
