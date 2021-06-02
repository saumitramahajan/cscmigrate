import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:mahindraCSC/roles/assessee/assesseeClosedProvider.dart';

import 'package:mahindraCSC/roles/assessee/review/dialogue.dart';
import 'package:mahindraCSC/roles/assessor/review/closedAssessmentProvider.dart';

import 'package:url_launcher/url_launcher.dart';
import '../../../utilities.dart';
import 'dart:html' as html;
import 'package:firebase/firebase.dart' as fb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:readmore/readmore.dart';

class SelfAssessment extends StatefulWidget {
  String documentId;
  String nameofSite;
  String location;
//String role;

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
  List<bool> docLoading = [false];
  String url;
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
      docLoading = [true];
      url = uri.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssesseeClosedProvider>(context);

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
                FlatButton(
                  child: provider.uploadLoading
                      ? CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        )
                      : Text('Save',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                  onPressed: () async {
                  
                    await provider.editSiteUploadData(widget.documentId);
                  },
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
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 190),
                                    DropdownButton(
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
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            groupValue = value;
                                            _controller.jumpTo(0);
                                          });
                                        }),
                                  ],
                                ),
                                SizedBox(
                                  width: 180,
                                ),
                              ]),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  containerSiteDecision(groupValue, provider)
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

  Widget containerSiteDecision(
      String groupValue, AssesseeClosedProvider provider) {
    switch (groupValue) {
      case '1':
        {
          _controller.jumpTo(0);

          return siteProcessContainer(provider);
        }
        break;
      default:
        {
          _controller.jumpTo(0);

          return siteResultContainer(provider);
        }
        break;
    }
  }

  Widget siteProcessContainer(AssesseeClosedProvider provider) {
    return Container(
        width: MediaQuery.of(context).size.width * 1,
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

                    SizedBox(
                        width: 100,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Status',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ))
                    //  widget.role=='coAssessor'? SizedBox(
                    //     child: Container(
                    //         padding: EdgeInsets.all(10),
                    //         width: MediaQuery.of(context).size.width * 0.15,
                    //         child: Text(
                    //           'Comments',
                    //           style: TextStyle(color: Colors.grey[600]),
                    //         )),
                    //   ):SizedBox(),
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
                  itemCount: provider.statement.length,
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
                                          provider.statement[index]
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

                                          SizedBox(
                                              width: 200,
                                              child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  child: RaisedButton(
                                                    child:
                                                      provider.listOfAssessment[index]['status']=='open'
                                                            ? Text(
                                                                'Open'
                                                              )
                                                            : Text('Closed'),
                                                    onPressed: () async {

                                                        provider.setIndex(index);
                                                      await showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return ChangeNotifierProvider
                                                                .value(
                                                                    value:
                                                                        provider,
                                                                    child:
                                                                        Dialogue());
                                                          });

                                                          setState(() {
                                                            
                                                          });
                                                    },
                                                  ))),
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

  Widget siteResultContainer(AssesseeClosedProvider provider) {
    setState(() {});
    return Container(
        width: MediaQuery.of(context).size.width * 1,
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
                    SizedBox(width: 20),

                    SizedBox(
                        width: 100,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Status',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        )),
                    // SizedBox(width: 20),

                    // SizedBox(
                    //     width: 100,
                    //     child: Container(
                    //       padding: EdgeInsets.all(10),
                    //       child: Text(
                    //         'Upload File',
                    //         style: TextStyle(color: Colors.grey[600]),
                    //       ),
                    //     ))
                    //  widget.role=='coAssessor'? SizedBox(
                    //     child: Container(
                    //         padding: EdgeInsets.all(10),
                    //         width: MediaQuery.of(context).size.width * 0.15,
                    //         child: Text(
                    //           'Comments',
                    //           style: TextStyle(color: Colors.grey[600]),
                    //         )),
                    //   ):SizedBox(),
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
                  itemCount: provider.statement.length,
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
                                          provider.statement[index]
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
                                          SizedBox(width: 20),

                                          SizedBox(
                                              width: 200,
                                              child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  child: RaisedButton(
                                                    child:
                                                        provider.listOfAssessment[
                                                                        index][
                                                                    'upload'] ==
                                                                null
                                                            ? Text(
                                                                provider.listOfAssessment[
                                                                        index]
                                                                    ['status'],
                                                              )
                                                            : Text('Closed'),
                                                    onPressed: () async {

                                                        provider.setIndex(index);
                                                      await showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return ChangeNotifierProvider
                                                                .value(
                                                                    value:
                                                                        provider,
                                                                    child:
                                                                        Dialogue());
                                                          });
                                                    },
                                                  ))),
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
}
