import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:firebase/firebase.dart' as fb;
import 'package:mahindraCSC/roles/assessee/assesseeClosedProvider.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Dialogue extends StatefulWidget {
  @override
  _DialogueState createState() => _DialogueState();
}

class _DialogueState extends State<Dialogue> {
  String url;
  bool docLoading = false;
  bool docUploading = false;

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  fb.UploadTask _uploadTask;

  void uploadFile(AssesseeClosedProvider provider) {
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
          uploadToFirebase(file, provider);
        },
      );
    });
  }

  uploadToFirebase(html.File imageFile, AssesseeClosedProvider provider) async {
    final filePath = 'documents/${DateTime.now()}.pdf';

    setState(() {
      docUploading = true;
    });

    setState(() {
      _uploadTask = fb
          .storage()
          .refFromURL('gs://mahindracsc-e5468.appspot.com')
          .child(filePath)
          .put(imageFile);
    });
    setUrl(filePath, provider);
  }

  setUrl(String filePath, AssesseeClosedProvider provider) async {
    await _uploadTask.future;
    Uri uri = await fb
        .storage()
        .refFromURL('gs://mahindracsc-e5468.appspot.com')
        .child(filePath)
        .getDownloadURL();

    setState(() {
      docLoading = true;
      url = uri.toString();
      provider.listOfAssessment[provider.selectedIndex]['upload'] =
          url.toString();
      docUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssesseeClosedProvider>(context);

    return AlertDialog(
        title: Text(
          'Comment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              child: Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width * 0.15,
                child: TextFormField(
                  initialValue: provider
                      .listOfAssessment[provider.selectedIndex]
                          ['closedAssessment']
                      .toString(),
                  minLines: 1,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  onChanged: (value) {
                    provider.listOfAssessment[provider.selectedIndex]
                        ['closedAssessment'] = value;
                  },
                ),
              ),
            ),
            SizedBox(
                width: 250,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      // ignore: deprecated_member_use
                      RaisedButton(
                        onPressed: () async {
                          uploadFile(provider);
                        },
                        child: docLoading
                            ? Text("File Uploaded")
                            : Text('Upload Supporting Evidence'),
                      ),
                      (provider.listOfAssessment[provider.selectedIndex]
                                  ['upload'] !=
                              null)
                          ? GestureDetector(
                              child: Text(
                                  provider.listOfAssessment[
                                      provider.selectedIndex]['upload'],
                                  style: TextStyle(
                                      color: Colors.blue[700],
                                      decoration: TextDecoration.underline)),
                              onTap: () async {
                                if (await canLaunch(provider.listOfAssessment[
                                    provider.selectedIndex]['upload']))
                                  await launch(provider.listOfAssessment[
                                      provider.selectedIndex]['upload']);
                              },
                            )
                          : (url != null)
                              ? GestureDetector(
                                  child: Text(url,
                                      style: TextStyle(
                                          color: Colors.blue[700],
                                          decoration:
                                              TextDecoration.underline)),
                                  onTap: () async {
                                    if (await canLaunch(url)) await launch(url);
                                  },
                                )
                              : docUploading
                                  ? Column(
                                    children: [
                                      SizedBox(height: 10,),
                                      CircularProgressIndicator(),
                                    ],
                                  )
                                  : SizedBox()
                    ],
                  ),
                )),
          ]),
        ),
        actions: <Widget>[
          new FlatButton(
              child: new Text(
                'Close',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                provider.listOfAssessment[provider.selectedIndex]['status']= 'closed';
                Navigator.of(context).pop();
              })
        ]);
  }
}
