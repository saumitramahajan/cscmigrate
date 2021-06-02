import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlantHeadAssessmentRepository {
  Future<String> getUid() async {
    User user = await FirebaseAuth.instance.currentUser;
    return user.uid;
  }

  Future<String> getCycleId() async {
    String uid = await getUid();
    QuerySnapshot location = await FirebaseFirestore.instance
        .collection('locations')
        .where('plantHead', isEqualTo: uid)
        .get();

    String cycleId = 'no';
    if (location.docs.length > 0) {
      String locationId = location.docs[0].id;
      QuerySnapshot cycles = await FirebaseFirestore.instance
          .collection('cycles')
          .where('documentId', isEqualTo: locationId)
          .get();
      cycleId = cycles.docs[0].id;
    }
    return cycleId;
  }

  Future<List<List<Map<String, dynamic>>>> getData(String cycleId) async {
    List<List<Map<String, dynamic>>> assessmentList = [];
    DocumentSnapshot cycleData =
        await FirebaseFirestore.instance.collection('cycles').doc(cycleId).get();
    String status = cycleData.data()['currentStatus'];
    if (status == 'Self Assessment Uploaded') {
      List<Map<String, dynamic>> locationInfo = [
        {'name': cycleData.data()['name'], 'location': cycleData.data()['location']}
      ];
      List<Map<String, dynamic>> selfAssessment =
          cycleData.data()['selfAssessment'];
      assessmentList.add(selfAssessment);
      List<Map<String, dynamic>> selfassessmentFire = [
        {'fileUrl': cycleData.data()['selfAssessmentFireUrl']}
      ];
      selfassessmentFire..addAll(cycleData.data()['selfAssessmentFire']);
      assessmentList.add(selfassessmentFire);
      List<Map<String, dynamic>> selfAssessmentOffice =
          cycleData.data()['selfAssessmentOffice'];
      assessmentList.add(selfAssessmentOffice);
      assessmentList.add(locationInfo);
    }
    return assessmentList;
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

  Future<void> approveAssessment(String documentId) async {
    await FirebaseFirestore.instance
        .collection('cycles')
        .doc(documentId)
        .update({'currentStatus': 'Approved by PlantHead'});
  }
}
