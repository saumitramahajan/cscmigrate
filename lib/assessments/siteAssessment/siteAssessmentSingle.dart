import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:mahindraCSC/assessments/siteAssessment/siteAssessmentProvider.dart';
import 'package:provider/provider.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:firebase/firebase.dart' as fb;
import 'package:url_launcher/url_launcher.dart';
import '../../utilities.dart';

class SiteAssessmentSingleForm extends StatefulWidget {
  final double marks;
  final comment;
  final level;
  final String fileUrl;
  final suggestion;
  SiteAssessmentSingleForm(
      {Key key,
      this.marks,
      this.comment,
      this.level,
      this.fileUrl,
      this.suggestion})
      : super(key: key);

  @override
  _SiteAssessmentSingleFormState createState() =>
      _SiteAssessmentSingleFormState();
}

class _SiteAssessmentSingleFormState extends State<SiteAssessmentSingleForm> {
  String level = '';
  TextEditingController _justificationController = TextEditingController();
  TextEditingController _suggestionController = TextEditingController();
  double marks;
  String url;
  bool filled = false;

  bool docLoading = false;
   fb.UploadTask _uploadTask;

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
  void initState() {
    marks = widget.marks;
    _justificationController.text = widget.comment;
    _suggestionController.text = widget.suggestion;
    level = widget.level;
    url = widget.fileUrl;
    docLoading = (url != null);
    super.initState();
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
              actions: [
                FlatButton(
                  child: Text('Done',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  onPressed: () {
                    if (assessmentProvider.assessmentType == 'self') {
                      filled = true;
                    }
                    assessmentProvider.submited(
                      value: (assessmentProvider.assessmentType == 'site')
                          ? marks
                          : 0,
                      comment: _justificationController.text,
                      suggestion: _suggestionController.text,
                      level: level,
                      fileUrl: url,
                      filled: filled,
                    );
                    filled == true || level == 'NA'
                        ? Navigator.of(context).pop()
                        : showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: new Text('Please select a Score'),
                                actions: <Widget>[
                                  new FlatButton(
                                    child: new Text('close'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                  },
                )
              ],
            ),
            body: Container(
                child: DraggableScrollbar.rrect(
              alwaysVisibleScrollThumb: true,
              backgroundColor: utilities.mainColor,
              controller: _controller,
              child: ListView.builder(
                  controller: _controller,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Column(children: [
                      Row(children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .15,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * .7,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height * .1,
                              ),
                              Text(
                                'Statement:' +
                                    assessmentProvider
                                        .currentQuestion['statement'],
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .05,
                              ),
                              Image.network(
                                assessmentProvider.currentQuestion['imageLink'],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .05,
                              ),
                              Text('Select Level:'),
                              RadioListTile(
                                  title: Text('Level 1'),
                                  value: '1',
                                  groupValue: level,
                                  onChanged: (String value) {
                                    setState(() {
                                      level = value;
                                      marks = 0.0;
                                      filled = false;
                                    });
                                  }),
                              RadioListTile(
                                  title: Text('Level 2'),
                                  value: '2',
                                  groupValue: level,
                                  onChanged: (String value) {
                                    setState(() {
                                      level = value;
                                      filled = false;
                                      marks = assessmentProvider
                                              .currentQuestion['levelMarksBase']
                                                  [0]
                                              .toDouble() +
                                          0.5;
                                    });
                                  }),
                              RadioListTile(
                                  title: Text('Level 3'),
                                  value: '3',
                                  groupValue: level,
                                  onChanged: (String value) {
                                    setState(() {
                                      level = value;
                                      filled = false;

                                      marks = assessmentProvider
                                              .currentQuestion['levelMarksBase']
                                                  [1]
                                              .toDouble() +
                                          0.5;
                                    });
                                  }),
                              RadioListTile(
                                  title: Text('Level 4'),
                                  value: '4',
                                  groupValue: level,
                                  onChanged: (String value) {
                                    setState(() {
                                      level = value;
                                      filled = false;
                                      marks = assessmentProvider
                                              .currentQuestion['levelMarksBase']
                                                  [2]
                                              .toDouble() +
                                          0.5;
                                    });
                                  }),
                              RadioListTile(
                                  title: Text('Level 5'),
                                  value: '5',
                                  groupValue: level,
                                  onChanged: (String value) {
                                    setState(() {
                                      level = value;
                                      filled = false;
                                      marks = assessmentProvider
                                              .currentQuestion['levelMarksBase']
                                                  [3]
                                              .toDouble() +
                                          0.5;
                                    });
                                  }),
                              RadioListTile(
                                  title: Text('Not Applicable'),
                                  value: 'NA',
                                  groupValue: level,
                                  onChanged: (String value) {
                                    setState(() {
                                      level = value;
                                      filled = true;
                                      marks = 0;
                                    });
                                  }),
                              level != 'NA'
                                  ? (assessmentProvider.assessmentType ==
                                          'site')
                                      ? SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .05,
                                        )
                                      : SizedBox()
                                  : SizedBox(),
                              level != 'NA'
                                  ? (assessmentProvider.assessmentType ==
                                          'site')
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Select Score- ',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            DropdownButton<double>(
                                              items: assessmentProvider
                                                          .currentQuestion[
                                                      'levelMarks']
                                                  [(int.parse(level)) - 1],
                                              onChanged: (value) {
                                                filled = true;
                                                setState(() {
                                                  marks = value;
                                                  print(marks);
                                                });
                                              },
                                              value: marks,
                                            ),
                                          ],
                                        )
                                      : SizedBox()
                                  : SizedBox(),
                              TextField(
                                minLines: 1,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                controller: _justificationController,
                                decoration: InputDecoration(
                                    labelText: level == 'NA'
                                        ? 'Justification'
                                        : (assessmentProvider.assessmentType ==
                                                'site')
                                            ? ('Observations')
                                            : 'Justification'),
                              ),
                              level == 'NA'
                                  ? SizedBox(
                                      height: 20,
                                    )
                                  : SizedBox(),
                              level != 'NA'
                                  ? (assessmentProvider.assessmentType ==
                                          'site')
                                      ? TextField(
                                          minLines: 1,
                                          maxLines: null,
                                          keyboardType: TextInputType.multiline,
                                          controller: _suggestionController,
                                          decoration: InputDecoration(
                                              labelText:
                                                  'Suggestions for Moving to Next Level'),
                                        )
                                      : SizedBox()
                                  : SizedBox(),
                              level != 'NA'
                                  ? RaisedButton(
                                      child: docLoading
                                          ? Text('File Uploaded')
                                          : Text('Upload Supporting Documents'),
                                      onPressed: () async {
                                         uploadFile();
                                      })
                                  : SizedBox(),
                              GestureDetector(
                                child: (url != null)
                                    ? Text(url,
                                        style: TextStyle(
                                            color: Colors.blue[700],
                                            decoration:
                                                TextDecoration.underline))
                                    : SizedBox(),
                                onTap: () async {
                                  if (await canLaunch(url)) await launch(url);
                                },
                              ),
                            ],
                          ),
                        ),
                      ])
                    ]);
                  }),
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
