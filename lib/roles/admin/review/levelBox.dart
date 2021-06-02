import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'dart:html' as html;

import 'package:mahindraCSC/roles/admin/dashboard/adminDashboard.dart';
import 'package:mahindraCSC/roles/admin/review/assessmentProvider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LevelBox extends StatefulWidget {
  String documentId;
  LevelBox({
    Key key,
    @required this.documentId,
  }) : super(key: key);

  @override
  _LevelBoxState createState() => _LevelBoxState();
}

class _LevelBoxState extends State<LevelBox> {
  fb.UploadTask _uploadTask;
  String url;
  String _valueLastAssessmentStage = '';
  String _valueProcessLevel = '';
  String _valueResultLevel = '';

  TextEditingController point1 = TextEditingController();
  TextEditingController point2 = TextEditingController();
  TextEditingController point3 = TextEditingController();
  TextEditingController point4 = TextEditingController();
  TextEditingController point5 = TextEditingController();
  TextEditingController wayForward1 = TextEditingController();
  TextEditingController wayForward2 = TextEditingController();

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
          .refFromURL('gs:mahindracsc-e5468.appspot.com')
          .child(filePath)
          .put(imageFile);
    });
    setUrl(filePath);
  }

  setUrl(String filePath) async {
    await _uploadTask.future;
    Uri uri = await fb
        .storage()
        .refFromURL('gs:mahindracsc-e5468.appspot.com')
        .child(filePath)
        .getDownloadURL();

    setState(() {
      url = uri.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssessmentProvider>(context);
    return AlertDialog(
      title: new Text('Levels'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(
          children: [
            Text('Last Assessment Stage: '),
            DropdownButton<String>(
              items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((int value) {
                return new DropdownMenuItem<String>(
                  value: value.toString(),
                  child: new Text(value.toString()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _valueLastAssessmentStage = value;
                });
              },
              hint: Text('Rate from 1-10'),
              value: _valueLastAssessmentStage,
            )
          ],
        ),
        Row(
          children: [
            Text('Process Level: '),
            DropdownButton<String>(
              items: <int>[1, 2, 3, 4, 5].map((int value) {
                return new DropdownMenuItem<String>(
                  value: value.toString(),
                  child: new Text(value.toString()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _valueProcessLevel = value;
                });
              },
              hint: Text('Rate from 1-5'),
              value: _valueProcessLevel,
            )
          ],
        ),
        Row(
          children: [
            Text('Result Level: '),
            DropdownButton<String>(
              items: <int>[1, 2, 3, 4, 5].map((int value) {
                return new DropdownMenuItem<String>(
                  value: value.toString(),
                  child: new Text(value.toString()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _valueResultLevel = value;
                });
              },
              hint: Text('Rate from 1-5'),
              value: _valueResultLevel,
            )
          ],
        ),
        Row(
          children: [
            Text('Heat Map: '),
            RaisedButton(
                padding: EdgeInsets.all(10),
                child: Text('Upload'),
                onPressed: () {
                  uploadFile();
                }),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: GestureDetector(
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
        ),
      ]),
      actions: <Widget>[
        new FlatButton(
          child: new Text('Approve'),
          onPressed: () async {
             Navigator.of(context).pop();
            await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: Text(
                        'Top 5 Risks Identified of the site',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: SingleChildScrollView(
                        child: Column(children: [
                          TextField(
                            minLines: 1,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            controller: point1,
                            decoration: InputDecoration(labelText: '1.'),
                          ),
                          TextField(
                            minLines: 1,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            controller: point2,
                            decoration: InputDecoration(labelText: '2.'),
                          ),
                          TextField(
                            minLines: 1,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            controller: point3,
                            decoration: InputDecoration(labelText: '3.'),
                          ),
                          TextField(
                            minLines: 1,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            controller: point4,
                            decoration: InputDecoration(labelText: '4.'),
                          ),
                          TextField(
                            minLines: 1,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            controller: point5,
                            decoration: InputDecoration(labelText: '5.'),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Way Forward',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          TextField(
                            minLines: 1,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            controller: wayForward1,
                            decoration: InputDecoration(labelText: '1.'),
                          ),
                          TextField(
                            minLines: 1,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            controller: wayForward2,
                            decoration: InputDecoration(labelText: '2.'),
                          ),
                        ]),
                      ),
                      actions: <Widget>[
                        new FlatButton(
                            child: new Text(
                              'ok',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();

                              await provider.upload(
                                  point1.text,
                                  point2.text,
                                  point3.text,
                                  point4.text,
                                  point5.text,
                                  wayForward1.text,
                                  wayForward2.text,
                                  widget.documentId);

                              await provider.approve(
                                  widget.documentId,
                                  _valueLastAssessmentStage,
                                  _valueProcessLevel,
                                  _valueResultLevel,
                                  url);
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => AdminDashboard(),
                              ));
                            })
                      ]);
                });
          },
        )
      ],
    );
  }
}
