import 'package:flutter/material.dart';
import 'package:mahindraCSC/roles/admin/enrollUsers/enrollUsersProvider.dart';
import 'package:mahindraCSC/roles/admin/enrollUsers/userList.dart';
import 'package:mahindraCSC/utilities.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class EnrollUsersForm extends StatefulWidget {
  @override
  _EnrollUsersFormState createState() => _EnrollUsersFormState();
}

class _EnrollUsersFormState extends State<EnrollUsersForm> {
  String _name, _email;
  bool assessorVal = false;
  bool assesseeVal = false;
  bool plantHeadVal = false;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EnrollUsersProvider>(context);
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
            mainAxisAlignment: MainAxisAlignment.center,
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
                      child: SingleChildScrollView(
                                              child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.025,
                            ),
                            Text(
                              'Enroll User',
                              style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      color: Color(0xfff4001c), fontSize: 25)),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.075,
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
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'Enter Name';
                                }
                                return null;
                              },
                              onChanged: (input) =>
                                  _name = input,
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
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'Enter Email';
                                }
                                return null;
                              },
                              onChanged: (input) =>
                                  _email= input,
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
                                      });
                                    }),
                                Text(
                                  'Plant Head',
                                  style: GoogleFonts.lato(),
                                ),
                              ],
                            ),
                            SingleChildScrollView(
                               scrollDirection: Axis.horizontal,
                                                          child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    color: utilities.mainColor,
                                    child:provider.loading
                                        ? CircularProgressIndicator(
                                            valueColor:
                                                new AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          )
                                        :  Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              'Enroll User',
                                              style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ),
                                    onPressed: () async {
                                      if (assesseeVal ||
                                          assessorVal ||
                                          plantHeadVal) {
                                        await provider.enrollUser(_email, _name,
                                            assessorVal, assesseeVal, plantHeadVal);
                                        if (provider.enrolled) {

                                          Navigator.of(context).pop();
                                        } else {
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
                                                        Navigator.of(context).pop();
                                                      },
                                                    )
                                                  ],
                                                );
                                              });
                                        }
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: new Text('Error!'),
                                                content: new Text(
                                                    'Please select a role.'),
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
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    color: utilities.mainColor,
                                    child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              'Edit',
                                              style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ),
                                    onPressed: () async {
                                      await provider.userList();
                                      await Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ChangeNotifierProvider.value(
                                          value: provider,
                                          child: UserList(),
                                        );
                                      }));
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
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
