import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mahindraCSC/login/login.dart';

import 'package:mahindraCSC/roles/assessor/changePassword/changePassword.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:mahindraCSC/roles/assessor/review/assessmentProvider.dart';
import 'package:mahindraCSC/roles/assessor/review/closedAssessmentBase.dart';
import 'package:mahindraCSC/roles/assessor/review/closedAssessmentProvider.dart';
import 'package:mahindraCSC/roles/assessor/review/locations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utilities.dart';
import 'assessment/assessorlocationListBase.dart';

class AssessorDashboard extends StatefulWidget {
  @override
  _AssessorDashboardState createState() => _AssessorDashboardState();
}

class _AssessorDashboardState extends State<AssessorDashboard> {
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
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AssessorLocationInfoBase()));
                  },
                  child: Text(
                    'Site Assessment',
                    style: TextStyle(color: Colors.white),
                  )),
              FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ChangeNotifierProvider<AssessmentProvider>(
                          create: (_) => AssessmentProvider('site'),
                          child: Locations(),
                        );
                      }),
                    );
                  },
                  child: Text(
                    'Review (Co-Assessor) Site Assessment',
                    style: TextStyle(color: Colors.white),
                  )),
              FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ChangeNotifierProvider<AssessmentProvider>(
                          create: (_) => AssessmentProvider('self'),
                          child: Locations(),
                        );
                      }),
                    );
                  },
                  child: Text(
                    'Review Self Assessment',
                    style: TextStyle(color: Colors.white),
                  )),

                  FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ChangeNotifierProvider<ClosedAssessmentProvider>(
                          create: (_) => ClosedAssessmentProvider(),
                          child: ClosedAssessmentBase(),
                        );
                      }),
                    );
                  },
                  child: Text(
                    'Closed Assessment',
                    style: TextStyle(color: Colors.white),
                  )),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChangePassword(),
                    ));
                  },
                  child: Text(
                    'Change Password',
                    style: TextStyle(color: Colors.white),
                  )),
              FlatButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.clear();

                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Login(),
                    ));
                  },
                  child: Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.white),
                  )),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
              )
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/background.jpg"),
                    fit: BoxFit.fitWidth)),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 50.0,
                  ),
                ),
                SliverToBoxAdapter(
                    child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Carousel(
                      boxFit: BoxFit.fitHeight,
                      images: [
                        AssetImage('assets/Picture1.png'),
                        AssetImage('assets/Picture2.png'),
                        AssetImage('assets/Picture3.png'),
                      ],
                      autoplay: true,
                      indicatorBgPadding: 0,
                      dotBgColor: Colors.transparent),
                )),
              ],
            ),
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
