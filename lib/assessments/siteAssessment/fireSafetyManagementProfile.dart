import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';

import '../../utilities.dart';

class FireSafetyRiskProfile extends StatefulWidget {
  final List<Map<String, dynamic>> preFilledData;
  final String cycleId;
  final double fireTotal;
  FireSafetyRiskProfile(
      {Key key,
      @required this.cycleId,
      @required this.fireTotal,
      this.preFilledData})
      : super(key: key);
  @override
  _FireSafetyRiskProfile createState() => _FireSafetyRiskProfile();
}

class _FireSafetyRiskProfile extends State<FireSafetyRiskProfile> {
  bool loading = false;
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
              actions: [
                FlatButton(
                    child: loading
                        ? CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text('Next',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                    onPressed: () async {
                      setState(() {
                        loading = true;
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
                          .update({'fireRiskProfile': siteRiskProfile});
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
                                              Text(
                                                'Fire Safety Risk Profile',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text('Total Marks: ' +
                                              widget.fireTotal.toString() +
                                              '/100'),
                                          SizedBox(height: 20),
                                          Text(
                                              'Positive Observation Specific to Fire Safety Risk Profile '),
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
                                          Text(
                                              'Major Observation Specific to Fire Safety Risk Profile'),
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
                                          Text(
                                              'Suggestion For Improvement Specific to Fire Safety Risk Profile'),
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
