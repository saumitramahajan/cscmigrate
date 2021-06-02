import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mahindraCSC/login/loginForm.dart';
import 'package:mahindraCSC/login/loginProvider.dart';
import 'package:provider/provider.dart';

import '../utilities.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Utilities utilities = Utilities();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            child: Scaffold(
          appBar: AppBar(
            backgroundColor: utilities.mainColor,
          ),
          body: Center(
            child: ChangeNotifierProvider<LoginProvider>(
              create: (_) => LoginProvider(),
              child: LoginForm(),
            ),
          ),
        )),
        Positioned(
          left: 0,
          top: 0,
          child: SizedBox(
            height: AppBar().preferredSize.height * 2,
            child: Image.asset(
              'assets/mahindraAppBar.png',
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ],
    );
  }
}
