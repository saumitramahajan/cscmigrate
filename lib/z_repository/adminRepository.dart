import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class AdminRepository {
  Future<String> registerUser(String email) async {
    UserCredential result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: 'mahindra');

    return result.user.uid;
  }

  Future<List<Map<String, dynamic>>> userList() async {
    List<Map<String, dynamic>> userList = [];

    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) => value.docs.forEach((element) {
              Map<String, dynamic> map = element.data();
              map['documentId'] = element.id;
              userList.add(map);
            }));
    return userList;
  }

  Future<void> roles(String uid) async {
    List<bool> role = [false, false, false];
    role[0] = role.contains('assessor');
    role[1] = role.contains('assessee');
    role[2] = role.contains('plantHead');
    await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  Future<void> uploadUserInfo(String email, String uid, String name,
      bool assessorVal, bool assesseeVal, bool plantHeadVal) async {
    List<String> role = [];
    if (assessorVal) {
      role.add('assessor');
    }
    if (assesseeVal) {
      role.add('assessee');
    }
    if (plantHeadVal) {
      role.add('plantHead');
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({'name': name, 'email': email, 'role': role, 'uid': uid});
  }

  Future<void> editUserInfo(String name, String email, bool assessorVal,
      bool assesseeVal, bool plantHeadVal, String documentId) async {
    List<String> role = [];
    if (assessorVal) {
      role.add('assessor');
    }
    if (assesseeVal) {
      role.add('assessee');
    }
    if (plantHeadVal) {
      role.add('plantHead');
    }
    await FirebaseFirestore.instance
        .collection('cycles')
        .doc(documentId)
        .update({'name': name, 'email': email, 'role': role});
  }

  Future<List<Map<String, String>>> getAssesseeMap() async {
    List<Map<String, String>> assesseeList = [];
    await FirebaseFirestore.instance
        .collection('users')
        .orderBy('name')
        .get()
        .then((QuerySnapshot assessee) {
      assessee.docs.forEach((element) {
        List<dynamic> roles = element['role'];
        if (roles.contains('assessee')) {
          Map<String, String> assesseeMap = {
            'Name': element.data()['name'],
            'Email': element.data()['email'],
            'uid': element.id
          };

          assesseeList.add(assesseeMap);
        }
      });
    });

    return assesseeList;
  }

  Future<List<Map<String, String>>> getPlantHeadMap() async {
    List<Map<String, String>> plantHeadList = [];
    await FirebaseFirestore.instance
        .collection('users')
        .orderBy('name')
        .get()
        .then((QuerySnapshot plantHead) {
      plantHead.docs.forEach((element) {
        List<dynamic> roles = element['role'];
        if (roles.contains('plantHead')) {
          Map<String, String> assesseeMap = {
            'Name': element.data()['name'],
            'Email': element.data()['email'],
            'uid': element.id
          };

          plantHeadList.add(assesseeMap);
        }
      });
    });

    return plantHeadList;
  }

  Future<List<Map<String, String>>> getLocationMap() async {
    List<Map<String, String>> locationList = [];
    await FirebaseFirestore.instance
        .collection('locations')
        .get()
        .then((QuerySnapshot location) {
      location.docs.forEach((element) {
        Map<String, String> locationMap = {};
        if (element.data()['typeOfLocation'] == 'mahindra') {
          locationMap = getMahindraMap(element);
        } else {
          locationMap = getVendorMap(element);
        }

        locationList.add(locationMap);
      });
    });
    locationList = await getNames(locationList);
    return locationList;
  }

  Future<List<Map<String, String>>> getNames(
      List<Map<String, String>> oldList) async {
    List<Map<String, String>> newList = oldList;
    for (int i = 0; i < oldList.length; i++) {
      String name = await getAssesseeName(oldList[i]['assessee']);
      newList[i].remove('assessee');
      newList[i]['assessee'] = name;
    }
    return newList;
  }

  Future<String> getAssesseeName(String uid) async {
    String name = '';
    DocumentSnapshot data =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    name = data.data()['name'];

    return name;
  }

  Map<String, String> getMahindraMap(DocumentSnapshot document) {
    Map<String, String> map = {
      'typeOfLocation': 'mahindra',
      'category': document.data()['category'],
      'nameOfSector': document.data()['nameOfSector'],
      'location': document.data()['location'],
      'lastAssessmentStage': document.data()['lastAssessmentStage'],
      'processLevel': document.data()['processLevel'],
      'resultLevel': document.data()['resultLevel'],
      'assessee': document.data()['assessee'],
      'plantHeadName': document.data()['plantHeadName'],
      'plantHeadEmail': document.data()['plantHeadEmail'],
      'plantHeadPhoneNumber': document.data()['plantHeadPhoneNumber'],
      'spocName': document.data()['sectorBusinessSafetySpocName'],
      'spocEmail': document.data()['sectorBusinessSafetySpocEmail'],
      'spocPhoneNumber': document.data()['sectorBusinessSafetySpocPhoneNumber'],
      'documentId': document.id,
    };
    return map;
  }

  Map<String, String> getVendorMap(DocumentSnapshot document) {
    Map<String, String> map = {
      'typeOfLocation': 'vendor',
      'nameOfBusiness': document.data()['nameOfBusiness'],
      'location': document.data()['location'],
      'assessee': document.data()['assessee'],
      'plantHeadName': document.data()['plantHeadName'],
      'plantHeadEmail': document.data()['plantHeadEmail'],
      'plantHeadPhoneNumber': document.data()['plantHeadPhoneNumber'],
      'personnelName': document.data()['ssuPersonnelName'],
      'personnelEmail': document.data()['ssuPersonnelEmail'],
      'personnelPhoneNumber': document.data()['ssuPersonnelPhoneNumber'],
    };
    return map;
  }

  Future<void> upload(
      String point1,
      String point2,
      String point3,
      String point4,
      String point5,
      String wayForward1,
      String wayForwward2,
      String documentId) async {
    await FirebaseFirestore.instance
        .collection('cycles')
        .doc(documentId)
        .update({
      'sitePoint1': point1,
      'sitePoint2': point2,
      'sitePoint3': point3,
      'sitePoint4': point4,
      'sitePoint5': point5,
      'wayForward1': wayForward1,
      'wayForward2': wayForwward2,
    });
  }

  Future<void> mahindraLocationEnroll(
      String category,
      String nameOfSector,
      String nameOfBusiness,
      String location,
      String lastAssessmentStage,
      String processLevel,
      String resultLevel,
      String assessee,
      String plantHead,
      String plantHeadName,
      String plantHeadEmail,
      String sectorBusinessSafetySpocName,
      String sectorBusinessSafetySpocEmail) async {
    await FirebaseFirestore.instance.collection('locations').doc().set({
      'typeOfLocation': 'mahindra',
      'category': category,
      'nameOfSector': nameOfSector,
      'nameOfBusiness': nameOfBusiness,
      'location': location,
      'lastAssessmentStage': lastAssessmentStage,
      'processLevel': processLevel,
      'resultLevel': resultLevel,
      'assessee': assessee,
      'plantHead': plantHead,
      'plantHeadName': plantHeadName,
      'plantHeadEmail': plantHeadEmail,
      'sectorBusinessSafetySpocName': sectorBusinessSafetySpocName,
      'sectorBusinessSafetySpocEmail': sectorBusinessSafetySpocEmail,
    });
  }

  Future<void> vendorLocationEnroll(
      String nameOfBusiness,
      String location,
      String assessee,
      String plantHeadName,
      String plantHeadEmail,
      String plantHeadPhoneNumber,
      String ssuPersonnelName,
      String ssuPersonnelEmail,
      String ssuPersonnelPhoneNUmber) async {
    await FirebaseFirestore.instance.collection('locations').doc().set({
      'typeOfLocation': 'vendor',
      'nameOfBusiness': nameOfBusiness,
      'location': location,
      'assessee': assessee,
      'plantHeadName': plantHeadName,
      'plantHeadEmail': plantHeadEmail,
      'plantHeadPhoneNumber': plantHeadPhoneNumber,
      'ssuPersonnelName': ssuPersonnelName,
      'ssuPersonnelEmail': ssuPersonnelEmail,
      'ssuPersonnelPhoneNumber': ssuPersonnelPhoneNUmber
    });
  }

  Future<List<Map<String, String>>> getLocationList() async {
    print('Started');
    List<Map<String, String>> locationMap = [];
    QuerySnapshot locations = await FirebaseFirestore.instance
        .collection('locations')
        .orderBy('nameOfSector')
        .get();

    for (int i = 0; i < locations.docs.length; i++) {
      Map<String, String> location = {};
      if (locations.docs[i]['typeOfLocation'] == 'vendor') {
        location['documentID'] = locations.docs[i].id;
        location['typeOfLocation'] = locations.docs[i]['typeOfLocation'];
        location['assessee'] =
            await getAssesseeName(locations.docs[i]['assessee']);
        location['assesseeId'] = locations.docs[i]['assessee'];
        location['location'] = locations.docs[i]['location'];
        location['nameOfBusiness'] = locations.docs[i]['nameOfBusiness'];
        location['plantHeadEmail'] = locations.docs[i]['plantHeadEmail'];
        location['plantHeadName'] = locations.docs[i]['plantHeadName'];
        location['plantHeadPhoneNumber'] =
            locations.docs[i]['plantHeadPhoneNumber'];
        location['ssuPersonnelEmail'] =
            locations.docs[i]['ssuPersonnelEmail'];
        location['ssuPersonnelName'] =
            locations.docs[i]['ssuPersonnelName'];
        location['ssuPersonnelPhoneNumber'] =
            locations.docs[i]['ssuPersonnelPhoneNumber'];
      } else {
        location['documentID'] = locations.docs[i].id;
        location['typeOfLocation'] = locations.docs[i]['typeOfLocation'];
        location['assessee'] =
            await getAssesseeName(locations.docs[i]['assessee']);
        location['assesseeId'] = locations.docs[i]['assessee'];
        location['location'] = locations.docs[i]['location'];
        location['nameOfSector'] = locations.docs[i]['nameOfSector'];
        location['plantHeadEmail'] = locations.docs[i]['plantHeadEmail'];
        location['plantHeadName'] = locations.docs[i]['plantHeadName'];

        location['sectorBusinessSafetySpocEmail'] =
            locations.docs[i]['sectorBusinessSafetySpocEmail'];
        location['sectorBusinessSafetySpocName'] =
            locations.docs[i]['sectorBusinessSafetySpocName'];

        location['category'] = locations.docs[i]['category'];
        location['lastAssessmentStage'] =
            locations.docs[i]['lastAssessmentStage'];
        location['nameOfSector'] = locations.docs[i]['nameOfSector'];
        location['processLevel'] = locations.docs[i]['processLevel'];
        location['resultLevel'] = locations.docs[i]['resultLevel'];
      }

      locationMap.add(location);
    }
    return locationMap;
  }

  Future<String> getAssessor(String assessorUid) async {
    String name = '';
    DocumentSnapshot userName = await FirebaseFirestore.instance
        .collection('users')
        .doc(assessorUid)
        .get();
    name = userName.data()['name'];

    return name;
  }

  Future<String> getCoAssessor(String coAssessorUid) async {
    String name = '';
    DocumentSnapshot userName = await FirebaseFirestore.instance
        .collection('users')
        .doc(coAssessorUid)
        .get();
    name = userName.data()['name'];

    return name;
  }

  Future<String> getPlantHead(String plantHeadUid) async {
    String name = '';

    DocumentSnapshot userName = await FirebaseFirestore.instance
        .collection('users')
        .doc(plantHeadUid)
        .get();
    print(userName.data());
    name = userName.data()['name'];

    return name;
  }

  Future<void> deleteScheduledAssessment(String documentID) async {
    await FirebaseFirestore.instance.collection('cycles').doc(documentID).delete();
  }

  Future<List<Map<String, dynamic>>> scheduledAssessmentList() async {
    QuerySnapshot assessmentInfo =
        await FirebaseFirestore.instance.collection('cycles').get();
    List<Map<String, dynamic>> infoList = [];
    for (int i = 0; i < assessmentInfo.docs.length; i++) {
      Map<String, dynamic> info = {};
      Timestamp scheduleAssessment =
          assessmentInfo.docs[i]['scheduledDate'];
      DateTime scheduleAssessmentDate = DateTime.fromMillisecondsSinceEpoch(
          scheduleAssessment.millisecondsSinceEpoch);

      info['scheduledDate'] =
          DateFormat('dd-MM-yyyy').format(scheduleAssessmentDate);
      info['assessorName'] =
          await getAssessor(assessmentInfo.docs[i]['assessorUid']);
      info['coAssessorName'] =
          await getAssessor(assessmentInfo.docs[i]['coAssessorUid']);
      info['assessoruid'] = assessmentInfo.docs[i]['assessorUid'];

      info['coAssessoruid'] = assessmentInfo.docs[i]['coAssessorUid'];

      info['documentId'] = assessmentInfo.docs[i].id;

      info['name'] = assessmentInfo.docs[i]['name'];
      info['location'] = assessmentInfo.docs[i]['location'];
      info['currentStatus'] = assessmentInfo.docs[i]['currentStatus'];
      infoList.add(info);
    }
    return infoList;
  }

  Future<String> assessor(String assessorUid) async {
    String name = '';
    DocumentSnapshot userName = await FirebaseFirestore.instance
        .collection('users')
        .doc(assessorUid)
        .get();
    name = userName.data()['name'];

    return name;
  }

  Future<String> coAssessor(String coAssessorUid) async {
    String name = '';
    DocumentSnapshot userName = await FirebaseFirestore.instance
        .collection('users')
        .doc(coAssessorUid)
        .get();
    name = userName.data()['name'];

    return name;
  }

  Future<String> assessee(String assesseeUid) async {
    String name = '';
    DocumentSnapshot userName = await FirebaseFirestore.instance
        .collection('users')
        .doc(assesseeUid)
        .get();
    name = userName.data()['name'];

    return name;
  }

  Future<List<Map<String, dynamic>>> getClosedAssessment() async {
    QuerySnapshot closed =
        await FirebaseFirestore.instance.collection('cycles').get();
    List<Map<String, dynamic>> infoList = [];
    for (int i = 0; i < closed.docs.length; i++) {
      if (closed.docs[i].data()['currentStatus'] == 'Closed') {
        Map<String, dynamic> info = {};
        Timestamp scheduleAssessment = closed.docs[i]['scheduledDate'];
        DateTime scheduleAssessmentDate = DateTime.fromMillisecondsSinceEpoch(
            scheduleAssessment.millisecondsSinceEpoch);

        info['scheduledDate'] =
            DateFormat('dd-MM-yyyy').format(scheduleAssessmentDate);
        info['assessorName'] =
            await assessor(closed.docs[i]['assessorUid']);
        info['assesseeName'] =
            await assessee(closed.docs[i]['assesseeUid']);
        info['coAssessorName'] =
            await coAssessor(closed.docs[i]['coAssessorUid']);

        info['documentId'] = closed.docs[i].id;

        info['name'] = closed.docs[i]['name'];
        info['location'] = closed.docs[i]['location'];
        if (closed.docs[i].data().containsKey('sitePoint1') ||
            closed.docs[i].data().containsKey('sitePoint2') ||
            closed.docs[i].data().containsKey('sitePoint3') ||
            closed.docs[i].data().containsKey('sitePoint4') ||
            closed.docs[i].data().containsKey('sitePoint5') ||
            closed.docs[i].data().containsKey('wayForward1') ||
            closed.docs[i].data().containsKey('wayForward2')) {
          info['sitePoint1'] = closed.docs[i]['sitePoint1'];
          info['sitePoint2'] = closed.docs[i]['sitePoint2'];
          info['sitePoint3'] = closed.docs[i]['sitePoint3'];
          info['sitePoint4'] = closed.docs[i]['sitePoint4'];
          info['sitePoint5'] = closed.docs[i]['sitePoint5'];

          info['wayForward1'] = closed.docs[i]['wayForward1'];
          info['wayForward2'] = closed.docs[i]['wayForward2'];
        } else {
          info['sitePoint1'] = '';
          info['sitePoint2'] = '';
          info['sitePoint3'] = '';
          info['sitePoint4'] = '';
          info['sitePoint5'] = '';

          info['wayForward1'] = '';
          info['wayForward2'] = '';
        }

        infoList.add(info);
      }
    }
    return infoList;
  }

  Future<List<Map<String, dynamic>>> getClosedAssessmentData() async {
    QuerySnapshot closed =
        await FirebaseFirestore.instance.collection('cycles').get();
    List<Map<String, dynamic>> infoList = [];
    for (int i = 0; i < closed.docs.length; i++) {
      Map<String, dynamic> info = {};

      info['processLevel'] = closed.docs[i]['processLevel'];
      info['resultLevel'] = closed.docs[i]['resultLevel'];
      info['lastAssessmentStage'] = closed.docs[i]['lastAssessmentStage'];

      infoList.add(info);
    }
    return infoList;
  }

  Future<void> scheduleAssessment(String documentID, String assessorUid,
      String coAssessorUid, DateTime scheduledDate) async {
    print(documentID);
    DocumentSnapshot location = await FirebaseFirestore.instance
        .collection('locations')
        .doc(documentID)
        .get();
    String locat = location['location'];
    String name = location['nameOfSector'];
    String assessee = location['assessee'];
    await FirebaseFirestore.instance.collection('cycles').doc().set({
      'location': locat,
      'name': name,
      'documentId': documentID,
      'assesseeUid': assessee,
      'coAssessorUid': coAssessorUid,
      'startDate': Timestamp.now(),
      'currentStatus':
          'Annual Data Uploaded', //Change to annual Data Requested when annual data required.
      'endDate': null,
      'assessorUid': assessorUid,
      'scheduledDate': Timestamp.fromMillisecondsSinceEpoch(
          scheduledDate.millisecondsSinceEpoch)
    });

    /*QuerySnapshot selectedLocation = await FirebaseFirestore.instance
        .collection('cycles')
        .where('location', isEqualTo: locat)
        .get();

    String cycleDocumentID = selectedLocation.docs[0].documentID;
    List<Map<String, String>> map = [
      {'role': 'assessee', 'type': 'annualData', 'uid': assessee}
    ];

    await FirebaseFirestore.instance.collection('activities').doc().set({
      'content': 'Admin has requested Annual Data',
      'date': Timestamp.now(),
      'showTo': map,
      'cycleDocumentID': cycleDocumentID,
    });

    await FirebaseFirestore.instance.collection('activities').doc().set({
      'content':
          'Assessment Scheduled for location $location on ${scheduledDate.day}/${scheduledDate.month}/${scheduledDate.year}',
      'date': Timestamp.now(),
      'showTo': [
        {'role': 'assessee', 'type': 'information', 'uid': assessee},
        {'role': 'assessor', 'type': 'information', 'uid': assessorUid}
      ],
      'cycleDocumentID': cycleDocumentID,
    });
    await FirebaseFirestore.instance.collection('activities').doc().set({
      'content': 'Admin Has requested Self assessment',
      'date': Timestamp.now(),
      'showTo': [
        {'role': 'assessee', 'type': 'selfAssessment', 'uid': assessee},
      ],
      'cycleDocumentID': cycleDocumentID,
    });*/
  }

  Future<List<Map<String, String>>> getCycles() async {
    List<Map<String, String>> list = [];
    QuerySnapshot data =
        await FirebaseFirestore.instance.collection('cycles').get();
    for (int i = 0; i < data.docs.length; i++) {
      Map<String, String> map = {};
      Timestamp startDate = data.docs[i]['startDate'];
      DateTime startDateTime = startDate.toDate();
      if (data.docs[i]['endDate'] != null) {
        Timestamp endDate = data.docs[i]['endDate'];
        DateTime endDateTime = endDate.toDate();
        map['endDate'] = endDateTime.day.toString() +
            '/' +
            endDateTime.month.toString() +
            '/' +
            endDateTime.year.toString();
      } else {
        map['endDate'] = '';
      }

      map['location'] = data.docs[i]['location'];
      map['startDate'] = startDateTime.day.toString() +
          '/' +
          startDateTime.month.toString() +
          '/' +
          startDateTime.year.toString();

      map['currentStatus'] = data.docs[i]['currentStatus'];
      list.add(map);
    }
    return list;
  }

  Future<List<Map<String, String>>> getAssessorList() async {
    List<Map<String, String>> assessorList = [];
    await FirebaseFirestore.instance
        .collection('users')
        .orderBy('name')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        List<dynamic> roles = element['role'];
        if (roles.contains('assessor')) {
          Map<String, String> assessorMap = {};
          assessorMap['name'] = element['name'];
          assessorMap['uid'] = element.id;
          assessorList.add(assessorMap);
        }
      });
    });
    return assessorList;
  }

  Future<List<Map<String, String>>> getAssessmentAnnualData() async {
    List<Map<String, String>> annualDataList = [];
    await FirebaseFirestore.instance
        .collection('cycles')
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((cycle) {
        if (cycle.data()['currentStatus'] != 'Annual Data Requested' ||
            cycle.data()['currentStatus'] != 'Assessment Closed') {
          Map<String, String> map = {};
          if (cycle.data()['adCategory'] == 'category1') {
            map = category1Map(cycle);
          } else {
            map = category2Map(cycle);
          }
          annualDataList.add(map);
        }
      });
    });
    print(annualDataList.toString());

    return annualDataList;
  }

  Future<List<Map<String, String>>> getLocation() async {
    List<Map<String, String>> locationList = [];

    QuerySnapshot location =
        await FirebaseFirestore.instance.collection('locations').get();
    for (int i = 0; i < location.docs.length; i++) {
      Map<String, String> locationMap = {
        'location': location.docs[i].data()['location'],
        'nameOfSector': location.docs[i].data()['nameOfSector'],
        'documentId': location.docs[i].id
      };
      locationList.add(locationMap);
    }
    print(locationList.toString());
    return locationList;
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
          element['nameOfSector']
              .contains(location.docs[i].data()['name']) ||
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

  String numberToMonth(String number) {
    String month = number.substring(5);
    List<String> monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[int.parse(month) - 1];
  }

  Future<List<Map<String, dynamic>>> getMonths(
      String documentID, String name, String location) async {
    List<Map<String, dynamic>> monthList = [];

    QuerySnapshot month = await FirebaseFirestore.instance
        .collection('locations')
        .doc(documentID)
        .collection('monthlyData')
        .get();
    for (int i = 0; i < month.docs.length; i++) {
      Map<String, dynamic> monthMap = {};
      String monthName = numberToMonth(month.docs[i].id);
      monthMap['monthName'] = monthName;
      monthMap['nameOfSector'] = name;
      monthMap['location'] = location;
      monthMap['closureOf'] = month.docs[i].data()['closureOf'];
      monthMap['fatal'] = month.docs[i].data()['fatal'];
      monthMap['fatalAccidents'] = month.docs[i].data()['fatalAccidents'];
      monthMap['fireIncident'] = month.docs[i].data()['fireIncident'];
      monthMap['fireIncidentMinor'] =
          month.docs[i].data()['fireIncidentMinor'];
      monthMap['firstaidAccidents'] =
          month.docs[i].data()['firstaidAccidents'];
      monthMap['identified'] = month.docs[i].data()['identified'];
      monthMap['kaizen'] = month.docs[i].data()['kaizen'];
      monthMap['manDaysLost'] = month.docs[i].data()['manDaysLost'];
      monthMap['manDaysLostNra'] = month.docs[i].data()['manDaysLostNra'];
      monthMap['manPower'] = month.docs[i].data()['manPower'];
      monthMap['nearMissIncident'] =
          month.docs[i].data()['nearMissIncident'];
      monthMap['noReportableAccidents'] =
          month.docs[i].data()['noReportableAccidents'];
      monthMap['reportableAccidents'] =
          month.docs[i].data()['reportableAccidents'];
      monthMap['safetyActivityRate'] =
          month.docs[i].data()['safetyActivityRate'];
      monthMap['seriousAccidents'] =
          month.docs[i].data()['seriousAccidents'];
      monthMap['themeBasedInspections'] =
          month.docs[i].data()['themeBasedInspections'];
      monthMap['totalAccidents'] = month.docs[i].data()['totalAccidents'];

      monthList.add(monthMap);
    }
    print(monthList.toString());
    return monthList;
  }

  Future<List<Map<String, dynamic>>> getFireRiskProfile(
      String documentID) async {
    List<Map<String, dynamic>> fireRiskProfileDataList = [];
    DocumentSnapshot dataDS = await FirebaseFirestore.instance
        .collection('cycles')
        .doc(documentID)
        .get();
    List<dynamic> fireRiskProfileList = dataDS.data()['fireRiskProfile'];
    for (int i = 0; i < fireRiskProfileList.length; i++) {
      Map<String, dynamic> dataMap = {};

      dataMap['point1'] = fireRiskProfileList[i]['point1'];
      dataMap['point2'] = fireRiskProfileList[i]['point2'];
      dataMap['point3'] = fireRiskProfileList[i]['point3'];
      fireRiskProfileDataList.add(dataMap);
    }
    return fireRiskProfileDataList;
  }

  Future<List<Map<String, dynamic>>> getOfficeRiskProfile(
      String documentID) async {
    List<Map<String, dynamic>> officeRiskProfileDataList = [];
    DocumentSnapshot dataDS = await FirebaseFirestore.instance
        .collection('cycles')
        .doc(documentID)
        .get();
    List<dynamic> officeRiskProfileList = dataDS.data()['officeRiskProfile'];
    for (int i = 0; i < officeRiskProfileList.length; i++) {
      Map<String, dynamic> dataMap = {};

      dataMap['point1'] = officeRiskProfileList[i]['point1'];
      dataMap['point2'] = officeRiskProfileList[i]['point2'];
      dataMap['point3'] = officeRiskProfileList[i]['point3'];
      officeRiskProfileDataList.add(dataMap);
    }
    return officeRiskProfileDataList;
  }

  Future<List<Map<String, dynamic>>> getSiteRiskProfile(
      String documentID) async {
    List<Map<String, dynamic>> siteRiskProfileDataList = [];
    DocumentSnapshot dataDS = await FirebaseFirestore.instance
        .collection('cycles')
        .doc(documentID)
        .get();
    List<dynamic> siteRiskProfileList = dataDS.data()['siteRiskProfile'];
    for (int i = 0; i < siteRiskProfileList.length; i++) {
      Map<String, dynamic> dataMap = {};

      dataMap['point1'] = siteRiskProfileList[i]['point1'];
      dataMap['point2'] = siteRiskProfileList[i]['point2'];
      dataMap['point3'] = siteRiskProfileList[i]['point3'];
      siteRiskProfileDataList.add(dataMap);
    }
    return siteRiskProfileDataList;
  }

  Future<List<Map<String, dynamic>>> getSummaryRiskProfile(
      String documentID) async {
    List<Map<String, dynamic>> summaryRiskProfileDataList = [];
    DocumentSnapshot dataDS = await FirebaseFirestore.instance
        .collection('cycles')
        .doc(documentID)
        .get();
    List<dynamic> summaryRiskProfileList = dataDS.data()['summeryRiskProfile'];
    for (int i = 0; i < summaryRiskProfileList.length; i++) {
      Map<String, dynamic> dataMap = {};

      dataMap['point1'] = summaryRiskProfileList[i]['point1'];
      dataMap['point2'] = summaryRiskProfileList[i]['point2'];
      dataMap['point3'] = summaryRiskProfileList[i]['point3'];
      summaryRiskProfileDataList.add(dataMap);
    }
    return summaryRiskProfileDataList;
  }

  Future<List<Map<String, dynamic>>> getSiteAssessmentData(
      String documentID) async {
    List<Map<String, dynamic>> siteAssessmentDataList = [];
    DocumentSnapshot dataDS = await FirebaseFirestore.instance
        .collection('cycles')
        .doc(documentID)
        .get();
    List<dynamic> siteAssessmentList = dataDS.data()['siteAssessment'];

    for (int i = 0; i < siteAssessmentList.length; i++) {
      Map<String, dynamic> dataMap = {};

      dataMap['level'] = siteAssessmentList[i]['level'];

      siteAssessmentDataList.add(dataMap);
    }
    print('Data lenght:: ' + siteAssessmentDataList.length.toString() + '\n\n');
    return siteAssessmentDataList;
  }

  Map<String, String> category1Map(DocumentSnapshot cycle) {
    Map<String, String> map = {};
    map['location'] = cycle.data()['location'];
    map['category'] = cycle.data()['adCategory'];
    map['closureOf'] = cycle.data()['adClosureOf'].toString();
    map['fatal'] = cycle.data()['adFatal'].toString();
    map['fatalAccidents'] = cycle.data()['adFatalAccidents'].toString();
    map['fireIncidents'] = cycle.data()['adFireIncident'].toString();
    map['fireIncidentMinor'] = cycle.data()['adFireIncidentMinor'].toString();
    map['firstaidAccidents'] = cycle.data()['adFirstaidAccidents'].toString();
    map['identified'] = cycle.data()['adIdentified'].toString();
    map['manDaysLost'] = cycle.data()['adManDaysLost'].toString();
    map['manDaysLostNra'] = cycle.data()['adManDaysLostNra'].toString();
    map['manPower'] = cycle.data()['adManPower'].toString();
    map['nearMissIncidents'] = cycle.data()['adNearMissIncident'].toString();
    map['nonReportableAccidents'] =
        cycle.data()['adNoReportableAccidents'].toString();
    map['reportableAccidents'] = cycle.data()['adReportableAccidents'].toString();
    map['safetyActivityRate'] = cycle.data()['adSafetyActivityRate'].toString();
    map['themeBasedInspections'] =
        cycle.data()['adThemeBasedInspections'].toString();
    map['totalAccidents'] = cycle.data()['adTotalAccidents'].toString();
    map['kaizen'] = cycle.data()['adKaizen'].toString();

    return map;
  }

  Map<String, String> category2Map(DocumentSnapshot cycle) {
    Map<String, String> map = {};
    map['location'] = cycle.data()['location'];
    map['category'] = cycle.data()['adCategory'];
    map['manPower'] = cycle.data()['adManPower'].toString();
    map['fatal'] = cycle.data()['adFatal'].toString();
    map['onDutyFatal'] = cycle.data()['adonDutyFatal'].toString();
    map['fireIncidentsMajor'] = cycle.data()['adFireIncidentMajor'].toString();
    map['fireIncidentMinor'] = cycle.data()['adFireIncidentMinor'].toString();
    map['reportableAccidents'] = cycle.data()['adReportableAccidents'].toString();

    return map;
  }

  Future<Map<String, dynamic>> getValues(String documentId) async {
    String locationId = '';
    await FirebaseFirestore.instance
        .collection('cycles')
        .doc(documentId)
        .get()
        .then((cycle) async {
      locationId = cycle.data()['documentId'];
    });
    DocumentSnapshot info = await FirebaseFirestore.instance
        .collection('locations')
        .doc(locationId)
        .collection('info')
        .doc('info')
        .get();

    DocumentSnapshot previous = await FirebaseFirestore.instance
        .collection('locations')
        .doc(locationId)
        .get();

    Map<String, dynamic> keys = {
      'lastAssessmentStage': previous.data()['lastAssessmentStage'],
      'processLevel': previous.data()['processLevel'],
      'resultLevel': previous.data()['resultLevel'],
      'rule': info.data()['rule'],
      'lpg': info.data()['lpg'],
      'gasoline': info.data()['gasoline'],
      'cng': info.data()['cng'],
      'paintShop': info.data()['paintShop'],
      'foundry': info.data()['foundry'],
      'press': info.data()['press'],
      'diesel': info.data()['diesel'],
      'thinner': info.data()['thinner'],
      'toxic': info.data()['toxic'],
      'heat': info.data()['heat'],
      'testBed': info.data()['testBed'],
      'ibr': info.data()['ibr'],
      'fatal': info.data()['fatal'],
      'reportable': info.data()['reportable'],
      'nonReportable': info.data()['nonReportable'],
      'firstAid': info.data()['firstAid'],
      'fire': info.data()['fire'],
      'foundryUrl': info.data()['foundryUrl'],
      'pressUrl': info.data()['pressUrl'],
      'thinnerUrl': info.data()['thinnerUrl'],
      'toxicUrl': info.data()['toxicUrl'],
      'heatUrl': info.data()['heatUrl'],
      'ibrUrl': info.data()['ibrUrl'],
    };
    print('repository ' + keys.toString());
    return keys;
  }

  Future<List<Map<String, String>>> editLocation() async {
    List<Map<String, String>> locationMap = [];

    await FirebaseFirestore.instance
        .collection('locations')
        .get()
        .then((value) => value.docs.forEach((element) {
              Map<String, String> location = element.data();
              location['documentId'] = element.id;
              locationMap.add(location);
            }));
    return locationMap;
  }

  // Future<List<Map<String, String>>> editLocation(String documentID) async {
  //   print('Started');
  //   List<Map<String, String>> locationMap = [];
  //   DocumentSnapshot locations = await FirebaseFirestore.instance
  //       .collection('locations')
  //       .doc(documentID)
  //       .get();

  //   Map<String, String> location = {};

  //   location['typeOfLocation'] = locations.data()['typeOfLocation'];
  //   location['documentId']=locations.data().documentID;
  //   location['assessee'] = await getAssesseeName(locations.data()['assessee']);
  //   print('assessee');
  //   location['plantHead'] = await getPlantHead(locations.data()['plantHead']);
  //   location['assesseeId'] = locations.data()['assessee'];
  //   location['plantHeadId'] = locations.data()['plantHead'];
  //   location['location'] = locations.data()['location'];
  //   location['nameOfSector'] = locations.data()['nameOfSector'];
  //   location['plantHeadEmail'] = locations.data()['plantHeadEmail'];
  //   location['plantHeadName'] = locations.data()['plantHeadName'];

  //   location['sectorBusinessSafetySpocEmail'] =
  //       locations.data()['sectorBusinessSafetySpocEmail'];
  //   location['sectorBusinessSafetySpocName'] =
  //       locations.data()['sectorBusinessSafetySpocName'];

  //   location['category'] = locations.data()['category'];
  //   location['lastAssessmentStage'] = locations.data()['lastAssessmentStage'];
  //   location['nameOfSector'] = locations.data()['nameOfSector'];
  //   location['processLevel'] = locations.data()['processLevel'];
  //   location['resultLevel'] = locations.data()['resultLevel'];

  //   locationMap.add(location);

  //   return locationMap;
  // }

  Future<void> changeStatus(String documentId, String currentStatus) async {
    await FirebaseFirestore.instance
        .collection('cycles')
        .doc(documentId)
        .update({'currentStatus': currentStatus});
  }

  Future<void> editScheduledAssessment(String assessorUid, String coAssessorUid,
      DateTime scheduledDate, String documentId) async {
    await FirebaseFirestore.instance
        .collection('cycles')
        .doc(documentId)
        .update({
      'assessorUid': assessorUid,
      'coAssessorUid': coAssessorUid,
      'scheduledDate': Timestamp.fromMillisecondsSinceEpoch(
          scheduledDate.millisecondsSinceEpoch)
    });
  }

  Future<void> updateLocationInfo(
      String location,
      String nameOfsector,
      String assessee,
      String plantHead,
      String plantHeadName,
      String plantHeadEmail,
      String spocName,
      String spocEmail,
      String documentId) async {
    await FirebaseFirestore.instance
        .collection('locations')
        .doc(documentId)
        .update({
      'location': location,
      'nameOfSector': nameOfsector,
      'assessee': assessee,
      'plantHead': plantHead,
      'plantHeadName': plantHeadName,
      'plantHeadEmail': plantHeadEmail,
      'sectorBusinessSafetySpocName': spocName,
      'sectorBusinessSafetySpocEmail': spocEmail,
      'documentId': documentId
    });
  }
}
