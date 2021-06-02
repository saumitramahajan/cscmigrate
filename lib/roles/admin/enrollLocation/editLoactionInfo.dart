

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahindraCSC/roles/admin/dashboard/adminDashboard.dart';

import 'package:mahindraCSC/utilities.dart';


class EditLocationInfo extends StatefulWidget {
  final Map<String, dynamic> locationMap;

  EditLocationInfo({Key key, this.locationMap}) : super(key: key);

  @override
  _EditLocationInfoState createState() => _EditLocationInfoState();
}

class _EditLocationInfoState extends State<EditLocationInfo> {
  String _valueAssesseeUid ;
  String _valuePlantHeadUid;

  String _nameOfSector = '';

  String _location = '';
  String _plantHeadName ;
  String _plantHeadEmail ;
  String _sectorBusinessSafetySpocName;
  String _sectorBusinessSafetySpocEmail;
  bool loading = false;
  bool changed = true;
  Map<String, dynamic> _locationMap = {};
  List<Map<String, String>> assesseeList = [];
  List<Map<String, String>> plantHeadList = [];
  List<Map<String, String>> locationMap = [];
  List<DropdownMenuItem<String>> assessee = [];
  List<DropdownMenuItem<String>> plantHead = [];
  int selectedIndex;

   TextEditingController plantHeadName = TextEditingController();
  TextEditingController plantHeadEmail = TextEditingController();
  TextEditingController spocName = TextEditingController();
  TextEditingController spocEmail = TextEditingController();


  void initState() {
    _locationMap = widget.locationMap;
    _nameOfSector = _locationMap['nameOfSector'];
    _location = _locationMap['location'];
    _valueAssesseeUid = _locationMap['assessee'];
    _valuePlantHeadUid = _locationMap['plantHead'];
    plantHeadName.text = _locationMap['plantHeadName'];
    plantHeadEmail.text = _locationMap['plantHeadEmail'];
    spocName.text =
        _locationMap['sectorBusinessSafetySpocName'];
    spocEmail.text =
        _locationMap['sectorBusinessSafetySpocEmail'];

    editLocation();

    super.initState();
  }

  Future<void> getDropdownList() async {
    assessee = assesseeList.map((Map<String, String> value) {
      return DropdownMenuItem(
        child: Text(value['Name']),
        value: value['uid'],
      );
    }).toList();
  }

  Future<void> getPlantHeadDropdownList() async {
    plantHead = plantHeadList.map((Map<String, String> value) {
      return DropdownMenuItem(
        child: Text(value['Name']),
        value: value['uid'],
      );
    }).toList();
  }

  Future<void> getAssesseeMap() async {
    await FirebaseFirestore.instance
        .collection('users')
        .orderBy('name')
        .get()
        .then((QuerySnapshot assessee) {
      assessee.docs.forEach((element) {
        List<dynamic> roles = element['role'];
        if (roles.contains('assessee')) {
          Map<String, String> assesseeMap = {
            'Name': element.data()['name'],
            'Email':element.data()['email'],

            'uid': element.id
          };

          assesseeList.add(assesseeMap);
        }
      });
    });
    await getDropdownList();
  }

  Future<void> getPlantHeadMap() async {
    await FirebaseFirestore.instance
        .collection('users')
        .orderBy('name')
        .get()
        .then((QuerySnapshot plantHead) {
      plantHead.docs.forEach((element) {
        List<dynamic> roles = element['role'];
        if (roles.contains('plantHead')) {
          Map<String, String> assesseeMap = {
            'Name': element.data()['name'],
            'Email':element.data()['email'],
            'uid': element.id
          };

          plantHeadList.add(assesseeMap);
        }
      });
    });
    await getPlantHeadDropdownList();
  }

  void editLocation() async {
    setState(() {
      loading = true;
    });
    await getAssesseeMap();
    await getPlantHeadMap();
    setState(() {
      loading = false;
    });
  }

