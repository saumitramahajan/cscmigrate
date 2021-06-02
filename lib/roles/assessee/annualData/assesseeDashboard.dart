import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'monthly_safety_report.dart';
import 'MonthlySafetyReportIT.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class AssesseeDashboard extends StatefulWidget {
  @override
  _AssesseeDashboardState createState() => _AssesseeDashboardState();
}

class _AssesseeDashboardState extends State<AssesseeDashboard> {
  String assesseeUid = '';
  String loc = '';
  getCurrentUser() async {
    final User user = await auth.currentUser;
    final uid = user.uid;
    // Similarly we can get email as well
    //final uemail = user.email;b
    print(uid);
    assesseeUid = uid;
    getAssesseeLocation();
    //print(uemail);
  }

  Future<String> getAssesseeLocation() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('locations');
    QuerySnapshot eventsQuery =
        await ref.where("assessee", isEqualTo: assesseeUid).get();
    loc = eventsQuery.docs[0]['category'];
    var isIT = loc.indexOf("IT");
    if (isIT == -1) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return MonthlySafetyReport();
      }));
    } else {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return MonthlySafetyReportIT();
      }));
      return loc;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assessee Dashboard'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15.0),
          children: [
            new FloatingActionButton.extended(
              onPressed: () {},
              icon: Icon(
                Icons.assignment,
              ),
              shape: RoundedRectangleBorder(),
              label: Text("Upload Annual Data"),
              heroTag: null,
            ),
            SizedBox(height: 10),
            new FloatingActionButton.extended(
              onPressed: getCurrentUser(),
              icon: Icon(
                Icons.assignment,
              ),
              shape: RoundedRectangleBorder(),
              label: Text("Monthly safety MIS"),
              heroTag: null,
            ),
            SizedBox(height: 10),
            new FloatingActionButton.extended(
              onPressed: () {},
              icon: Icon(
                Icons.assignment,
              ),
              shape: RoundedRectangleBorder(),
              label: Text("Upload Self Assessment"),
              heroTag: null,
            ),
            SizedBox(height: 10),
            new FloatingActionButton.extended(
              onPressed: () {},
              icon: Icon(
                Icons.assignment,
              ),
              shape: RoundedRectangleBorder(),
              label: Text("Sign Out"),
              heroTag: null,
            ),
          ],
        ),
      ),
    );
  }
}
