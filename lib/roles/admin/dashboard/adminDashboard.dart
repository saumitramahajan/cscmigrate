import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mahindraCSC/login/login.dart';
import 'package:mahindraCSC/roles/admin/annualData/annualDataLocations.dart';
import 'package:mahindraCSC/roles/admin/annualData/annualDataProvider.dart';
import 'package:mahindraCSC/roles/admin/changePassword/changePassword.dart';
import 'package:mahindraCSC/roles/admin/changeStatus/changeProvider.dart';
import 'package:mahindraCSC/roles/admin/changeStatus/changeStatusBase.dart';

import 'package:mahindraCSC/roles/admin/enrollLocation/enrollLoacation.dart';
import 'package:mahindraCSC/roles/admin/enrollUsers/enrollUsers.dart';
import 'package:mahindraCSC/roles/admin/pdfTrial.dart';
import 'package:mahindraCSC/roles/admin/review/assessmentProvider.dart';
import 'package:mahindraCSC/roles/admin/review/locations.dart';
import 'package:mahindraCSC/roles/admin/scheduleAssessment/closed/closedBase.dart';
import 'package:mahindraCSC/roles/admin/scheduleAssessment/closed/closedProvider.dart';
import 'package:mahindraCSC/roles/admin/scheduleAssessment/scheduledAssessmentInfo/scheduledAssessmentInfoBase.dart';
import 'package:mahindraCSC/roles/admin/scheduleAssessment/scheduledAssessmentInfo/scheduledInfoProvider.dart';
import 'package:mahindraCSC/roles/assessee/annualData/annual_safety_report.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utilities.dart';
import '../scheduleAssessment/scheduleAssessment.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'dart:html' as html;

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int total = 0;
  int self = 0;
  int site = 0;
  int closed = 0;
  String currentStatus;
  bool loading = true;
  getCsv(List<List<String>> rows) async {
    String csv = const ListToCsvConverter().convert(rows);

    final bytes = csv;
    final blob = html.Blob([bytes], 'report/csv');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'finalReport.csv';
    html.document.body.children.add(anchor);
    anchor.click();
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
    // if (await canLaunch(url)) await launch(url);
    // html.window.open(url, "_blank");
    // html.Url.revokeObjectUrl(url);
  }

  levelsCSV(List<List<String>> rows) async {
    String csv = const ListToCsvConverter().convert(rows);

    final bytes = csv;
    final blob = html.Blob([bytes], 'report1/csv');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'Levels Report.csv';
    html.document.body.children.add(anchor);
    anchor.click();
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
    // if (await canLaunch(url)) await launch(url);
    // html.window.open(url, "_blank");
    // html.Url.revokeObjectUrl(url);
  }

  Future<void> getAssessmentNumbers() async {
    total = 0;
    self = 0;
    site = 0;
    closed = 0;

    firestoreInstance.collection('cycles').snapshots().listen((event) {
      print(event.toString());
      total = 0;
      self = 0;
      site = 0;
      closed = 0;
      for (int i = 0; i < event.docs.length; i++) {
        currentStatus = event.docs[i].data()['currentStatus'];

        total++;

        switch (currentStatus) {
          case 'Approved by PlantHead':
            {
              self++;
            }
            break;
          case 'Self Assessment Uploaded':
            {
              self++;
            }
            break;

          case 'Closed':
            {
              closed++;
              self++;
              site++;
            }

            break;
          case 'Approved by CoAssessor':
            {
              site++;
              self++;
            }
            break;
        }
      }

      setState(() {});
    });
    setState(() {
      loading = false;
    });
    print('total' + total.toString());
  }

  Future<List<Map<String, String>>> levels() async {
    List<Map<String, String>> levelList = [];

    QuerySnapshot levels =
        await FirebaseFirestore.instance.collection('locations').get();
    for (int i = 0; i < levels.docs.length; i++) {
      Map<String, String> locationMap = {};
      locationMap['nameOfSector'] = levels.docs[i].data()['nameOfSector'];
      locationMap['location'] = levels.docs[i].data()['location'];
      locationMap['processLevel'] = levels.docs[i].data()['processLevel'];
      locationMap['resultLevel'] = levels.docs[i].data()['resultLevel'];
      locationMap['lastAssessmentStage'] =
          levels.docs[i].data()['lastAssessmentStage'];
      String levelString = levels.docs[i].data()['nameOfSector'];
      int index = levelList.lastIndexWhere((element) =>
          element['nameOfSector'] == levels.docs[i].data()['nameOfSector'] ||
          element['nameOfSector']
              .contains(levels.docs[i].data()['nameOfSector']) ||
          levelString.contains(element['nameOfSector']));
      if (index == -1) {
        levelList.add(locationMap);
      } else {
        levelList.insert(index + 1, locationMap);
      }

      print(levelList.toString());
    }
    return levelList;
  }

  Future<List<Map<String, String>>> locations() async {
    List<Map<String, String>> locationList = [];
    String locationString;
    QuerySnapshot location =
        await FirebaseFirestore.instance.collection('cycles').get();
    for (int i = 0; i < location.docs.length; i++) {
      Map<String, String> locationMap = {};
      locationMap['nameOfSector'] = location.docs[i].data()['name'];
      locationMap['location'] = location.docs[i].data()['location'];
      if (location.docs[i].data().containsKey('siteAssessment')) {
        List<Map<String, dynamic>> siteAssessment =
            location.docs[i].data()['siteAssessment'];
        for (int j = 0; j < siteAssessment.length; j++) {
          locationMap['parameter$j'] = siteAssessment[j]['level'];
        }
      }
      locationString = location.docs[i].data()['name'];
      int index = locationList.lastIndexWhere((element) =>
          element['nameOfSector'] == location.docs[i].data()['name'] ||
          element['nameOfSector'].contains(location.docs[i].data()['name']) ||
          locationString.contains(element['nameOfSector']));
      if (index == -1) {
        locationList.add(locationMap);
      } else {
        locationList.insert(index + 1, locationMap);
      }
    }
    print(locationList.toString());
    return locationList;
  }

  Future<List<Map<String, String>>> getStatements() async {
    List<Map<String, String>> listOfStatement = [];

    QuerySnapshot statement =
        await FirebaseFirestore.instance.collection('siteAssessment').get();
    for (int i = 0; i < statement.docs.length; i++) {
      Map<String, String> map = {};

      map['statement'] = statement.docs[i].data()['statement'];

      listOfStatement.add(map);
    }
    print(listOfStatement.toString());
    return listOfStatement;
  }

  @override
  void initState() {
    getAssessmentNumbers();

    super.initState();
  }

  Utilities utilities = Utilities();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: Scaffold(
            endDrawer: Drawer(
              child: Container(
                color: utilities.mainColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(
                        'Enroll',
                        style: TextStyle(color: Colors.white),
                      ),
                      dense: false,
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return EnrollUsers();
                          },
                        ));
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Enroll Location',
                        style: TextStyle(color: Colors.white),
                      ),
                      dense: false,
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return EnrollLocation();
                          },
                        ));
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Edit Location',
                        style: TextStyle(color: Colors.white),
                      ),
                      dense: false,
                      onTap: () async {
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Schedule Assessment',
                        style: TextStyle(color: Colors.white),
                      ),
                      dense: false,
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return ScheduleAssessment();
                          },
                        ));
                      },
                    ),
                    /* ListTile(
                title: Text(
                  'Review Annual Data',
                  style: TextStyle(color: Colors.white),
                ),
                dense: false,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return AnnualData();
                    },
                  ));
                },
              ),*/
                    ExpansionTile(
                      title: Text(
                        'Review Self and Site Assessment',
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing:
                          Icon(Icons.arrow_drop_down, color: Colors.white),
                      expandedAlignment: Alignment.centerLeft,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FlatButton(
                                onPressed: () {
                                  // Navigator.of(context).pop();
                                  Navigator.pushNamed(
                                      context, '/selfAssessmentReview');
                                },
                                child: Text(
                                  'Self Assessment',
                                  style: TextStyle(color: Colors.white),
                                )),
                            IconButton(
                                icon: Icon(Icons.open_in_new),
                                color: Colors.white,
                                onPressed: () async {
                                  if (await canLaunch(
                                      'https://themahindrasafetyway.com/#/selfAssessmentReview'))
                                    await launch(
                                        'https://themahindrasafetyway.com/#/selfAssessmentReview');
                                })
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FlatButton(
                                onPressed: () async {
                                  //Navigator.of(context).pop();
                                  Navigator.pushNamed(
                                      context, '/siteAssessmentReview');
                                },
                                child: Text(
                                  'Site Assessment',
                                  style: TextStyle(color: Colors.white),
                                )),
                            IconButton(
                                icon: Icon(Icons.open_in_new),
                                color: Colors.white,
                                onPressed: () async {
                                  if (await canLaunch(
                                      'https://themahindrasafetyway.com/#/siteAssessmentReview'))
                                    await launch(
                                        'https://themahindrasafetyway.com/#/siteAssessmentReview');
                                })
                          ],
                        ),
                      ],
                    ),
                    ListTile(
                      title: Text(
                        'Annual Data',
                        style: TextStyle(color: Colors.white),
                      ),
                      dense: false,
                      onTap: () async {
                        Navigator.of(context).pop();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ChangeNotifierProvider<AnnualDataProvider>(
                            create: (_) => AnnualDataProvider(),
                            child: AnnualDataBase(),
                          );
                        }));
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Change Status',
                        style: TextStyle(color: Colors.white),
                      ),
                      dense: false,
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ChangeNotifierProvider<ChangeStatusProvider>(
                            create: (_) => ChangeStatusProvider(),
                            child: ChangeStatusBase(),
                          );
                        }));
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Change Password',
                        style: TextStyle(color: Colors.white),
                      ),
                      dense: false,
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return ChangePassword();
                          },
                        ));
                      },
                    ),
                    ExpansionTile(
                      title: Text(
                        'Download Cumulative Report',
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing:
                          Icon(Icons.arrow_drop_down, color: Colors.white),
                      expandedAlignment: Alignment.centerLeft,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FlatButton(
                                onPressed: () async {
                                  // Navigator.of(context).pop();

                                  List<Map<String, String>> location =
                                      await locations();
                                  List<Map<String, dynamic>> listOfStatements =
                                      await getStatements();

                                  List<List<String>> rows = [];
                                  rows = List.generate(listOfStatements.length,
                                      (index) {
                                    List<String> row = [];
                                    row.add(
                                        listOfStatements[index]['statement']);
                                    for (int i = 0; i < location.length; i++) {
                                      row.add(location[i]['parameter$index'] ??
                                          'NU');
                                    }

                                    return row;
                                  });

                                  List<String> sectors =
                                      List.generate(location.length, (index) {
                                    return location[index]['nameOfSector'];
                                  });

                                  sectors.insert(0, ' ');

                                  List<String> locas = List.generate(
                                      location.length,
                                      (index) => location[index]['location']);

                                  locas.insert(0, ' ');

                                  rows.insert(0, locas);
                                  rows.insert(0, sectors);

                                  getCsv(rows);
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Cumulative Report',
                                  style: TextStyle(color: Colors.white),
                                )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FlatButton(
                                onPressed: () async {
                                  //Navigator.of(context).pop();

                                  List<Map<String, String>> level =
                                      await levels();

                                  List<List<String>> rows = [
                                    [
                                      'Name',
                                      'Location',
                                      'Last Assessment Stage',
                                      'Process Level',
                                      'Result Level'
                                    ]
                                  ];
                                  for (int i = 0; i < level.length; i++) {
                                    List<String> row = [
                                      level[i]['nameOfSector'],
                                      level[i]['location'],
                                      level[i]['lastAssessmentStage'],
                                      level[i]['processLevel'],
                                      level[i]['resultLevel']
                                    ];
                                    rows.add(row);
                                  }
                                  levelsCSV(rows);
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Levels Report',
                                  style: TextStyle(color: Colors.white),
                                )),
                          ],
                        ),
                      ],
                    ),
                    ListTile(
                      title: Text(
                        'Sign Out',
                        style: TextStyle(color: Colors.white),
                      ),
                      dense: false,
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.clear();
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => Login(),
                        ));
                      },
                    ),
                  ],
                ),
              ),
            ),
            appBar: AppBar(
              backgroundColor: utilities.mainColor,
              titleSpacing: 0.0,
              automaticallyImplyLeading: false,
            ),
            body: loading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/background.jpg"),
                            fit: BoxFit.fitWidth)),
                    child: CustomScrollView(
                      slivers: [
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
                        SliverGrid.count(
                            crossAxisCount: 4,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                            childAspectRatio: 2.5,
                            children: [
                              GestureDetector(
                                child: Container(
                                  color: Colors.green[50],
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                                  child: Column(
                                    children: [
                                      Text('Scheduled Assessment: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                      Text(total.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 70))
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return ChangeNotifierProvider<
                                          ScheduledAssessmentInfoProvider>(
                                        create: (_) =>
                                            ScheduledAssessmentInfoProvider(),
                                        child: ScheduleAssessmentInfoBase(),
                                      );
                                    }),
                                  );
                                },
                              ),
                              GestureDetector(
                                child: Container(
                                  color: Colors.green[100],
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                                  child: Column(
                                    children: [
                                      Text('Self Assessment Uploaded: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                      Text(self.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 70))
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ChangeNotifierProvider<
                                        AssessmentProvider>(
                                      create: (_) => AssessmentProvider('self'),
                                      child: Locations(),
                                    );
                                  }));
                                },
                              ),
                              GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                                  color: Colors.green[200],
                                  child: Column(
                                    children: [
                                      Text('Site Assessment Uploaded: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                      Text(site.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 70))
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ChangeNotifierProvider<
                                        AssessmentProvider>(
                                      create: (_) => AssessmentProvider('site'),
                                      child: Locations(),
                                    );
                                  }));
                                },
                              ),
                              GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                                  color: Colors.green[300],
                                  child: Column(
                                    children: [
                                      Text('Closed: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                      Text(closed.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 70))
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return ChangeNotifierProvider<
                                          ClosedProvider>(
                                        create: (_) => ClosedProvider(),
                                        child: ClosedBase(),
                                      );
                                    }),
                                  );
                                },
                              )
                            ])
                      ],
                    ),
                  ),
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          child: SizedBox(
            height: AppBar().preferredSize.height * 2,
            child: Image.asset(
              'assets/mahindraAppBar.png',
              fit: BoxFit.contain,
            ),
          ),
        )
      ],
    );
  }
}
