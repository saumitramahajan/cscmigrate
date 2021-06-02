//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AssessentRepository {
  Future<List<Map<String, dynamic>>> getAssessmentQuestions() async {
    List<Map<String, dynamic>> questionList = [];
    print('Start get questions');
    await FirebaseFirestore.instance
        .collection('siteAssessment')
        .orderBy('number')
        .get()
        .then((value) {
      value.docs.forEach((question) {
        Map<String, dynamic> questionMap = {};
        List<List<DropdownMenuItem<double>>> levelMarks = [];
        questionMap['category'] = question.data()['category'];
        questionMap['imageLink'] = question.data()['imageLink'];
        questionMap['marks'] = question.data()['marks'];
        questionMap['number'] = question.data()['number'];
        questionMap['statement'] = question.data()['statement'];
        List<dynamic> levels = question.data()['levelMarks'];
        questionMap['levelMarksBase'] = levels;
        for (int i = 0; i < 5; i++) {
          List<DropdownMenuItem<double>> dropDown = [];
          double start = 0;
          if (i != 0) {
            start = levels[i - 1].toDouble() + 0.5;
          }
          double end = levels[i].toDouble();
          print(start.toString() + end.toString() + '\n\n');
          for (double j = start; j <= end; j = j + .5) {
            DropdownMenuItem<double> drop = DropdownMenuItem(
              child: Text(j.toString()),
              value: j,
            );
            dropDown.add(drop);
          }
          levelMarks.add(dropDown);
        }
        questionMap['levelMarks'] = levelMarks;
        questionList.add(questionMap);
        print('Done ${question.id}');
      });
    });
    return questionList;
  }

  Future<List<Map<String, dynamic>>> getFireQuestions() async {
    List<Map<String, dynamic>> fireQuestions = [];
    await FirebaseFirestore.instance
        .collection('siteAssessmentFire')
        .get()
        .then((questionQS) {
      questionQS.docs.forEach((questionDS) {
        Map<String, dynamic> map = {};
        map['statement'] = questionDS.data()['statement'];
        map['condition'] = questionDS.data()['condition'];
        map['validation'] = questionDS.data()['validation'];
        map['number'] = questionDS.data()['number'];
        fireQuestions.add(map);
      });
    });
    return fireQuestions;
  }

  Future<List<Map<String, dynamic>>> getOfficeQuestions() async {
    List<Map<String, dynamic>> officeQuestions = [];
    await FirebaseFirestore.instance
        .collection('siteAssessmentOffice')
        .get()
        .then((questionQS) {
      questionQS.docs.forEach((questionDS) {
        Map<String, dynamic> map = {};
        map['statement'] = questionDS.data()['statement'];
        map['condition'] = questionDS.data()['condition'];
        map['validation'] = questionDS.data()['validation'];
        map['number'] = questionDS.data()['number'];
        officeQuestions.add(map);
      });
    });
    print(officeQuestions.toString());
    return officeQuestions;
  }

  Future<Map<String, dynamic>> getLocationInfo(String cycleId) async {
    Map<String, dynamic> data = {};
    DocumentSnapshot docu =
        await FirebaseFirestore.instance.collection('cycles').doc(cycleId).get();
    String documentID = docu.data()['documentId'];

    await FirebaseFirestore.instance
        .collection('locations')
        .doc(documentID)
        .collection('info')
        .doc('info')
        .get()
        .then((value) {
      print('Location Info called:: ' +
          value.data().toString() +
          value.exists.toString());
      if (value.exists) {
        data['documentId'] = documentID;
        data['dataExists'] = true;
        data['siteName'] = value.data()['siteName'];
        data['occupierName'] = value.data()['occupierName'];
        data['occupierEmail'] = value.data()['occupierEmail'];
        data['headName'] = value.data()['headName'];
        data['headEmail'] = value.data()['headEmail'];
        data['safetyInchargeName'] = value.data()['safetyInchargeName'];
        data['safetyInchargeEmail'] = value.data()['safetyInchargeEmail'];
        data['fireInchargeName'] = value.data()['fireInchargeName'];
        data['fireInchargeEmail'] = value.data()['fireInchargeEmail'];
        data['officeSafetyInchargeName'] =
            value.data()['officeSafetyInchargeName'];
        data['officeSafetyInchargeEmail'] =
            value.data()['officeSafetyInchargeEmail'];
        data['utilitiesName'] = value.data()['utilitiesName'];
        data['utilitiesEmail'] = value.data()['utilitiesEmail'];
        data['foundryUrl'] = value.data()['foundryUrl'] ?? null;
        data['pressUrl'] = value.data()['pressUrl'] ?? null;
        data['thinnerUrl'] = value.data()['thinnerUrl'] ?? null;
        data['toxicUrl'] = value.data()['toxicUrl'] ?? null;
        data['heatUrl'] = value.data()['heatUrl'] ?? null;
        data['boilerUrl'] = value.data()['boilerUrl'] ?? null;
        data['rule'] = value.data()['rule'];
        data['ruleValue'] = value.data()['ruleValue'];
        data['lpg'] = value.data()['lpg'];
        data['lpgValue'] = value.data()['lpgValue'];
        data['gasoline'] = value.data()['gasoline'];
        data['gasolineValue'] = value.data()['gasolineValue'];
        data['cng'] = value.data()['cng'];
        data['cngValue'] = value.data()['cngValue'];
        data['paintShop'] = value.data()['paintShop'];
        data['paintShopValue'] = value.data()['paintShopValue'];
        data['foundry'] = value.data()['foundry'];
        data['foundryValue'] = value.data()['foundryValue'];
        data['pressValue'] = value.data()['pressValue'];
        data['press'] = value.data()['press'];
        data['diesel'] = value.data()['diesel'];
        data['dieselValue'] = value.data()['dieselValue'];
        data['thinner'] = value.data()['thinner'];
        data['thinnerValue'] = value.data()['thinnerValue'];
        data['toxic'] = value.data()['toxic'];
        data['toxicValue'] = value.data()['toxicValue'];
        data['heat'] = value.data()['heat'];
        data['heatValue'] = value.data()['heatValue'];
        data['testBed'] = value.data()['testBed'];
        data['testBedValue'] = value.data()['testBedValue'];
        data['ibr'] = value.data()['ibr'];
        data['ibrValue'] = value.data()['ibrValue'];
        data['fatal'] = value.data()['fatal'];
        data['reportable'] = value.data()['reportable'];
        data['nonReportable'] = value.data()['nonReportable'];
        data['firstAid'] = value.data()['firstAid'];
        data['fire'] = value.data()['fire'];
      } else {
        data['documentId'] = documentID;
        data['dataExists'] = false;
      }
    });
    return data;
  }

  Future<void> uploadSelfAssessment(
      List<Map<String, dynamic>> map, String cycleId) async {
    await FirebaseFirestore.instance
        .collection('cycles')
        .doc(cycleId)
        .update({'selfAssessment': map});
  }

  Future<void> uploadSelfAssessmentFire(
      List<Map<String, dynamic>> map, String cycleId, String fileUrl) async {
    await FirebaseFirestore.instance.collection('cycles').doc(cycleId).update(
        {'selfAssessmentFire': map, 'selfAssessmentFireUrl': fileUrl});
  }

  Future<void> uploadSelfAssessmentOffice(
      List<Map<String, dynamic>> map, String cycleId) async {
    await FirebaseFirestore.instance
        .collection('cycles')
        .doc(cycleId)
        .update({'selfAssessmentOffice': map});
  }

  Future<void> uploadSiteAssessment(
      List<Map<String, dynamic>> map, String cycleId) async {
    await FirebaseFirestore.instance
        .collection('cycles')
        .doc(cycleId)
        .update({'siteAssessment': map});
  }

  Future<void> uploadSiteAssessmentFire(
      List<Map<String, dynamic>> map, String cycleId, String fileUrl) async {
    await FirebaseFirestore.instance.collection('cycles').doc(cycleId).update(
        {'siteAssessmentFire': map, 'siteAssessmentFireUrl': fileUrl});
  }

  Future<void> uploadSiteAssessmentOffice(
      List<Map<String, dynamic>> map, String cycleId) async {
    await FirebaseFirestore.instance
        .collection('cycles')
        .doc(cycleId)
        .update({'siteAssessmentOffice': map});
  }

  Future<List<List<Map<String, dynamic>>>> getSavedData(
      String cycleId, String assessmentType) async {
    List<Map<String, dynamic>> assessmentAnswers = [];
    List<Map<String, dynamic>> assessmentFireAnswers = [];
    List<Map<String, dynamic>> assessmentOfficeAnswers = [];
    List<List<Map<String, dynamic>>> returnList = [];
    List<Map<String, dynamic>> siteRiskProfile = [];
    List<Map<String, dynamic>> fireRiskProfile = [];
    List<Map<String, dynamic>> officeRiskProfile = [];
    List<Map<String, dynamic>> summaryOfRiskProfile = [];

    DocumentSnapshot dataSaved =
        await FirebaseFirestore.instance.collection('cycles').doc(cycleId).get();
    if (assessmentType == 'self') {
      if (dataSaved.data().containsKey('selfAssessment')) {
        assessmentAnswers = dataSaved.data()['selfAssessment'];
      } else {
        assessmentAnswers = List.generate(
            33,
            (index) => {
                  'answer': 0.0,
                  'comment': '',
                  'level': '1',
                  'filrUrl': '',
                  'suggestion': '',
                  'filled': false
                });
      }
      returnList.add(assessmentAnswers);

      if (dataSaved.data().containsKey('selfAssessmentFire')) {
        assessmentFireAnswers = dataSaved.data()['selfAssessmentFire'];
      } else {
        assessmentFireAnswers =
            List.generate(9, (index) => {'comment': '', 'answer': 'no'});
      }
      returnList.add(assessmentFireAnswers);
      if (dataSaved.data().containsKey('selfAssessmentOffice')) {
        assessmentOfficeAnswers = dataSaved.data()['selfAssessmentOffice'];
      } else {
        assessmentOfficeAnswers = List.generate(
            10, (index) => {'answer': 'no', 'comment': '', 'marks': 0.0});
      }
      returnList.add(assessmentOfficeAnswers);
    } else {
      if (dataSaved.data().containsKey('siteAssessment')) {
        assessmentAnswers = dataSaved.data()['siteAssessment'];
      } else {
        assessmentAnswers = List.generate(
            33,
            (index) => {
                  'answer': 0.0,
                  'comment': '',
                  'coComment': '',
                  'level': '1',
                  'filrUrl': '',
                  'suggestion': '',
                  'filled': false
                });
      }
      returnList.add(assessmentAnswers);

      if (dataSaved.data().containsKey('siteAssessmentFire')) {
        assessmentFireAnswers = dataSaved.data()['siteAssessmentFire'];
      } else {
        assessmentFireAnswers = List.generate(
            9,
            (index) =>
                {'comment': '', 'marks': 0, 'answer': 'no', 'coComment': ''});
      }
      returnList.add(assessmentFireAnswers);
      if (dataSaved.data().containsKey('siteAssessmentOffice')) {
        assessmentOfficeAnswers = dataSaved.data()['siteAssessmentOffice'];
      } else {
        assessmentOfficeAnswers = List.generate(
            10,
            (index) =>
                {'answer': 'no', 'comment': '', 'marks': 0.0, 'coComment': ''});
      }
      returnList.add(assessmentOfficeAnswers);
    }
    if (assessmentType == 'site') {
      if (dataSaved.data().containsKey('siteRiskProfile')) {
        siteRiskProfile = dataSaved.data()['siteRiskProfile'];
      } else {
        siteRiskProfile = List.generate(
            3, (index) => {'point1': '', 'point2': '', 'point3': ''});
      }
      returnList.add(siteRiskProfile);

      if (dataSaved.data().containsKey('fireRiskProfile')) {
        fireRiskProfile = dataSaved.data()['fireRiskProfile'];
      } else {
        fireRiskProfile = List.generate(
            3, (index) => {'point1': '', 'point2': '', 'point3': ''});
      }
      returnList.add(fireRiskProfile);

      if (dataSaved.data().containsKey('officeRiskProfile')) {
        officeRiskProfile = dataSaved.data()['officeRiskProfile'];
      } else {
        officeRiskProfile = List.generate(
            3, (index) => {'point1': '', 'point2': '', 'point3': ''});
      }
      returnList.add(officeRiskProfile);

      if (dataSaved.data().containsKey('summeryRiskProfile')) {
        summaryOfRiskProfile = dataSaved.data()['summeryRiskProfile'];
      } else {
        summaryOfRiskProfile = List.generate(
            3, (index) => {'point1': '', 'point2': '', 'point3': ''});
      }
      returnList.add(summaryOfRiskProfile);
    }
    return returnList;
  }

  //Future<String> uploadFile(File file) async {}

}
