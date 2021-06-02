import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:mahindraCSC/roles/admin/enrollLocation/enrollLocationProvider.dart';

import 'package:provider/provider.dart';

import '../../../utilities.dart';

class EnrollMahindraLocation extends StatefulWidget {
  @override
  _EnrollMahindraLocationState createState() => _EnrollMahindraLocationState();
}

class _EnrollMahindraLocationState extends State<EnrollMahindraLocation> {
  String _valueCategory = 'Manufacturing,Hospitality and Construction Sector';
  String _valueLastAssessmentStage;
  String _valueProcessLevel;
  String _valueResultLevel;
  String _valueAssesseeUid;
  String _valuePlantHeadUid;
  String _nameOfSector = '';
  String _nameOfBusiness = '';
  String _location = '';
  String _plantHeadName;
  String _plantHeadEmail;
  String _sectorBusinessSafetySpocName;
  String _sectorBusinessSafetySpocEmail;
  String plantHeadName;
  String plantHeadEmail;
  String spocName;
  String spocEmail;

  Utilities utilities = Utilities();
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final enrollProvider = Provider.of<EnrollLocationProvider>(context);
    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              backgroundColor: utilities.mainColor,
              titleSpacing: 0.0,
              automaticallyImplyLeading: false,
            ),
            body: enrollProvider.loading
                ? Center(child: CircularProgressIndicator())
                : DraggableScrollbar.rrect(
                    alwaysVisibleScrollThumb: true,
                    controller: _controller,
                    backgroundColor: utilities.mainColor,
                    child: ListView.builder(
                      controller: _controller,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                padding: EdgeInsets.all(15.0),
                                width: MediaQuery.of(context).size.width * 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 60,
                                    ),
                                    Text('Category: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    SizedBox(height: 10),
                                    DropdownButton<String>(
                                      items: [
                                        DropdownMenuItem<String>(
                                          child: Text(
                                            'Manufacturing,Hospitality and\nConstruction Sector',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          value:
                                              'Manufacturing,Hospitality and Construction Sector',
                                        ),
                                        DropdownMenuItem<String>(
                                          child: Text(
                                              'IT,Finance and Aftermarket Sectors',
                                              style: TextStyle(fontSize: 14)),
                                          value:
                                              'IT,Finance and Aftermarket Sectors',
                                        )
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          _valueCategory = value;
                                        });
                                      },
                                      hint: Text('Select Category'),
                                      value: _valueCategory,
                                    ),
                                    /*(_valueCategory ==
                                'Manufacturing,Hospitality and Construction Sector')
                            ? */
                                    Column(
                                      children: [
                                        TextFormField(
                                          validator: (input) {
                                            if (input.isEmpty) {
                                              return 'Enter Name of Site';
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            _nameOfSector = value;
                                          },
                                          decoration: InputDecoration(
                                              labelText: 'Name of Sector'),
                                        ),
                                        TextFormField(
                                          validator: (input) {
                                            if (input.isEmpty) {
                                              return 'Enter Location';
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            _location = value;
                                          },
                                          decoration: InputDecoration(
                                              labelText: 'Location'),
                                        ),
                                        Row(
                                          children: [
                                            Text('Last Assessment Stage: '),
                                            DropdownButton<String>(
                                              items: <int>[
                                                1,
                                                2,
                                                3,
                                                4,
                                                5,
                                                6,
                                                7,
                                                8,
                                                9,
                                                10
                                              ].map((int value) {
                                                return new DropdownMenuItem<
                                                    String>(
                                                  value: value.toString(),
                                                  child: new Text(
                                                      value.toString()),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  _valueLastAssessmentStage =
                                                      value;
                                                });
                                              },
                                              hint: Text('Rate from 1-10'),
                                              value: _valueLastAssessmentStage,
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text('Process Level: '),
                                            DropdownButton<String>(
                                              items: <int>[1, 2, 3, 4, 5]
                                                  .map((int value) {
                                                return new DropdownMenuItem<
                                                    String>(
                                                  value: value.toString(),
                                                  child: new Text(
                                                      value.toString()),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  _valueProcessLevel = value;
                                                });
                                              },
                                              hint: Text('Rate from 1-5'),
                                              value: _valueProcessLevel,
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text('Result Level: '),
                                            DropdownButton<String>(
                                              items: <int>[1, 2, 3, 4, 5]
                                                  .map((int value) {
                                                return new DropdownMenuItem<
                                                    String>(
                                                  value: value.toString(),
                                                  child: new Text(
                                                      value.toString()),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  _valueResultLevel = value;
                                                });
                                              },
                                              hint: Text('Rate from 1-5'),
                                              value: _valueResultLevel,
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text('Assessee: '),
                                            DropdownButton<String>(
                                              items: enrollProvider.assessee,
                                              onChanged: (value) {
                                                setState(() {
                                                  _valueAssesseeUid = value;
                                                  spocName = enrollProvider
                                                          .assesseeList[
                                                      enrollProvider
                                                          .assesseeList
                                                          .indexWhere((element) =>
                                                              element.containsValue(
                                                                  value))]['Name'];
                                                  spocEmail = enrollProvider
                                                          .assesseeList[
                                                      enrollProvider
                                                          .assesseeList
                                                          .indexWhere((element) =>
                                                              element.containsValue(
                                                                  value))]['Email'];
                                                });
                                              },
                                              hint: Text('Select One'),
                                              value: _valueAssesseeUid,
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text('Plant Head: '),
                                            DropdownButton<String>(
                                              items: enrollProvider.plantHead,
                                              onChanged: (value) {
                                                setState(() {
                                                  _valuePlantHeadUid = value;
                                                  plantHeadName = enrollProvider
                                                          .plantHeadList[
                                                      enrollProvider
                                                          .plantHeadList
                                                          .indexWhere((element) =>
                                                              element.containsValue(
                                                                  value))]['Name'];
                                                  plantHeadEmail = enrollProvider
                                                          .plantHeadList[
                                                      enrollProvider
                                                          .plantHeadList
                                                          .indexWhere((element) =>
                                                              element.containsValue(
                                                                  value))]['Email'];
                                                });
                                              },
                                              hint: Text('Select One'),
                                              value: _valuePlantHeadUid,
                                            )
                                          ],
                                        ),
                                        // TextFormField(
                                        //   validator: (input) {
                                        //     if (input.isEmpty) {
                                        //       return 'Enter Plant Head Name';
                                        //     }
                                        //     return null;
                                        //   },
                                        //  controller: plantHeadName,
                                        //   decoration: InputDecoration(
                                        //       labelText: 'Plant Head Name'),
                                        // ),
                                        // TextFormField(
                                        //   validator: (input) {
                                        //     if (input.isEmpty) {
                                        //       return 'Enter Plant Head Email';
                                        //     }
                                        //     return null;
                                        //   },
                                        //  controller: plantHeadEmail,
                                        //   decoration: InputDecoration(
                                        //       labelText: 'Plant Head Email'),
                                        // ),
                                        // TextFormField(
                                        //   validator: (input) {
                                        //     if (input.isEmpty) {
                                        //       return 'Enter Sector/Business Safety Spoc Name';
                                        //     }
                                        //     return null;
                                        //   },
                                        //  controller: spocName,
                                        //   decoration: InputDecoration(
                                        //       labelText:
                                        //           'Sector/Business Safety Spoc Name'),
                                        // ),
                                        // TextFormField(
                                        //   validator: (input) {
                                        //     if (input.isEmpty) {
                                        //       return 'Enter Sector/Business Safety Spoc Email';
                                        //     }
                                        //     return null;
                                        //   },
                                        //  controller: spocEmail,
                                        //   decoration: InputDecoration(
                                        //       labelText:
                                        //           'Sector/Business Safety Spoc Email'),
                                        // ),
                                        RaisedButton(
                                          child: Text('Enroll'),
                                          onPressed: () async {
                                            if (_location != '' &&
                                                _nameOfSector != '' &&
                                                _valueAssesseeUid != '' &&
                                                _valuePlantHeadUid != '' &&
                                                _valueCategory != '' &&
                                                _valueLastAssessmentStage !=
                                                    '' &&
                                                _valueProcessLevel != '' &&
                                                _valueResultLevel != '') {
                                              await enrollProvider
                                                  .enrollMahindraLocation(
                                                      _valueCategory,
                                                      _nameOfSector,
                                                      _nameOfBusiness,
                                                      _location,
                                                      _valueLastAssessmentStage,
                                                      _valueProcessLevel,
                                                      _valueResultLevel,
                                                      _valueAssesseeUid,
                                                      _valuePlantHeadUid,
                                                      plantHeadName,
                                                      plantHeadEmail,
                                                      spocName,
                                                      spocEmail);
                                              if (enrollProvider.enrolled) {
                                                Navigator.of(context).pop();
                                              } else {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: new Text(
                                                            'Enroll Failed'),
                                                        content: new Text(
                                                            'Something has occured.Please try again later.'),
                                                        actions: <Widget>[
                                                          new FlatButton(
                                                            child: new Text(
                                                                'Close'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          )
                                                        ],
                                                      );
                                                    });
                                              }
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: new Text(
                                                          'Form Incomplete'),
                                                      content: new Text(
                                                          'Please fill all fields in the form.'),
                                                      actions: <Widget>[
                                                        new FlatButton(
                                                          child:
                                                              new Text('Close'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  });
                                            }
                                          },
                                        )
                                      ],
                                    )
                                    //: SizedBox()
                                  ],
                                )),
                          ],
                        );
                      },
                    ),
                  )),
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
