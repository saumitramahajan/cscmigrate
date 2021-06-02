import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mahindraCSC/roles/assessee/assesseeProvider.dart';
import 'package:mahindraCSC/utilities.dart';
import 'package:provider/provider.dart';
import '../assesseeDashboard.dart';
import 'monthly_safety_report.dart';

class MonthlySafetyReportIT extends StatefulWidget {
  final String type;
  final String cycleId;
  final String locationId;
  final String locationName;

  MonthlySafetyReportIT(
      {Key key, this.type, this.cycleId, this.locationId, this.locationName})
      : super(key: key);
  @override
  _MonthlySafetyReportIT createState() => _MonthlySafetyReportIT();
}

class _MonthlySafetyReportIT extends State<MonthlySafetyReportIT> {
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

  ScrollController _controller = ScrollController();
  Utilities utilities = Utilities();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff4001c),
        title: SizedBox(
          height: AppBar().preferredSize.height,
          child: Image.asset(
            'assets/mahindraAppBar.png',
            fit: BoxFit.contain,
          ),
        ),
        titleSpacing: 0.0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
          child: DraggableScrollbar.rrect(
        alwaysVisibleScrollThumb: true,
        backgroundColor: utilities.mainColor,
        controller: _controller,
        child: ListView.builder(
          controller: _controller,
          itemCount: 1,
          itemBuilder: (context, index) {
            return Form(
              key: this._formKey,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(15.0),
                children: [
                  Text('Please fill all the feilds'),
                  Text(
                    'Manpower',
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.left,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
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
                  Text(
                    'Fatal',
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.left,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
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
                  Text(
                    'On duty Road Fatal Accidents',
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.left,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
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
                  Text(
                    'Reportable Accidents',
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.left,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
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
                  Text(
                    'Fire Incident (Major)',
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.left,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
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
                  Text(
                    'Fire Incident (Minor)',
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.left,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
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
                  new FloatingActionButton.extended(
                    onPressed: () async {
                      await _onPressedSave();
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return ChangeNotifierProvider<AssesseeProvider>(
                          create: (_) => AssesseeProvider(),
                          child: AssesseeDashboard(),
                        );
                      }));
                    },
                    icon: Icon(
                      Icons.save,
                    ),
                    shape: RoundedRectangleBorder(),
                    label: Text("Submit"),
                  ),
                ],
              ),
            );
          },
        ),
      )),
    );
  }
}
