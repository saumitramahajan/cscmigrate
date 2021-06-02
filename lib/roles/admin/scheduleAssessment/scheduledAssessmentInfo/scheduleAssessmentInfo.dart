import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';

import 'package:mahindraCSC/roles/admin/scheduleAssessment/scheduledAssessmentInfo/editScheduledAssessment.dart';

import 'package:mahindraCSC/roles/admin/scheduleAssessment/scheduledAssessmentInfo/scheduledInfoProvider.dart';

import 'package:mahindraCSC/utilities.dart';
import 'package:provider/provider.dart';

class ScheduleAssesmentInfo extends StatefulWidget {
  @override
  _ScheduleAssesmentInfoState createState() => _ScheduleAssesmentInfoState();
}

class _ScheduleAssesmentInfoState extends State<ScheduleAssesmentInfo> {
  String groupValue;
  String monthValue;
  String query;
  Utilities utilities = Utilities();
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ScheduledAssessmentInfoProvider>(context);
    return Stack(
      children: [
        Scaffold(
            endDrawer: Drawer(
              child: Container(
                color: utilities.mainColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Filter by:',
                      style: TextStyle(color: Colors.white),
                    ),
                    DropdownButton(
                        dropdownColor: utilities.mainColor,
                        iconEnabledColor: Colors.white,
                        underline: SizedBox(
                          height: 1,
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            child: Text(
                              'Site and Location',
                              style: TextStyle(color: Colors.white),
                            ),
                            value: 'site',
                          ),
                          DropdownMenuItem(
                              child: Text(
                                'Scheduled Month',
                                style: TextStyle(color: Colors.white),
                              ),
                              value: 'month'),
                          DropdownMenuItem(
                              child: Text(
                                'Assessor',
                                style: TextStyle(color: Colors.white),
                              ),
                              value: 'assessor'),
                          DropdownMenuItem(
                              child: Text(
                                'CoAssessor',
                                style: TextStyle(color: Colors.white),
                              ),
                              value: 'coAssessor')
                        ],
                        value: groupValue,
                        onChanged: (value) {
                          setState(() {
                            groupValue = value;
                          });
                        }),
                    (groupValue == 'site' ||
                            groupValue == 'assessor' ||
                            groupValue == 'coAssessor')
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              cursorColor: Colors.white,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  query = value;
                                });
                              },
                            ),
                          )
                        : (groupValue == 'month')
                            ? DropdownButton(
                                dropdownColor: utilities.mainColor,
                                iconEnabledColor: Colors.white,
                                underline: SizedBox(
                                  height: 1,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                                items: [
                                  DropdownMenuItem(
                                    child: Text('January',
                                        style: TextStyle(color: Colors.white)),
                                    value: '01',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('February',
                                        style: TextStyle(color: Colors.white)),
                                    value: '02',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('March',
                                        style: TextStyle(color: Colors.white)),
                                    value: '03',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('April',
                                        style: TextStyle(color: Colors.white)),
                                    value: '04',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('May',
                                        style: TextStyle(color: Colors.white)),
                                    value: '05',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('June',
                                        style: TextStyle(color: Colors.white)),
                                    value: '06',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('July',
                                        style: TextStyle(color: Colors.white)),
                                    value: '07',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('August',
                                        style: TextStyle(color: Colors.white)),
                                    value: '08',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('September',
                                        style: TextStyle(color: Colors.white)),
                                    value: '09',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('October',
                                        style: TextStyle(color: Colors.white)),
                                    value: '10',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('November',
                                        style: TextStyle(color: Colors.white)),
                                    value: '11',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('December',
                                        style: TextStyle(color: Colors.white)),
                                    value: '12',
                                  ),
                                ],
                                value: monthValue,
                                onChanged: (value) {
                                  setState(() {
                                    monthValue = value;
                                  });
                                })
                            : SizedBox(),
                    RaisedButton(
                        child: Text('Filter'),
                        onPressed: () {
                          provider.filter(groupValue, query, monthValue);
                          Navigator.of(context).pop();
                        })
                  ],
                ),
              ),
            ),
            appBar: AppBar(
              backgroundColor: utilities.mainColor,
              titleSpacing: 0.0,
              automaticallyImplyLeading: false,
              actions: [
                 provider.loading == false?
                Row(children: [
                  Text(
                    'Closed:' + provider.closed.toString(),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(width:20),
                  Text(
                    'Pending:' + provider.pending.toString(),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ]):SizedBox(),
                SizedBox(width:20),
                provider.loading == false
                    ? Builder(
                        builder: (context) => IconButton(
                            icon: Icon(Icons.filter_list),
                            onPressed: () =>
                                Scaffold.of(context).openEndDrawer(),
                            tooltip: 'Filter'),
                      )
                    : SizedBox(),
              ],
            ),
            body: Center(
                child: provider.loading
                    ? CircularProgressIndicator()
                    : Container(
                        width: MediaQuery.of(context).size.width * .95,
                        child: Column(children: [
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Site',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15),
                                    )),
                              ),
                              SizedBox(width: 20),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 10, 20, 10),
                                    child: Text(
                                      'Scheduled Date',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15),
                                    )),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Assessor',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15),
                                    )),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'CoAssessor',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15),
                                    )),
                              ),
                            ],
                          ),
                          Expanded(
                            child: DraggableScrollbar.rrect(
                              alwaysVisibleScrollThumb: true,
                              backgroundColor: utilities.mainColor,
                              controller: _controller,
                              child: ListView.builder(
                                  controller: _controller,
                                  itemCount: provider.assessmentList.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      elevation: 5.0,
                                      color: provider.assessmentList[index]
                                                  ['currentStatus'] ==
                                              'Closed'
                                          ? Colors.green[50]
                                          : Colors.red[50],
                                      margin: EdgeInsets.fromLTRB(
                                          8.0, 8.0, 8.0, 8.0),
                                      child: Row(children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                                provider.assessmentList[index]
                                                        ['name'] +
                                                    ', ' +
                                                    provider.assessmentList[
                                                        index]['location'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color:
                                                        utilities.mainColor)),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                                provider.assessmentList[index]
                                                    ['scheduledDate']),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Text(provider
                                                .assessmentList[index]
                                                    ['assessorName']
                                                .toString()),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Text(provider
                                                .assessmentList[index]
                                                    ['coAssessorName']
                                                .toString()),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: RaisedButton(
                                                  child: Text('Edit'),
                                                  onPressed: () async {
                                                    provider.setIndex(index);
                                                    provider
                                                        .getScheduleAssessmentInfo();
                                                    provider.getLocationList();

                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                        return ChangeNotifierProvider
                                                            .value(
                                                          value: provider,
                                                          child:
                                                              EditScheduleAssessmentForm(
                                                            assessorUid: provider
                                                                        .assessmentList[
                                                                    provider
                                                                        .selectedIndex]
                                                                [
                                                                'assessorName'],
                                                            coAssessorUid: provider
                                                                        .assessmentList[
                                                                    provider
                                                                        .selectedIndex]
                                                                [
                                                                'coAssessorName'],
                                                          ),
                                                        );
                                                      }),
                                                    );
                                                  })),
                                        ),
                                      ]),
                                    );
                                  }),
                            ),
                          ),
                        ]),
                      ))),
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
