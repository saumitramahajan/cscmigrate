import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mahindraCSC/roles/assessee/assesseeDashboard.dart';
import 'package:mahindraCSC/roles/assessee/assesseeProvider.dart';
import 'package:provider/provider.dart';

import '../../../utilities.dart';

final firestoreInstance = FirebaseFirestore.instance;

class AnnualySafetyReport extends StatefulWidget {
  final String type;
  final String cycleId;
  final String locationId;
  final String locationName;

  AnnualySafetyReport(
      {Key key, this.type, this.cycleId, this.locationId, this.locationName})
      : super(key: key);
  @override
  _AnnualySafetyReport createState() => _AnnualySafetyReport();
}

class _AnnualySafetyReport extends State<AnnualySafetyReport> {
  final _formKey = GlobalKey<FormState>();

  int _manpower = 0,
      _fatal = 0,
      _fatalaccidents = 0,
      _seriousAccidents = 0,
      _reportableaccidents = 0,
      _mandayslost = 0,
      _nonreportableaccidents = 0,
      _mandayslostnra = 0,
      _firstaidaccidents = 0,
      _totalaccidents = 0,
      _fireincident = 0,
      _fireincidentminor = 0,
      _kaizen = 0,
      _identified = 0,
      _safetyactivityrate = 0,
      _closureof = 0,
      _themebasedinspection = 0,
      _nearmissincident = 0;
  final fatalController = TextEditingController();
  final reportableaccController = TextEditingController();
  final nonreportableaccController = TextEditingController();
  final firstaidaccController = TextEditingController();
  final totalaccController = TextEditingController();

  void _onPressedSave() async {
    if (widget.type == 'assessment') {
      firestoreInstance
          .collection("cycles")
          .doc(widget.cycleId)
          .update({
        "adCategory": 'category1',
        "adManPower": _manpower,
        "adFatal": _fatal,
        "adFatalAccidents": _fatalaccidents,
        'adSeriousAccidents': _seriousAccidents,
        "adReportableAccidents": _reportableaccidents,
        "adManDaysLost": _mandayslost,
        "adNoReportableAccidents": _nonreportableaccidents,
        "adManDaysLostNra": _mandayslostnra,
        "adFirstaidAccidents": _firstaidaccidents,
        "adTotalAccidents": totalaccController.text,
        "adFireIncident": _fireincident,
        "adFireIncidentMinor": _fireincidentminor,
        "adKaizen": _kaizen,
        "adIdentified": _identified,
        "adSafetyActivityRate": _safetyactivityrate,
        "adClosureOf": _closureof,
        "adThemeBasedInspections": _themebasedinspection,
        "adNearMissIncident": _nearmissincident
      }).then((_) {
        print("success!");
      });
    } else {
      FirebaseFirestore.instance
          .collection('locations')
          .doc(widget.locationId)
          .collection('monthlyData')
          .doc('month${DateTime.now().month}')
          .set({
        "adCategory": 'category1',
        "manPower": _manpower,
        "fatal": _fatal,
        "fatalAccidents": _fatalaccidents,
        'seriousAccidents': _seriousAccidents,
        "reportableAccidents": _reportableaccidents,
        "manDaysLost": _mandayslost,
        "noReportableAccidents": _nonreportableaccidents,
        "manDaysLostNra": _mandayslostnra,
        "firstaidAccidents": _firstaidaccidents,
        "totalAccidents": totalaccController.text,
        "fireIncident": _fireincident,
        "fireIncidentMinor": _fireincidentminor,
        "kaizen": _kaizen,
        "identified": _identified,
        "safetyActivityRate": _safetyactivityrate,
        "closureOf": _closureof,
        "themeBasedInspections": _themebasedinspection,
        "nearMissIncident": _nearmissincident
      });
    }
  }

