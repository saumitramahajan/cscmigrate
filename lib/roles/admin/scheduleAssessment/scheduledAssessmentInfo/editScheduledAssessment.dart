import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mahindraCSC/roles/admin/scheduleAssessment/scheduledAssessmentInfo/scheduledInfoProvider.dart';
import 'package:mahindraCSC/utilities.dart';

import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EditScheduleAssessmentForm extends StatefulWidget {
  String assessorUid;
  String coAssessorUid;

  EditScheduleAssessmentForm({
    Key key,
    @required this.assessorUid,
    @required this.coAssessorUid,
  }) : super(key: key);
  @override
  _EditScheduleAssessmentFormState createState() =>
      _EditScheduleAssessmentFormState();
}

class _EditScheduleAssessmentFormState
    extends State<EditScheduleAssessmentForm> {
  String dropdownValue = 'select';
  String assessorUid;
  String coAssessorUid;
  bool datePicked = false;
  DateTime selectedDate;

  Utilities utilities = Utilities();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ScheduledAssessmentInfoProvider>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: utilities.mainColor,
            titleSpacing: 0.0,
            automaticallyImplyLeading: false,
          ),
          body: provider.loading
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
                                          color: utilities.mainColor,
                                          fontSize: 25)),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.025,
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
                                      0.025,
                                ),
                                Text(
                                  provider.assessmentList[
                                          provider.selectedIndex]['name'] +
                                      ', ' +
                                      provider.assessmentList[
                                          provider.selectedIndex]['location'],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                DropdownButton(
                                  isExpanded: true,
                                  value: provider.assessmentList[
                                      provider.selectedIndex]['assessoruid'],
                                  onChanged: (value) {
                                    setState(() {
                                      provider.assessmentList[
                                              provider.selectedIndex]
                                          ['assessoruid'] = value;
                                    });
                                  },
                                  items: provider.assessorList,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                DropdownButton(
                                  isExpanded: true,
                                  value: provider.assessmentList[
                                      provider.selectedIndex]['coAssessoruid'],
                                  onChanged: (value) {
                                    setState(() {
                                      provider.assessmentList[
                                              provider.selectedIndex]
                                          ['coAssessoruid'] = value;
                                    });
                                  },
                                  items: provider.assessorList,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  child: datePicked
                                      ? Text(
                                          'Scheduled Date: ${DateFormat('dd-MM-yyy').format(selectedDate)}')
                                      : Text(provider.assessmentList[provider
                                          .selectedIndex]['scheduledDate']),
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
                                  height: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      color: utilities.mainColor,
                                      child: provider.requesting
                                          ? CircularProgressIndicator(
                                              valueColor:
                                                  new AlwaysStoppedAnimation<
                                                      Color>(Colors.white),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                'Submit',
                                                style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            ),
                                      onPressed: () async {
                                        if (assessorUid != 'select' &&
                                            coAssessorUid != 'select' &&
                                            datePicked) {
                                          await provider.scheduleAssessment(
                                              provider.assessmentList[
                                                      provider.selectedIndex]
                                                  ['assessoruid'],
                                              provider.assessmentList[
                                                      provider.selectedIndex]
                                                  ['coAssessoruid'],
                                              selectedDate,
                                              provider.assessmentList[
                                                      provider.selectedIndex]
                                                  ['documentId']);
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
                                    SizedBox(height: 10),
                                    RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      color: utilities.mainColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          'Delete',
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                      onPressed: () {
                                        provider.deleteScheduledAssessment(
                                            provider.assessmentList[provider
                                                .selectedIndex]['documentId'],
                                            provider.selectedIndex);
                                      },
                                    )
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
