import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahindraCSC/roles/admin/enrollUsers/enrollUsersProvider.dart';
import 'package:mahindraCSC/utilities.dart';
import 'package:provider/provider.dart';

class EditUserInfo extends StatefulWidget {
  String name;
  String email;
  bool assessorVal;
  bool assesseeVal;
  bool plantheadVal;
  String uid;

  EditUserInfo(
      {Key key,
      @required this.name,
      @required this.email,
      @required this.assessorVal,
      @required this.assesseeVal,
      @required this.plantheadVal,
      @required this.uid})
      : super(key: key);
  @override
  EditUserInfoState createState() => EditUserInfoState();
}

class EditUserInfoState extends State<EditUserInfo> {
  String _name, _email;
  bool assessorVal = false;
  bool assesseeVal = false;
  bool plantHeadVal = false;
  bool loading = false;
  bool changed = false;

  @override
  void initState() {
    _name = widget.name;
    _email = widget.email;
    assessorVal = widget.assessorVal;
    assesseeVal = widget.assesseeVal;
    plantHeadVal = widget.plantheadVal;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Utilities utilities = Utilities();
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: utilities.mainColor,
            titleSpacing: 0.0,
            automaticallyImplyLeading: false,
          ),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width * 0.625,
                child: Opacity(
                  opacity: 0.75,
                  child: Image.asset('assets/Picture2BW.png'),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width * 0.325,
                child: Card(
                  elevation: 12.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Enroll User',
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    color: Color(0xfff4001c), fontSize: 25)),
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
                            height: MediaQuery.of(context).size.height * 0.015,
                          ),
                          TextFormField(
                            initialValue: _name,
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Enter Name';
                              }
                              return null;
                            },
                            onChanged: (input) {
                              _name = input;
                              changed = true;
                            },
                            decoration: InputDecoration(
                              labelText: 'NAME',
                              labelStyle: GoogleFonts.lato(
                                textStyle: TextStyle(color: Colors.black),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                borderSide: BorderSide(),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                          ),
                          TextFormField(
                            initialValue: _email,
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Enter Email';
                              }
                              return null;
                            },
                            onChanged: (input) {
                              _email = input;
                              changed = true;
                            },
                            decoration: InputDecoration(
                              labelStyle: GoogleFonts.lato(
                                  textStyle: TextStyle(color: Colors.black)),
                              labelText: 'EMAIL',
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                borderSide: BorderSide(),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Select Role :',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(color: Colors.white),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                  value: assessorVal,
                                  onChanged: (bool value) {
                                    setState(() {
                                      assessorVal = value;
                                      changed = true;
                                    });
                                  }),
                              Text(
                                'Assessor',
                                style: GoogleFonts.lato(),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                  value: assesseeVal,
                                  onChanged: (bool value) {
                                    setState(() {
                                      assesseeVal = value;
                                      changed = true;
                                    });
                                  }),
                              Text(
                                'Assessee',
                                style: GoogleFonts.lato(),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                  value: plantHeadVal,
                                  onChanged: (bool value) {
                                    setState(() {
                                      plantHeadVal = value;
                                      changed = true;
                                    });
                                  }),
                              Text(
                                'Plant Head',
                                style: GoogleFonts.lato(),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                color: utilities.mainColor,
                                child: loading
                                    ? CircularProgressIndicator(
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          'Edit User',
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                onPressed: () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  print('editbutton pressed');
                                  if (_name != '' && _email != '') {
                                    print('fields not empty');

                                    if (changed) {
                                      print('data modified');
                                      List<String> role = [];
                                      if (assessorVal) {
                                        role.add('assessor');
                                      }
                                      if (assesseeVal) {
                                        role.add('assessee');
                                      }
                                      if (plantHeadVal) {
                                        role.add('plantHead');
                                      }
                                      try {
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(widget.uid)
                                            .update({
                                          'name': _name,
                                          'email': _email,
                                          'role': role
                                        });
                                        Navigator.of(context).pop();
                                      } catch (e) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: new Text('Error!'),
                                                content: new Text(
                                                    'Some problem has occured. Please try again.'),
                                                actions: <Widget>[
                                                  new FlatButton(
                                                    child: new Text('close'),
                                                    onPressed: () {
                                                      Navigator.of(context)
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
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: new Text('Form Incomplete'),
                                            content: new Text(
                                                'Please Enter valid Name and Email address.'),
                                            actions: <Widget>[
                                              new FlatButton(
                                                child: new Text('close'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  }
                                  setState(() {
                                    loading = false;
                                  });
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
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
// showDialog(
//                                         context: context,
//                                         builder: (BuildContext context) {
//                                           return AlertDialog(
//                                             title: new Text('Error!'),
//                                             content: new Text(
//                                                 'Some problem has occured. Please try again.'),
//                                             actions: <Widget>[
//                                               new FlatButton(
//                                                 child: new Text('close'),
//                                                 onPressed: () {
//                                                   Navigator.of(context).pop();
//                                                 },
//                                               )
//                                             ],
//                                           );
//                                         });
