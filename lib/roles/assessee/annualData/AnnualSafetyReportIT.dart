import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mahindraCSC/roles/assessee/assesseeProvider.dart';
import 'package:mahindraCSC/utilities.dart';
import 'package:provider/provider.dart';
import '../assesseeDashboard.dart';
import 'monthly_safety_report.dart';

class AnnualySafetyReportIT extends StatefulWidget {
  final String type;
  final String cycleId;
  final String locationId;
  final String locationName;

  AnnualySafetyReportIT(
      {Key key, this.type, this.cycleId, this.locationId, this.locationName})
      : super(key: key);
  @override
  _AnnualySafetyReportIT createState() => _AnnualySafetyReportIT();
}

class _AnnualySafetyReportIT extends State<AnnualySafetyReportIT> {
  final _formKey = GlobalKey<FormState>();
  double _manpower = 0,
      _fatal = 0,
      _fatalaccidents = 0,
      _reportableaccidents = 0,
      _fireincidentmajor = 0,
      _fireincidentminor = 0;
  Future<void> _onPressedSave() async {
    if (widget.type == 'assessment') {
      firestoreInstance
          .collection("cycles")
          .doc(widget.cycleId)
          .update({
        "adCategory": 'category2',
        "adManPower": _manpower,
        "adFatal": _fatal,
        "adOnDutyFatal": _fatalaccidents,
        "adReportableAccidents": _reportableaccidents,
        "adFireIncidentMajor": _fireincidentmajor,
        "adFireIncidentMinor": _fireincidentminor
      }).then((_) {
        print("success!");
      });
    } else {
      firestoreInstance
          .collection('locations')
          .doc(widget.locationId)
          .collection('annualData')
          .doc('month${DateTime.now().month}')
          .set({
        "adCategory": 'category2',
        "manPower": _manpower,
        "fatal": _fatal,
        "onDutyFatal": _fatalaccidents,
        "reportableAccidents": _reportableaccidents,
        "fireIncidentMajor": _fireincidentmajor,
        "fireIncidentMinor": _fireincidentminor
      });
    }
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
          ),
          body: Center(
              child: Form(
            key: this._formKey,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: ListView(
                //shrinkWrap: true,
                padding: EdgeInsets.all(15.0),
                children: <Widget>[
                  Text(
                    'Fill in the required feilds',
                    style: TextStyle(fontSize: 22, color: Colors.red),
                    textAlign: TextAlign.left,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Manpower',
                              style: TextStyle(fontSize: 22),
                              textAlign: TextAlign.left,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(20.0)),
                                ),
                                labelText: 'Numbers',
                              ),
                              keyboardType: TextInputType.number,
                              onSubmitted: (String str) {
                                setState(
                                  () {
                                    _manpower = double.tryParse(str);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'Fatal',
                              style: TextStyle(fontSize: 22),
                              textAlign: TextAlign.left,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(20.0)),
                                ),
                                labelText: 'Numbers',
                              ),
                              keyboardType: TextInputType.number,
                              onSubmitted: (String str) {
                                setState(
                                  () {
                                    _fatal = double.tryParse(str);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'On duty Road Fatal Accidents',
                              style: TextStyle(fontSize: 22),
                              textAlign: TextAlign.left,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(20.0)),
                                ),
                                labelText: 'Numbers',
                              ),
                              keyboardType: TextInputType.number,
                              onSubmitted: (String str) {
                                setState(
                                  () {
                                    _fatalaccidents = double.tryParse(str);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'Reportable Accidents',
                              style: TextStyle(fontSize: 22),
                              textAlign: TextAlign.left,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(20.0)),
                                ),
                                labelText: 'Numbers',
                              ),
                              keyboardType: TextInputType.number,
                              onSubmitted: (String str) {
                                setState(
                                  () {
                                    _reportableaccidents = double.tryParse(str);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Fire Incident (Major)',
                              style: TextStyle(fontSize: 22),
                              textAlign: TextAlign.left,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(20.0)),
                                ),
                                labelText: 'Numbers',
                              ),
                              keyboardType: TextInputType.number,
                              onSubmitted: (String str) {
                                setState(
                                  () {
                                    _fireincidentmajor = double.tryParse(str);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'Fire Incident (Minor)',
                              style: TextStyle(fontSize: 22),
                              textAlign: TextAlign.left,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(20.0)),
                                ),
                                labelText: 'Numbers',
                              ),
                              keyboardType: TextInputType.number,
                              onSubmitted: (String str) {
                                setState(
                                  () {
                                    _fireincidentminor = double.tryParse(str);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 350,
                      ),
                      new FloatingActionButton.extended(
                        onPressed: () async {
                          await _onPressedSave();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                            return ChangeNotifierProvider(
                              create: (_) => AssesseeProvider(),
                              child: AssesseeDashboard(),
                            );
                          }));
                        },
                        icon: Icon(
                          Icons.save,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))),
                        label: Text("Submit"),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                    ],
                  ),
                ],
              ),
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
