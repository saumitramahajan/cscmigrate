import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mahindraCSC/login/login.dart';

import 'package:mahindraCSC/roles/plantHead/review/plantHeadAssessmentProvider.dart';
import 'package:mahindraCSC/roles/plantHead/review/selfAssessment.dart';
import 'package:mahindraCSC/utilities.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlantHeadDashboard extends StatefulWidget {
  @override
  _PlantHeadDashboardState createState() => _PlantHeadDashboardState();
}

class _PlantHeadDashboardState extends State<PlantHeadDashboard> {
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
                  onPressed: () {},
                  child: Text(
                    'DownLoad Report',
                    style: TextStyle(color: Colors.white),
                  )),
              FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ChangeNotifierProvider<PlantProvider>(
                          create: (_) => PlantProvider(),
                          child: PlantHeadAssessment(),
                        );
                      }),
                    );
                  },
                  child: Text(
                    'Approve Assessment',
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