  Utilities utilities = Utilities();
  ScrollController _controller = ScrollController();
  
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Stack(
      key: _scaffoldKey,
      children: [
        Scaffold(
            appBar: AppBar(
              backgroundColor: utilities.mainColor,
              titleSpacing: 0.0,
              automaticallyImplyLeading: false,
            ),
            body: loading
                ? Center(child: CircularProgressIndicator())
                : DraggableScrollbar.rrect(
                    alwaysVisibleScrollThumb: true,
                    backgroundColor: utilities.mainColor,
                    controller: _controller,
                    child: ListView.builder(
                      controller: _controller,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                padding: EdgeInsets.all(15.0),
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Column(
                                  children: [
                                    Row(children: [
                                      Text('Category:  ' +
                                          _locationMap['category'],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                    ]),

                                    SizedBox(height:10),
                                    /*(_valueCategory ==
                                'Manufacturing,Hospitality and Construction Sector')
                            ? */
                                    Column(
                                      children: [
                                        TextFormField(
                                          initialValue:
                                              _locationMap['nameOfSector'],
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
                                         SizedBox(height:10),
                                        TextFormField(
                                          initialValue:
                                              _locationMap['location'],
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
                                         SizedBox(height:10),
                                        Row(
                                          children: [
                                            Text('Assessee: '),
                                            DropdownButton<String>(
                                              items: assessee,
                                              onChanged: (value) {
                                                setState(() {
                                                  _valueAssesseeUid = value;
                                                  spocName.text=assesseeList[assesseeList.indexWhere((element)=>element.containsValue(value))]['Name'];
                                                 spocEmail.text=assesseeList[assesseeList.indexWhere((element)=>element.containsValue(value))]['Email'];
                                                });
                                              },
                                              value: _valueAssesseeUid,
                                            )
                                          ],
                                        ),
                                         SizedBox(height:10),
                                        Row(
                                          children: [
                                            Text('Plant Head: '),
                                            DropdownButton<String>(
                                              items: plantHead,
                                              onChanged: (value) {
                                                setState(() {
                                                  _valuePlantHeadUid = value;
                                                   plantHeadName.text=plantHeadList[plantHeadList.indexWhere((element)=>element.containsValue(value))]['Name'];
                                                 plantHeadEmail.text=plantHeadList[plantHeadList.indexWhere((element)=>element.containsValue(value))]['Email'];

                                                });
                                              },
                                              value: _valuePlantHeadUid,
                                            )
                                          ],
                                        ),
                                        TextFormField(
                                          // initialValue:
                                          //     _locationMap['plantHeadName'],
                                          
                                          validator: (input) {
                                            if (input.isEmpty) {
                                              return 'Enter Plant Head Name';
                                            }
                                            return null;
                                          },
                                         controller: plantHeadName,
                                          decoration: InputDecoration(
                                              labelText: 'Plant Head Name'),
                                        ),
                                         SizedBox(height:10),
                                        TextFormField(
                                          // initialValue:
                                          //     _locationMap['plantHeadEmail'],
                                          validator: (input) {
                                            if (input.isEmpty) {
                                              return 'Enter Plant Head Email';
                                            }
                                            return null;
                                          },
                                         controller: plantHeadEmail,
                                          decoration: InputDecoration(
                                              labelText: 'Plant Head Email'),
                                        ),
                                         SizedBox(height:10),
                                        TextFormField(
                                          // initialValue: _locationMap[
                                          //     'sectorBusinessSafetySpocName'],
                                          validator: (input) {
                                            if (input.isEmpty) {
                                              return 'Enter Sector/Business Safety Spoc Name';
                                            }
                                            return null;
                                          },
                                         controller: spocName,
                                          decoration: InputDecoration(
                                              labelText:
                                                  'Sector/Business Safety Spoc Name'),
                                        ),
                                         SizedBox(height:10),
                                        TextFormField(
                                          //  initialValue: _locationMap[
                                          //     'sectorBusinessSafetySpocEmail'],
                                         
                                          validator: (input) {
                                            if (input.isEmpty) {
                                              return 'Enter Sector/Business Safety Spoc Email';
                                            }
                                            return null;
                                          },
                                        controller: spocEmail,
                                          decoration: InputDecoration(
                                              labelText:
                                                  'Sector/Business Safety Spoc Email'),
                                        ),
                                        SizedBox(height: 20),
                                        RaisedButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                          ),
                                          color: utilities.mainColor,
                                          child: loading
                                              ? CircularProgressIndicator(
                                                  valueColor:
                                                      new AlwaysStoppedAnimation<
                                                          Color>(Colors.white),
                                                )
                                              : Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                    'Update',
                                                    style: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                ),
                                          onPressed: () async {
                                              loading = true;

                                            if (_nameOfSector != '' &&
                                                _location != '' &&
                                                _valueAssesseeUid != '' &&
                                                _valuePlantHeadUid != '' &&
                                                _plantHeadName != '' &&
                                                _plantHeadEmail != '' &&
                                                _sectorBusinessSafetySpocName !=
                                                    '' &&
                                                _sectorBusinessSafetySpocEmail !=
                                                    '') {
                                              print('fields not empty');

                                              if (changed) {
                                                try {
                                                  await FirebaseFirestore.instance
                                                      .collection('locations')
                                                      .doc(_locationMap[
                                                          'documentId'])
                                                      .update({
                                                    'nameOfSector':
                                                        _nameOfSector,
                                                    'location': _location,
                                                    'assessee':
                                                        _valueAssesseeUid,
                                                    'plantHead':
                                                        _valuePlantHeadUid,
                                                    'plantHeadName':
                                                       plantHeadName.text,
                                                    'plantHeadEmail':
                                                        plantHeadEmail.text,
                                                    'sectorBusinessSafetySpocName':
                                                        spocName.text,
                                                    'sectorBusinessSafetySpocEmail':
                                                       spocEmail.text,
                                                  });
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AdminDashboard()),
                                                  );
                                                } catch (e) {
                                                  showDialog(
                                                      context: context, 
                                                     
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: new Text(
                                                              'Error!'),
                                                          content: new Text(
                                                              'Some problem has occured. Please try again.'),
                                                          actions: <Widget>[
                                                            new FlatButton(
                                                              child: new Text(
                                                                  'close'),
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
                                                Navigator.of(context).pop();
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
                                                          'Please fill all the fields.'),
                                                      actions: <Widget>[
                                                        new FlatButton(
                                                          child:
                                                              new Text('close'),
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
                                              loading = false;
                                          },
                                        ),
                                      ],
                                    )
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
