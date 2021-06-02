import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';

import '../../utilities.dart';

class SummaryOfRiskProfile extends StatefulWidget {
  final List<Map<String, dynamic>> preFilledData;
  final String cycleId;
  final String type;
  SummaryOfRiskProfile(
      {Key key, @required this.cycleId, this.preFilledData, this.type})
      : super(key: key);
  @override
  _SummaryOfRiskProfileState createState() => _SummaryOfRiskProfileState();
}

class _SummaryOfRiskProfileState extends State<SummaryOfRiskProfile> {
  bool loading = false;
  bool save = true;
  List<Map<String, dynamic>> answers = [];
  TextEditingController _positiveP1 = TextEditingController();
  TextEditingController _positiveP2 = TextEditingController();
  TextEditingController _positiveP3 = TextEditingController();
  TextEditingController _seriousP1 = TextEditingController();
  TextEditingController _seriousP2 = TextEditingController();
  TextEditingController _seriousP3 = TextEditingController();
  TextEditingController _suggestionP1 = TextEditingController();
  TextEditingController _suggestionP2 = TextEditingController();
  TextEditingController _suggestionP3 = TextEditingController();
  @override
  void initState() {
    super.initState();
    answers = widget.preFilledData;

    _positiveP1.text = answers[0]['point1'];
    _positiveP2.text = answers[0]['point2'];
    _positiveP3.text = answers[0]['point3'];
    _seriousP1.text = answers[1]['point1'];
    _seriousP2.text = answers[1]['point2'];
    _seriousP3.text = answers[1]['point3'];
    _suggestionP1.text = answers[2]['point1'];
    _suggestionP2.text = answers[2]['point2'];
    _suggestionP3.text = answers[2]['point3'];
  }

  Utilities utilities = Utilities();
  ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              backgroundColor: utilities.mainColor,
              titleSpacing: 0.0,
              automaticallyImplyLeading: false,
              actions: [
                FlatButton(
                    child: loading
                        ? CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text('Submit',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: new Text(
                                  'Do you want to save or submit the assessment'),
                              actions: <Widget>[
                                new FlatButton(
                                  child: new Text('Save'),
                                  onPressed: () {
                                    save = true;
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: new Text('Submit'),
                                  onPressed: () {
                                    save = false;
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          });
                      List<Map<String, String>> siteRiskProfile = [];
                      Map<String, String> positive = {
                        'point1': _positiveP1.text,
                        'point2': _positiveP2.text,
                        'point3': _positiveP3.text,
                      };
                      siteRiskProfile.add(positive);
                      Map<String, String> serious = {
                        'point1': _seriousP1.text,
                        'point2': _seriousP2.text,
                        'point3': _seriousP3.text,
                      };
                      siteRiskProfile.add(serious);
                      Map<String, String> suggestion = {
                        'point1': _suggestionP1.text,
                        'point2': _suggestionP2.text,
                        'point3': _suggestionP3.text,
                      };
                      siteRiskProfile.add(suggestion);
                      await FirebaseFirestore.instance
                          .collection('cycles')
                          .doc(widget.cycleId)
                          .update({'summeryRiskProfile': siteRiskProfile});
                      if (save == false) {
                        if (widget.type == 'site') {
                          await FirebaseFirestore.instance
                              .collection('cycles')
                              .doc(widget.cycleId)
                              .update({
                            'currentStatus': 'Site Assessment Uploaded'
                          });
                        } else {
                          await FirebaseFirestore.instance
                              .collection('cycles')
                              .doc(widget.cycleId)
                              .update({
                            'currentStatus': 'Self Assessment Uploaded'
                          });
                        }
                      }
                      Navigator.of(context).pop();
                    })
              ],
            ),
            body: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: DraggableScrollbar.rrect(
                        alwaysVisibleScrollThumb: true,
                        backgroundColor: utilities.mainColor,
                        controller: _controller,
                        child: ListView.builder(
                          controller: _controller,
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text('Total Summery of Reports',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 25)),
                                            ],
                                          ),
                                          SizedBox(height: 20),
                                          Text('Positive Observation'),
                                          TextField(
                                            minLines: 1,
                                            maxLines: null,
                                            keyboardType:
                                                TextInputType.multiline,
                                            controller: _positiveP1,
                                            decoration: InputDecoration(
                                                labelText: '1.'),
                                          ),
                                          TextField(
                                            minLines: 1,
                                            maxLines: null,
                                            keyboardType:
                                                TextInputType.multiline,
                                            controller: _positiveP2,
                                            decoration: InputDecoration(
                                                labelText: '2.'),
                                          ),
                                          TextField(
                                            minLines: 1,
                                            maxLines: null,
                                            keyboardType:
                                                TextInputType.multiline,
                                            controller: _positiveP3,
                                            decoration: InputDecoration(
                                                labelText: '3.'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Major Observation'),
                                          TextField(
                                            minLines: 1,
                                            maxLines: null,
                                            keyboardType:
                                                TextInputType.multiline,
                                            controller: _seriousP1,
                                            decoration: InputDecoration(
                                                labelText: '1.'),
                                          ),
                                          TextField(
                                            minLines: 1,
                                            maxLines: null,
                                            keyboardType:
                                                TextInputType.multiline,
                                            controller: _seriousP2,
                                            decoration: InputDecoration(
                                                labelText: '2.'),
                                          ),
                                          TextField(
                                            minLines: 1,
                                            maxLines: null,
                                            keyboardType:
                                                TextInputType.multiline,
                                            controller: _seriousP3,
                                            decoration: InputDecoration(
                                                labelText: '3.'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Suggestion For Improvement'),
                                          TextField(
                                            minLines: 1,
                                            maxLines: null,
                                            keyboardType:
                                                TextInputType.multiline,
                                            controller: _suggestionP1,
                                            decoration: InputDecoration(
                                                labelText: '1.'),
                                          ),
                                          TextField(
                                            minLines: 1,
                                            maxLines: null,
                                            keyboardType:
                                                TextInputType.multiline,
                                            controller: _suggestionP2,
                                            decoration: InputDecoration(
                                                labelText: '2.'),
                                          ),
                                          TextField(
                                            minLines: 1,
                                            maxLines: null,
                                            keyboardType:
                                                TextInputType.multiline,
                                            controller: _suggestionP3,
                                            decoration: InputDecoration(
                                                labelText: '3.'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ))
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
}
