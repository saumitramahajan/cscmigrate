import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mahindraCSC/roles/assessee/annualData/assesseeDashboard.dart';
import 'package:mahindraCSC/utilities.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  Utilities utilities = Utilities();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: utilities.mainColor,
            titleSpacing: 0.0,
            automaticallyImplyLeading: false,
          ),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width * .7,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Form(
                        autovalidate: true,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              obscureText: true,
                              controller: _password,
                              decoration: InputDecoration(
                                  labelText: 'Enter New Password'),
                            ),
                            TextFormField(
                              obscureText: true,
                              controller: _confirmPassword,
                              decoration: InputDecoration(
                                labelText: 'Confirm New Password',
                              ),
                              validator: (value) {
                                if (value != _password.text) {
                                  return 'Passwords does not match';
                                }
                                return null;
                              },
                            ),
                            RaisedButton(
                              child: Text('Change Password'),
                              onPressed: () async {
                                if (_password.text == _confirmPassword.text) {
                                  User user =
                                      await FirebaseAuth.instance.currentUser;
                                  user
                                      .updatePassword(_password.text)
                                      .then((value) {
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                      builder: (context) => AssesseeDashboard(),
                                    ));
                                  });
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
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
