import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AssesseeRepository {
  Future<String> getUid() async {
    User user = FirebaseAuth.instance.currentUser;
    return user.uid;
  }

  Future<List<Map<String, String>>> getLocation(String type) async {
    List<Map<String, String>> locationList = [];
    String uid = FirebaseAuth.instance.currentUser.uid;

    QuerySnapshot cycles =
        await FirebaseFirestore.instance.collection('cycles').get();
    for (int i = 0; i < cycles.docs.length; i++) {
      if ((cycles.docs[i].data()['currentStatus'] == 'Approved by PlantHead' ||
              cycles.docs[i].data()['currentStatus'] ==
                  'Site Assessment Uploaded' ||
              cycles.docs[i].data()['currentStatus'] ==
                  'Approved by CoAssessor' ||
              cycles.docs[i].data()['currentStatus'] == 'Closed') &&
          (cycles.docs[i].data()['assesseeUid'] == uid)) {
        Map<String, String> locationMap = {
          'location': cycles.docs[i].data()['location'],
          'name': cycles.docs[i].data()['name'],
          'docId': cycles.docs[i].id
        };
        locationList.add(locationMap);
      }
    }
    print(locationList.toString());
    return locationList;
  }

  Future<List<Map<String, dynamic>>> getSelfAssessmentData(String docID) async {
    List<Map<String, dynamic>> assessmentDataList = [];

    DocumentSnapshot dataDS =
        await FirebaseFirestore.instance.collection('cycles').doc(docID).get();
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

  Future<List<Map<String, dynamic>>> getFireAssessmentData(String docID) async {
    List<Map<String, dynamic>> fireAssessmentDataList = [];

    DocumentSnapshot dataDS =
        await FirebaseFirestore.instance.collection('cycles').doc(docID).get();
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

  Future<List<dynamic>> getOfficeAssessmentData(String docID) async {
    DocumentSnapshot dataDS =
        await FirebaseFirestore.instance.collection('cycles').doc(docID).get();
    List<dynamic> officeAssessmentList = dataDS.data()['selfAssessmentOffice'];
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

  Future<List<Map<String, dynamic>>> getSiteAssessmentData(String docID) async {
    List<Map<String, dynamic>> siteAssessmentDataList = [];
    DocumentSnapshot dataDS =
        await FirebaseFirestore.instance.collection('cycles').doc(docID).get();
    List<dynamic> siteAssessmentList = dataDS.data()['siteAssessment'];

    for (int i = 0; i < siteAssessmentList.length; i++) {
      Map<String, dynamic> dataMap = {};

      dataMap['answer'] = siteAssessmentList[i]['answer'];
      dataMap['comment'] = siteAssessmentList[i]['comment'];
      dataMap['fileUrl'] = siteAssessmentList[i]['fileUrl'];
      dataMap['level'] = siteAssessmentList[i]['level'];
      dataMap['suggestion'] = siteAssessmentList[i]['suggestion'];
      dataMap['coComment'] = '';
      dataMap['status'] = 'open';
      dataMap['closedAssessment'] = '';
      dataMap['upload'] = null;
      siteAssessmentDataList.add(dataMap);
    }
    print('Data lenght:: ' + siteAssessmentDataList.length.toString() + '\n\n');
    return siteAssessmentDataList;
  }

  Future<List<Map<String, dynamic>>> getSiteFireAssessmentData(
      String docID) async {
    List<Map<String, dynamic>> fireAssessmentDataList = [];

    DocumentSnapshot dataDS =
        await FirebaseFirestore.instance.collection('cycles').doc(docID).get();
    List<dynamic> fireAssessmentList = dataDS.data()['siteAssessmentFire'];
    fireAssessmentDataList
        .add({'fileUrl': dataDS.data()['siteAssessmentFireUrl']});
    for (int i = 0; i < fireAssessmentList.length; i++) {
      Map<String, dynamic> dataMap = {};

      dataMap['answer'] = fireAssessmentList[i]['answer'];
      dataMap['marks'] = fireAssessmentList[i]['marks'];
      dataMap['comment'] = fireAssessmentList[i]['comment'];
      dataMap['coComment'] = '';

      dataMap['status'] = 'open';

      dataMap['closedAssessment'] = '';
      dataMap['upload'] = null;
      fireAssessmentDataList.add(dataMap);
    }

    return fireAssessmentDataList;
  }

  Future<List<dynamic>> getSiteOfficeAssessmentData(String docID) async {
    DocumentSnapshot dataDS =
        await FirebaseFirestore.instance.collection('cycles').doc(docID).get();

    List<dynamic> officeAssessment = dataDS.data()['siteAssessmentOffice'];
    List<dynamic> officeAssessmentList = [];
    for (int i = 0; i < officeAssessment.length; i++) {
      Map<String, dynamic> dataMap = {};
      dataMap['answer'] = officeAssessment[i]['answer'];
      dataMap['marks'] = officeAssessment[i]['marks'];
      dataMap['comment'] = officeAssessment[i]['comment'];
      dataMap['coComment'] = '';
      dataMap['status'] = 'open';
      dataMap['closedAssessment'] = '';
      dataMap['upload'] = null;
      officeAssessmentList.add(dataMap);
    }
    return officeAssessmentList;
  }

  Future<void> editSiteUpload(
      List<Map<String, dynamic>> siteAssessment, String docID) async {
    await FirebaseFirestore.instance.collection('cycles').doc(docID).update({
      'siteAssessment': siteAssessment,
    });
  }
}
