import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:mahindraCSC/roles/admin/changeStatus/changeProvider.dart';
import 'package:mahindraCSC/utilities.dart';
import 'package:provider/provider.dart';

class ChangeStatus extends StatefulWidget {
  @override
  _ChangeStatusState createState() => _ChangeStatusState();
}

class _ChangeStatusState extends State<ChangeStatus> {
  String changeStatus = '';
  Utilities utilities = Utilities();
  ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChangeStatusProvider>(context);
    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              backgroundColor: utilities.mainColor,
              titleSpacing: 0.0,
              automaticallyImplyLeading: false,
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
                              SizedBox(width: 60),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 10, 20, 10),
                                    child: Text(
                                      'Current Status',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15),
                                    )),
                              ),
                              SizedBox(
                                width: 80,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Change Status',
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
                                          width: 60,
                                        ),
                                        Row(
                                          children: [
                                            DropdownButton<String>(
                                              items: <String>[
                                                'Self Assessment Uploaded',
                                                'Site Assessment Uploaded',
                                                'Approved by CoAssessor',
                                                'Approved by PlantHead',
                                                'Assessment Scheduled',
                                                'Closed'
                                              ].map((String value) {
                                                return new DropdownMenuItem<
                                                    String>(
                                                  value: (value !=
                                                          'Assessment Scheduled')
                                                      ? value.toString()
                                                      : 'Annual Data Uploaded',
                                                  child: new Text(
                                                      value.toString()),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  provider.assessmentList[index]
                                                      ['currentStatus'] = value;
                                                });
                                              },
                                              value:
                                                  provider.assessmentList[index]
                                                      ['currentStatus'],
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          width: 80,
                                        ),
                                        RaisedButton(
                                          child: Text('Change'),
                                          onPressed: () async {
                                            await provider.uploadStatus(index);
                                          },
                                        )
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
