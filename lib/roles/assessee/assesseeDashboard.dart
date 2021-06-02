import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mahindraCSC/assessments/siteAssessment/siteAssessment.dart';
import 'package:mahindraCSC/login/login.dart';
import 'package:mahindraCSC/roles/assessee/assesseeClosedAssessmentBase.dart';
import 'package:mahindraCSC/roles/assessee/assesseeClosedProvider.dart';
import 'package:mahindraCSC/roles/assessee/assesseeProvider.dart';
import 'package:mahindraCSC/roles/assessee/changePassword/changePassword.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:mahindraCSC/roles/assessee/review/assesseeNewProvider.dart';
import 'package:mahindraCSC/roles/assessee/review/location.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utilities.dart';
import 'annualData/AnnualSafetyReportIT.dart';
import 'annualData/annual_safety_report.dart';

class AssesseeDashboard extends StatefulWidget {
  @override
  _AssesseeDashboardState createState() => _AssesseeDashboardState();
}

class _AssesseeDashboardState extends State<AssesseeDashboard> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String assesseeUid = '';
  String loc = '';

  getCurrentUser(String type) async {
    final User user = await auth.currentUser;
    final uid = user.uid;
    // Similarly we can get email as well
    //final uemail = user.email;b
    print(uid);
    assesseeUid = uid;
    getAssesseeLocation(type);
    //print(uemail);
  }

  Future<void> getAssesseeLocation(String type) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('locations');
    QuerySnapshot eventsQuery =
        await ref.where("assessee", isEqualTo: assesseeUid).get();
    loc = eventsQuery.docs[0]['category'];

    if (type == 'assessment') {
      String cycleId;
      await FirebaseFirestore.instance
          .collection('cycles')
          .where('assesseeUid', isEqualTo: assesseeUid)
          .get()
          .then((cyclesQS) {
        cycleId = cyclesQS.docs[0].id;
      });
      var isIT = loc.indexOf("IT");
      if (isIT == -1) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return AnnualySafetyReport(
            type: type,
            cycleId: cycleId,
          );
        }));
      } else {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return AnnualySafetyReportIT(
            type: type,
            cycleId: cycleId,
          );
        }));
      }
    } else {
      String locationId = eventsQuery.docs[0].id;
      print(locationId);
      var isIT = loc.indexOf("IT");
      if (isIT == -1) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return AnnualySafetyReport(
            type: type,
            locationId: locationId,
          );
        }));
      } else {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return AnnualySafetyReportIT(
            type: type,
            locationId: locationId,
          );
        }));
      }
    }
  }

  Utilities utilities = Utilities();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssesseeProvider>(context);
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
                    getCurrentUser('monthly');
                  },
                  child: Text(
                    'Monthly MIS',
                    style: TextStyle(color: Colors.white),
                  )),
              FlatButton(
                  onPressed: () async {
                    String cycleid = await provider.getLocationName();
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SiteAssessment('self', cycleid),
                    ));
                  },
                  child: Text(
                    'Self Assessment',
                    style: TextStyle(color: Colors.white),
                  )),

                  //  FlatButton(
                  // onPressed: () async {
                  //      Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) {
                  //       return ChangeNotifierProvider<AssesseeNewProvider>(
                  //         create: (_) => AssesseeNewProvider('self'),
                  //         child: Locations(),
                  //       );
                  //     }),
                  //   );
                  // },
                  // child: Text(
                  //   'Review Self Assessment',
                  //   style: TextStyle(color: Colors.white),
                  // )),
                   FlatButton(
                  onPressed: () async {
                   Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ChangeNotifierProvider<AssesseeClosedProvider>(
                          create: (_) => AssesseeClosedProvider(),
                          child: AssesseeClosedBase(),
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
              /*FlatButton(
              onPressed: () {
                getCurrentUser('assessment');
              },
              child: Text(
                'Annual Data',
                style: TextStyle(color: Colors.white),
              )),*/ //Uncomment when annual data is required. place inbetween
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
                  child: SizedBox(height: 50),
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
        )
      ],
    );
  }
}
