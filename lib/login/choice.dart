import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mahindraCSC/roles/assessor/assessorDashboard.dart';
import 'package:mahindraCSC/roles/assessor/assessorProvider.dart';
import 'package:mahindraCSC/roles/plantHead/plantHeadDashboard.dart';
import 'package:mahindraCSC/roles/plantHead/review/plantHeadAssessmentProvider.dart';

import 'package:provider/provider.dart';
import 'package:mahindraCSC/roles/assessee/assesseeProvider.dart';
import 'package:mahindraCSC/roles/assessee/assesseeDashboard.dart';

import '../utilities.dart';

class Choice extends StatefulWidget {
  @override
  _ChoiceState createState() => _ChoiceState();
}

class _ChoiceState extends State<Choice> {
  void assesseePressed() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return ChangeNotifierProvider<AssesseeProvider>(
        create: (_) => AssesseeProvider(),
        child: AssesseeDashboard(),
      );
    }));
  }

  void assessorPressed() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return ChangeNotifierProvider<AssessorProvider>(
        create: (_) => AssessorProvider(),
        child: AssessorDashboard(),
      );
    }));
  }

  void plantHeadPressed() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return ChangeNotifierProvider<PlantProvider>(
        create: (_) => PlantProvider(),
        child: PlantHeadDashboard(),
      );
    }));
  }

  Utilities utilities = Utilities();
  List<dynamic> roles = [];
  bool loading = true;

  void getRoles() async {
    User result = await FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(result.uid)
        .get()
        .then((value) => roles = value.data()['role']);

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getRoles();

    super.initState();
  }

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
          body: Container(
            child: Center(
              child: loading
                  ? CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            'Please select the role you would like to proceed with:'),
                        SizedBox(
                          height: 10,
                        ),
                        (roles.contains('assessor'))
                            ? RaisedButton(
                                onPressed: assessorPressed,
                                child: Text('Assessor'),
                              )
                            : SizedBox(),
                        SizedBox(height: 10),
                        (roles.contains('assessee'))
                            ? RaisedButton(
                                onPressed: assesseePressed,
                                child: Text('Assessee'),
                              )
                            : SizedBox(),
                        SizedBox(height: 10),
                        (roles.contains('plantHead'))
                            ? RaisedButton(
                                onPressed: plantHeadPressed,
                                child: Text('Plant Head'),
                              )
                            : SizedBox()
                      ],
                    ),
            ),
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
