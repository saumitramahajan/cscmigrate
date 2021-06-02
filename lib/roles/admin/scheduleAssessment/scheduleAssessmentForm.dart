import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utilities.dart';
import 'scheduleAssessmentProvider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ScheduleAssessmentForm extends StatefulWidget {
  @override
  _ScheduleAssessmentFormState createState() => _ScheduleAssessmentFormState();
}

class _ScheduleAssessmentFormState extends State<ScheduleAssessmentForm> {
  String dropdownValue = 'select';
  String assessorUid = 'select';
  String coAssessorUid = 'select';
  bool datePicked = false;
  DateTime selectedDate;

  Utilities utilities = Utilities();

  @override
  Widget build(BuildContext context) {
    final requestAD = Provider.of<ScheduleAssessmentProvider>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: utilities.mainColor,
            titleSpacing: 0.0,
            automaticallyImplyLeading: false,
          ),
          body: requestAD.listLoading
              ? Center(child: CircularProgressIndicator())
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(25),
                      height: MediaQuery.of(context).size.height * 0.8,
                      width: MediaQuery.of(context).size.width * 0.325,
                      child: Card(
                        elevation: 12.0,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.025,
                                ),
                                Text(
                                  'Schedule Assessment',
                                  style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                          color: Color(0xfff4001c),
                                          fontSize: 25)),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.075,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Fill the required fields',
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.015,
                                ),
                                DropdownButton(
                                  isExpanded: true,
                                  value: dropdownValue,
                                  onChanged: (value) {
                                    setState(() {
                                      dropdownValue = value;
                                    });
                                  },
                                  items: requestAD.dropDownList,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                DropdownButton(
                                  isExpanded: true,
                                  value: assessorUid,
                                  onChanged: (value) {
                                    setState(() {
                                      assessorUid = value;
                                    });
                                  },
                                  items: requestAD.assessorList,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                DropdownButton(
                                  isExpanded: true,
                                  value: coAssessorUid,
                                  onChanged: (value) {
                                    setState(() {
                                      coAssessorUid = value;
                                    });
                                  },
                                  items: requestAD.assessorList,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  child: datePicked
                                      ? Text(
                                          'Scheduled Date: ${DateFormat('dd-MM-yyyy').format(selectedDate)}')
                                      : Text('Scheduled Assessment Date'),
                                  onTap: () async {
                                    DateTime picked = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate:
                                            DateTime(DateTime.now().year + 5));
                                    if (picked != null) {
                                      setState(() {
                                        datePicked = true;
                                        selectedDate = picked;
                                      });
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 35,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      color: utilities.mainColor,
                                      child: requestAD.requesting
                                          ? CircularProgressIndicator(
                                              valueColor:
                                                  new AlwaysStoppedAnimation<
                                                      Color>(Colors.white),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                'Schedule Assessment',
                                                style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            ),
                                      onPressed: () async {
                                        if (assessorUid != 'select' &&
                                            dropdownValue != 'select' &&
                                            coAssessorUid != 'select' &&
                                            datePicked) {
                                          await requestAD.scheduleAssessment(
                                              dropdownValue,
                                              assessorUid,
                                              coAssessorUid,
                                              selectedDate);
                                          Navigator.of(context).pop();
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: new Text(
                                                      'Form Incomplete'),
                                                  content: new Text(
                                                      'Please fill all fields in the form.'),
                                                  actions: <Widget>[
                                                    new FlatButton(
                                                      child: new Text('Close'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    )
                                                  ],
                                                );
                                              });
                                        }
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width * 0.625,
                      child: Opacity(
                        opacity: 0.75,
                        child: Image.asset('assets/Picture2BW.png'),
                      ),
                    ),
                  ],
                ),
        ),
        SizedBox(
          height: AppBar().preferredSize.height * 2,
          child: Image.asset(
            'assets/mahindraAppBar.png',
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

/*Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              backgroundColor: utilities.mainColor,
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
            body: requestAD.listLoading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownButton(
                          isExpanded: true,
                          value: dropdownValue,
                          onChanged: (value) {
                            setState(() {
                              dropdownValue = value;
                            });
                          },
                          items: requestAD.dropDownList,
                        ),
                        DropdownButton(
                          isExpanded: true,
                          value: assessorUid,
                          onChanged: (value) {
                            setState(() {
                              assessorUid = value;
                            });
                          },
                          items: requestAD.assessorList,
                        ),
                        GestureDetector(
                          child: datePicked
                              ? Text(
                                  'Scheduled Date: ${DateFormat('dd-yy-yyy').format(selectedDate)}')
                              : Text('Scheduled Assessment Date'),
                          onTap: () async {
                            DateTime picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(DateTime.now().year + 5));
                            if (picked != null) {
                              setState(() {
                                datePicked = true;
                                selectedDate = picked;
                              });
                            }
                          },
                        ),
                        RaisedButton(
                          child: requestAD.requesting
                              ? CircularProgressIndicator()
                              : Text('Schedule'),
                          onPressed: () async {
                            await requestAD.scheduleAssessment(
                                dropdownValue, assessorUid, selectedDate);
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  )),
        SizedBox(
          height: AppBar().preferredSize.height * 2,
          child: Image.asset(
            'assets/mahindraAppBar.png',
            fit: BoxFit.contain,
          ),
        )
      ],
    );*/

/**/
