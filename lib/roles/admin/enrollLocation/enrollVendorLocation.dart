import 'package:flutter/material.dart';
import 'package:mahindraCSC/roles/admin/enrollLocation/enrollLocationProvider.dart';
import 'package:provider/provider.dart';

class EnrollVendorLocation extends StatefulWidget {
  @override
  _EnrollVendorLocationState createState() => _EnrollVendorLocationState();
}

class _EnrollVendorLocationState extends State<EnrollVendorLocation> {
  /*String _valueAssesseeUid;
  String _nameOfBusiness;
  String _location;
  String _plantHeadName;
  String _plantHeadEmail;
  String _plantHeadPhoneNumber;
  String _ssuPersonnalName;
  String _ssuPersonnalEmail;
  String _ssuPersonnalPhoneNumber;*/
  @override
  Widget build(BuildContext context) {
    final enrollProvider = Provider.of<EnrollLocationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendor Locations'),
      ),
      body: enrollProvider.loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                  /*child: Column(
                  children: [
                    TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Enter Name of Business';
                        }
                      },
                      onChanged: (value) {
                        _nameOfBusiness = value;
                      },
                      decoration:
                          InputDecoration(labelText: 'Name of Business'),
                    ),
                    TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Enter Location';
                        }
                      },
                      onChanged: (value) {
                        _location = value;
                      },
                      decoration: InputDecoration(labelText: 'Location'),
                    ),
                    Row(
                      children: [
                        Text('Assessee: '),
                        DropdownButton<String>(
                          items: enrollProvider.assessee,
                          onChanged: (value) {
                            setState(() {
                              _valueAssesseeUid = value;
                            });
                          },
                          hint: Text('Select Category'),
                          value: _valueAssesseeUid,
                        )
                      ],
                    ),
                    TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Enter Plant Head Name';
                        }
                      },
                      onChanged: (value) {
                        _plantHeadName = value;
                      },
                      decoration: InputDecoration(labelText: 'Plant Head Name'),
                    ),
                    TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Enter Plant Head Email';
                        }
                      },
                      onChanged: (value) {
                        _plantHeadEmail = value;
                      },
                      decoration:
                          InputDecoration(labelText: 'Plant Head Email'),
                    ),
                    TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Enter Plant Head Phone Number';
                        }
                      },
                      onChanged: (value) {
                        _plantHeadPhoneNumber = value;
                      },
                      decoration:
                          InputDecoration(labelText: 'Plant Head Phone Number'),
                    ),
                    TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Enter SSU Personnel Name';
                        }
                      },
                      onChanged: (value) {
                        _ssuPersonnalName = value;
                      },
                      decoration:
                          InputDecoration(labelText: 'SSU Personnel Name'),
                    ),
                    TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Enter SSU Personnel Email';
                        }
                      },
                      onChanged: (value) {
                        _ssuPersonnalEmail = value;
                      },
                      decoration:
                          InputDecoration(labelText: 'SSU Personnel Email'),
                    ),
                    TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Enter SSU Personnel Phone Number';
                        }
                      },
                      onChanged: (value) {
                        _ssuPersonnalPhoneNumber = value;
                      },
                      decoration: InputDecoration(
                          labelText: 'SSU Personnel Phone Number'),
                    ),
                    RaisedButton(
                      child: Text('Enroll'),
                      onPressed: () async {
                        await enrollProvider.enrollVendorLocation(
                            _nameOfBusiness,
                            _location,
                            _valueAssesseeUid,
                            _plantHeadName,
                            _plantHeadEmail,
                            _plantHeadPhoneNumber,
                            _ssuPersonnalName,
                            _ssuPersonnalEmail,
                            _ssuPersonnalPhoneNumber);
                        if (enrollProvider.enrolled) {
                          Navigator.of(context).pop();
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: new Text('Enroll Failed'),
                                  content: new Text(
                                      'Something has occured.Please try again later.'),
                                  actions: <Widget>[
                                    new FlatButton(
                                      child: new Text('Close'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              });
                        }
                      },
                    )
                  ],
                ),*/
                  ),
            ),
    );
  }
}
