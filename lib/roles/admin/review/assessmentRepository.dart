import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AssessmentRepository {
  Future<String> getUid() async {
    User user = await FirebaseAuth.instance.currentUser;
    return user.uid;
  }

  Future<List<Map<String, String>>> getLocation(String type) async {
    List<Map<String, String>> locationList = [];

    QuerySnapshot cycles =
        await FirebaseFirestore.instance.collection('cycles').get();
    for (int i = 0; i < cycles.docs.length; i++) {
      if (type == 'self') {
        if (cycles.docs[i].data().containsKey('selfAssessment') &&
            cycles.docs[i].data().containsKey('selfAssessmentFire') &&
            cycles.docs[i].data().containsKey('selfAssessmentOffice') &&
            (cycles
                        .docs[i].data()['currentStatus'] ==
                    'Self Assessment Uploaded' ||
                cycles.docs[i].data()['currentStatus'] ==
                    'Approved by PlantHead' ||
                cycles.docs[i].data()['currentStatus'] ==
                    'Site Assessment Uploaded' ||
                cycles.docs[i].data()['currentStatus'] ==
                    'Approved by CoAssessor' ||
                cycles.docs[i].data()['currentStatus'] == 'Closed')) {
          Map<String, String> locationMap = {
            'location': cycles.docs[i].data()['location'],
            'name': cycles.docs[i].data()['name'],
            'documentId': cycles.docs[i].id,
            'currentStatus': cycles.docs[i].data()['currentStatus'],
          };
          locationList.add(locationMap);
        }
      } else {
        if (cycles.docs[i].data()['currentStatus'] ==
                'Approved by CoAssessor' ||
            cycles.docs[i].data()['currentStatus'] == 'Closed') {
          Map<String, String> locationMap = {
            'location': cycles.docs[i].data()['location'],
            'name': cycles.docs[i].data()['name'],
            'documentId': cycles.docs[i].id,
            'currentStatus': cycles.docs[i].data()['currentStatus'],
          };
          locationList.add(locationMap);
        }
      }
    }
    print(locationList.toString());
    return locationList;
  }

  Future<List<Map<String, dynamic>>> getSelfAssessmentData(
      String documentID) async {
    List<Map<String, dynamic>> assessmentDataList = [];

    DocumentSnapshot dataDS = await FirebaseFirestore.instance
        .collection('cycles')
        .doc(documentID)
        .get();
    List<dynamic> selfAssessmentList = dataDS.data()['selfAssessment'];

    for (int i = 0; i < selfAssessmentList.length; i++) {
      Map<String, dynamic> dataMap = {};

      dataMap['answer'] = selfAssessmentList[i]['answer'];
      dataMap['comment'] = selfAssessmentList[i]['comment'];
      dataMap['fileUrl'] = selfAssessmentList[i]['fileUrl'];
      dataMap['level'] = selfAssessmentList[i]['level'];
      assessmentDataList.add(dataMap);
    }
    print('Data lenght:: ' + assessmentDataList.length.toString() + '\n\n');
    return assessmentDataList;
  }

  Future<List<Map<String, dynamic>>> getFireAssessmentData(
      String documentID) async {
    List<Map<String, dynamic>> fireAssessmentDataList = [];

    DocumentSnapshot dataDS = await FirebaseFirestore.instance
        .collection('cycles')
        .doc(documentID)
        .get();
    List<dynamic> fireAssessmentList = dataDS.data()['selfAssessmentFire'];
    fireAssessmentDataList
        .add({'fileUrl': dataDS.data()['selfAssessmentFireUrl']});

    for (int i = 0; i < fireAssessmentList.length; i++) {
      Map<String, dynamic> dataMap = {};

      dataMap['answer'] = fireAssessmentList[i]['answer'];
      dataMap['comment'] = fireAssessmentList[i]['comment'];
      fireAssessmentDataList.add(dataMap);
    }

    return fireAssessmentDataList;
  }

  Future<List<dynamic>> getOfficeAssessmentData(String documentID) async {
    DocumentSnapshot dataDS = await FirebaseFirestore.instance
        .collection('cycles')
        .doc(documentID)
        .get();
    List<dynamic> officeAssessmentList = dataDS.data()['selfAssessmentOffice'];
    return officeAssessmentList;
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

      dataMap['answer'] = siteAssessmentList[i]['answer'];
      dataMap['comment'] = siteAssessmentList[i]['comment'];
      dataMap['fileUrl'] = siteAssessmentList[i]['fileUrl'];
      dataMap['level'] = siteAssessmentList[i]['level'];
      dataMap['suggestion'] = siteAssessmentList[i]['suggestion'];
      dataMap['coComment'] = siteAssessmentList[i]['coComment'];
      siteAssessmentDataList.add(dataMap);
    }
    print('Data lenght:: ' + siteAssessmentDataList.length.toString() + '\n\n');
    return siteAssessmentDataList;
  }

  Future<List<Map<String, dynamic>>> getSiteFireAssessmentData(
      String documentID) async {
    List<Map<String, dynamic>> fireAssessmentDataList = [];

    DocumentSnapshot dataDS = await FirebaseFirestore.instance
        .collection('cycles')
        .doc(documentID)
        .get();
    List<dynamic> fireAssessmentList = dataDS.data()['siteAssessmentFire'];
    fireAssessmentDataList
        .add({'fileUrl': dataDS.data()['siteAssessmentFireUrl']});
    for (int i = 0; i < fireAssessmentList.length; i++) {
      Map<String, dynamic> dataMap = {};

      dataMap['answer'] = fireAssessmentList[i]['answer'];
      dataMap['marks'] = fireAssessmentList[i]['marks'];
      dataMap['comment'] = fireAssessmentList[i]['comment'];
      dataMap['coComment'] = fireAssessmentList[i]['coComment'];
      fireAssessmentDataList.add(dataMap);
    }

    return fireAssessmentDataList;
  }

  Future<List<dynamic>> getSiteOfficeAssessmentData(String documentID) async {
    DocumentSnapshot dataDS = await FirebaseFirestore.instance
        .collection('cycles')
        .doc(documentID)
        .get();
    List<dynamic> officeAssessment = dataDS.data()['siteAssessmentOffice'];
    List<dynamic> officeAssessmentList = [];
    for (int i = 0; i < officeAssessment.length; i++) {
      Map<String, dynamic> dataMap = {};
      dataMap['answer'] = officeAssessment[i]['answer'];
      dataMap['marks'] = officeAssessment[i]['marks'];
      dataMap['comment'] = officeAssessment[i]['comment'];
      dataMap['coComment'] = officeAssessment[i]['coComment'];
      officeAssessmentList.add(dataMap);
    }
    return officeAssessmentList;
  }

  Future<List<Map<String, String>>> getsiteAssessmentStatement() async {
    List<Map<String, String>> statementList = [];

    QuerySnapshot siteAssessment = await FirebaseFirestore.instance
        .collection('siteAssessment')
        .orderBy('number')
        .get();
    for (int i = 0; i < siteAssessment.docs.length; i++) {
      Map<String, String> statementMap = {
        'statement': siteAssessment.docs[i].data()['statement'],
      };
      statementList.add(statementMap);
    }

    return statementList;
  }

  Future<List<Map<String, String>>> getsiteAssessmentStatementFire() async {
    List<Map<String, String>> statementListFire = [];

    QuerySnapshot siteAssessmentFire = await FirebaseFirestore.instance
        .collection('siteAssessmentFire')
        .orderBy('number')
        .get();
    for (int i = 0; i < siteAssessmentFire.docs.length; i++) {
      Map<String, String> statementMap = {
        'statement': siteAssessmentFire.docs[i].data()['statement'],
      };
      statementListFire.add(statementMap);
    }

    return statementListFire;
  }

  Future<List<Map<String, String>>> getsiteAssessmentStatementOffice() async {
    List<Map<String, String>> statementListOffice = [];

    QuerySnapshot siteAssessmentOffice = await FirebaseFirestore.instance
        .collection('siteAssessmentOffice')
        .orderBy('number')
        .get();
    for (int i = 0; i < siteAssessmentOffice.docs.length; i++) {
      Map<String, String> statementMap = {
        'statement': siteAssessmentOffice.docs[i].data()['statement'],
      };
      statementListOffice.add(statementMap);
    }

    return statementListOffice;
  }

  Future<void> approve(String cycleId, String lastAssessmentStageValue,
      String processLevel, String resultLevel, String heatMapUrl) async {
    await FirebaseFirestore.instance.collection('cycles').doc(cycleId).update({
      'currentStatus': 'Closed',
      'lastAssessmentStage': lastAssessmentStageValue,
      'resultLevel': resultLevel,
      'processLevel': processLevel,
      'heatMapUrl': heatMapUrl
    });
    DocumentSnapshot dataDs =
        await FirebaseFirestore.instance.collection('cycles').doc(cycleId).get();
    String documentId = dataDs.data()['documentId'];

    await FirebaseFirestore.instance
        .collection('locations')
        .doc(documentId)
        .update({
      'lastAssessmentStage': lastAssessmentStageValue,
      'resultLevel': resultLevel,
      'processLevel': processLevel,
    });
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

  Future<void> editSelfUpload(
      List<Map<String, dynamic>> selfAssessment,
      List<Map<String, dynamic>> selfFireAssessment,
      List<dynamic> selfOfficeAssessment,
      String documentID) async {
    List<Map<String, dynamic>> newSelfFireAssessment =
        List.generate(9, (index) => selfFireAssessment[index + 1]);

    await FirebaseFirestore.instance
        .collection('cycles')
        .doc(documentID)
        .update({
      'selfAssessment': selfAssessment,
      'selfAssessmentFire': newSelfFireAssessment,
      'selfAssessmentOffice': selfOfficeAssessment
    });
  }

  Future<void> editSiteUpload(
      List<Map<String, dynamic>> siteAssessment,
      List<Map<String, dynamic>> siteFireAssessment,
      List<dynamic> siteOfficeAssessment,
      String documentID) async {
    List<Map<String, dynamic>> newSiteFireAssessment =
        List.generate(9, (index) => siteFireAssessment[index + 1]);

    await FirebaseFirestore.instance
        .collection('cycles')
        .doc(documentID)
        .update({
      'siteAssessment': siteAssessment,
      'siteAssessmentFire': newSiteFireAssessment,
      'siteAssessmentOffice': siteOfficeAssessment
    });
  }

  Future<List<Map<String, dynamic>>> locationCSV() async {
    QuerySnapshot csv =
        await FirebaseFirestore.instance.collection('locations').get();
    List<Map<String, dynamic>> infoList = [];
    for (int i = 0; i < csv.docs.length; i++) {
      if (csv.docs[i].data()['nameOfSector'] == 'Automotive Division') {
        Map<String, dynamic> info = {};
        info['location'] = csv.docs[i]['location'];
        infoList.add(info);
      }
    }
    return infoList;
  }
}
