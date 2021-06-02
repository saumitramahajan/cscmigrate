import 'package:flutter/material.dart';
import 'package:mahindraCSC/login/choice.dart';
import 'package:mahindraCSC/login/loginProvider.dart';
import 'package:mahindraCSC/login/resetPassword.dart';
import 'package:mahindraCSC/roles/plantHead/plantHeadDashboard.dart';
import 'package:mahindraCSC/roles/plantHead/plantHeadProvider.dart';
import '../roles/admin/dashboard/adminDashboard.dart';
import '../roles/admin/dashboard/adminProvider.dart';
import 'package:mahindraCSC/roles/assessee/assesseeDashboard.dart';
import 'package:mahindraCSC/roles/assessee/assesseeProvider.dart';
import 'package:mahindraCSC/roles/assessor/assessorDashboard.dart';
import 'package:mahindraCSC/roles/assessor/assessorProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import '../utilities.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _email = '', _password = '';
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Utilities utilities = Utilities();

  void login(LoginProvider loginProvider) async {
    await loginProvider.loginProvider(_email, _password);
    if (loginProvider.userExists) {
      if (loginProvider.singleRole) {
        switch (loginProvider.roleString) {
          case 'admin':
            {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return ChangeNotifierProvider<AdminProvider>(
                  create: (_) => AdminProvider(),
                  child: AdminDashboard(),
                );
              }));
            }
            break;
          case 'assessee':
            {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return ChangeNotifierProvider<AssesseeProvider>(
                  create: (_) => AssesseeProvider(),
                  child: AssesseeDashboard(),
                );
              }));
            }
            break;
          case 'assessor':
            {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return ChangeNotifierProvider<AssessorProvider>(
                  create: (_) => AssessorProvider(),
                  child: AssessorDashboard(),
                );
              }));
            }
            break;
          case 'plantHead':
            {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return ChangeNotifierProvider<PlantHeadProvider>(
                  create: (_) => PlantHeadProvider(),
                  child: PlantHeadDashboard(),
                );
              }));
            }
            break;
        }
      } else {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return Choice();
        }));
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text('Email not Registered'),
              content: new Text(
                  'Please contact to admin at themahindrasafetyway@mahindra.com'),
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
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/Picture2BW.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .1,
          ),
          Card(
            elevation: 7.0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.width * .1,
                    child: Image.asset(
                      'assets/101.png',
                      fit: BoxFit.contain,
                    )),
                Divider(
                  thickness: 20.0,
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  width: MediaQuery.of(context).size.width * .35,
                  height: MediaQuery.of(context).size.height * .55,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .2,
                            child: Image.asset(
                              'assets/TMSW.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          TextFormField(
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Please type an email';
                              }
                              return null;
                            },
                            onChanged: (input) => _email = input,
                            decoration: InputDecoration(
                                labelText: 'Email', icon: Icon(Icons.email)),
                            onFieldSubmitted: (val) {
                              if (_email != '' && _password != '') {
                                login(loginProvider);
                              }
                            },
                          ),
                          TextFormField(
                            validator: (input) {
                              if (input.length < 6) {
                                return 'Your password needs to be atleast 6 characters';
                              }
                              return null;
                            },
                            onChanged: (input) => _password = input,
                            decoration: InputDecoration(
                                labelText: 'Password', icon: Icon(Icons.lock)),
                            obscureText: true,
                            onFieldSubmitted: (val) {
                              if (_email != '' && _password != '') {
                                login(loginProvider);
                              }
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              color: utilities.mainColor,
                              child: loginProvider.loading
                                  ? CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.white),
                                    )
                                  : Text('Login',
                                      style: TextStyle(
                                        color: Colors.white,
                                      )),
                              onPressed: () async {
                                if (_email != '' && _password != '') {
                                  login(loginProvider);
                                }
                              }),
                          SizedBox(
                            height: 7.0,
                          ),
                          GestureDetector(
                            child: Text('Forgot Password/New User'),
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return ChangeNotifierProvider.value(
                                  value: loginProvider,
                                  child: ResetPassword(),
                                );
                              }));
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