  void _updateToAcc() {
    totalaccController.text = (_fatal +
            _reportableaccidents +
            _nonreportableaccidents +
            _firstaidaccidents)
        .toString();
  }

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    fatalController.addListener(_updateToAcc);
    reportableaccController.addListener(_updateToAcc);
    nonreportableaccController.addListener(_updateToAcc);
    firstaidaccController.addListener(_updateToAcc);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    fatalController.dispose();
    reportableaccController.dispose();
    nonreportableaccController.dispose();
    firstaidaccController.dispose();
    totalaccController.dispose();
    super.dispose();
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
                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                      //mainAxisAlignment: MainAxisAlignment.start,
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
                                  hintText: 'Man Power',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (String str) {
                                  setState(
                                    () {
                                      _manpower = int.tryParse(str);
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
                                'Fatal (A)',
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
                                  hintText: 'Fatal Accidents',
                                ),
                                keyboardType: TextInputType.number,
                                controller: fatalController,
                                onChanged: (String str) {
                                  setState(() {
                                    _fatal = int.tryParse(str);
                                  });
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
                                'Reportable Accidents (B)',
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
                                  hintText: 'Reportable Accidents',
                                ),
                                keyboardType: TextInputType.number,
                                controller: reportableaccController,
                                onChanged: (String str) {
                                  setState(
                                    () {
                                      _reportableaccidents = int.tryParse(str);
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
                                'Man-days lost due to Reportable Accidents',
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
                                  hintText: 'Man-days lost (RA)',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (String str) {
                                  setState(
                                    () {
                                      _mandayslost = int.tryParse(str);
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
                                'Non-Reportable Accidents (C)',
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
                                  hintText: 'Non-Reportable Accidents',
                                ),
                                keyboardType: TextInputType.number,
                                controller: nonreportableaccController,
                                onChanged: (String str) {
                                  setState(
                                    () {
                                      _nonreportableaccidents =
                                          int.tryParse(str);
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
                                'Man-days lost due to Non-Reportable Accidents',
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
                                  hintText: 'Man-days lost (NRA)',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (String str) {
                                  setState(
                                    () {
                                      _mandayslostnra = int.tryParse(str);
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
                                'First Aid Accidents (D)',
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
                                  hintText: 'First Aid Accidents',
                                ),
                                keyboardType: TextInputType.number,
                                controller: firstaidaccController,
                                onChanged: (String str) {
                                  setState(() {
                                    _firstaidaccidents = int.tryParse(str);
                                  });
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
                                'Total Accidents (A+B+C+D)',
                                style: TextStyle(fontSize: 22),
                                textAlign: TextAlign.left,
                              ),
                              TextField(
                                enabled: false,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: new BorderRadius.all(
                                        new Radius.circular(20.0)),
                                  ),
                                  labelText: 'Numbers',
                                  hintText: 'Total Accidents',
                                ),
                                keyboardType: TextInputType.number,
                                controller: totalaccController,
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
                                'On Duty Road Accidents(Fatal)',
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
                                  hintText: 'On Duty Road Fatal Accidents',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (String str) {
                                  setState(
                                    () {
                                      _fatalaccidents = int.tryParse(str);
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
                                'On Duty Road Accidents(Serious)',
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
                                  hintText: 'On Duty Road Fatal Accidents',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (String str) {
                                  setState(
                                    () {
                                      _seriousAccidents = int.tryParse(str);
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
                                  hintText: 'Fire Incident (Major)',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (String str) {
                                  setState(
                                    () {
                                      _fireincident = int.tryParse(str);
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
                                  hintText: 'Fire Incident (Minor)',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (String str) {
                                  setState(
                                    () {
                                      _fireincidentminor = int.tryParse(str);
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
                                'Kaizen / Poka-Yoke',
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
                                  hintText: 'Kaizen / Poka-Yoke',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (String str) {
                                  setState(
                                    () {
                                      _kaizen = int.tryParse(str);
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
                                'Identified UA /UC for Month',
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
                                  hintText: 'Identified UA /UC for Month',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (String str) {
                                  setState(
                                    () {
                                      _identified = int.tryParse(str);
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
                                'Safety Activity Rate',
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
                                  hintText: 'Safety Activity Rate',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (String str) {
                                  setState(() {
                                    _safetyactivityrate = int.tryParse(str);
                                  });
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
                                'Closure of UA/UC till Date',
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
                                  hintText: 'Closure of UA/UC till Date',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (String str) {
                                  setState(() {
                                    _closureof = int.tryParse(str);
                                  });
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
                                'Theme Based Inspection ',
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
                                  hintText: 'Theme Based Inspection ',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (String str) {
                                  setState(() {
                                    _themebasedinspection = int.tryParse(str);
                                  });
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
                                'Near Miss Incident',
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
                                  hintText: 'Near Miss Incident',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (String str) {
                                  setState(
                                    () {
                                      _nearmissincident = int.tryParse(str);
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
                            _onPressedSave();
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
            ),
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
