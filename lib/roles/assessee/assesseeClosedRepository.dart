

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AssesseeClosedRepository{
  Future<String> getUid() async {
    User user = await FirebaseAuth.instance.currentUser;
    return user.uid;
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
      dataMap['coComment'] = '';
      siteAssessmentDataList.add(dataMap);
    }
    print('Data lenght:: ' + siteAssessmentDataList.length.toString() + '\n\n');
    return siteAssessmentDataList;
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

  Future<List<Map<String, dynamic>>> getClosedAssessment() async {
    String uid;
   User user = FirebaseAuth.instance.currentUser;
    uid=user.uid;
    QuerySnapshot closed =
        await FirebaseFirestore.instance.collection('cycles').get();
    List<Map<String, dynamic>> infoList = [];
    for (int i = 0; i < closed.docs.length; i++) {
      if (closed.docs[i].data()['currentStatus'] == 'Closed' &&(closed.docs[i].data()['assesseeUid'] == uid)) {
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

   Future<String> assessor(String assessorUid) async {
    String name = '';
    String uid;
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


    Future<Map<String, dynamic>> values(String documentId) async {
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

  
  Future<List<Map<String, dynamic>>> getSiteAssessmentReviewData(
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
      dataMap['coComment'] = '';
      dataMap['status']='open';
      dataMap['closedAssessment']='';
      dataMap['upload']=null;
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
      dataMap['coComment'] = '';
      
        dataMap['status']='open';
    
       
      dataMap['closedAssessment']='';
      dataMap['upload']=null;
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
      dataMap['coComment'] = '';
        dataMap['status']='open';
      dataMap['closedAssessment']='';
      dataMap['upload']=null;
      officeAssessmentList.add(dataMap);
    }
    return officeAssessmentList;
  }
Future<void> editSiteUpload(
      List<Map<String, dynamic>> siteAssessment,
     
      String documentID) async {
    

    await FirebaseFirestore.instance
        .collection('cycles')
       .doc(documentID)
        .update({
      'siteAssessment': siteAssessment,
     
    });
  }



}