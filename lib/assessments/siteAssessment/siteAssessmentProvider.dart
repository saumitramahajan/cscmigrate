//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:mahindraCSC/z_repository/assessmentRepository.dart';

class SiteAssessmentProvider extends ChangeNotifier {
  AssessentRepository assessentRepository = AssessentRepository();
  List<Map<String, dynamic>> questionList =
      List.generate(33, (index) => {'statement': ''});
  List<Map<String, dynamic>> fireQuestions = [];
  List<Map<String, dynamic>> officeQuestions = [];

  Map<String, dynamic> currentQuestion = {};
  int i = 1;
  double fireTotal = 20;
  double officeTotal = 0;
  bool locationData = false;
  bool saveLoading = false;
  bool loadingSaveData = true;
  bool locationDataLoading = true;
  bool locationDataUploading = false;
  bool buttonLoading = false;
  Map<String, dynamic> locationInfo = {};
  String type = '';
  String assessmentType = '';
  String cycleId = '';
  bool loading = true;
  String errorString = 'no error';
  List<Map<String, dynamic>> fireanswers = [];
  List<Map<String, dynamic>> officeAnswers = [];

  List<Map<String, dynamic>> assessmentAnswers = [];
  List<Map<String, dynamic>> siteRiskProfile = [];
  List<Map<String, dynamic>> fireRiskProfile = [];
  List<Map<String, dynamic>> officeRiskProfile = [];
  List<Map<String, dynamic>> summaryOfRiskProfile = [];

  double assessmentTotal = 0;

  SiteAssessmentProvider(String assessmentTypeI, String cycleIdI) {
    assessmentType = assessmentTypeI;
    cycleId = cycleIdI;
    if (assessmentTypeI != 'site') {
      getLocationInfo();
    }
    getQuestions();
    getSavedData(cycleId, assessmentType);
  }

  Future<void> getSavedData(String cycleId, String assessmentType) async {
    try {
      List<List<Map<String, dynamic>>> returnList =
          await assessentRepository.getSavedData(cycleId, assessmentType);

      assessmentAnswers = returnList[0];
      fireanswers = returnList[1];
      officeAnswers = returnList[2];
      if (assessmentType == 'site') {
        siteRiskProfile = returnList[3];
        fireRiskProfile = returnList[4];
        officeRiskProfile = returnList[5];
        summaryOfRiskProfile = returnList[6];
      }
      assessmentTotal = 0;
      for (int x = 0; x < assessmentAnswers.length; x++) {
        assessmentTotal = assessmentTotal + assessmentAnswers[x]['answer'];
      }
      loadingSaveData = false;
      notifyListeners();
    } catch (e) {
      
      loadingSaveData = false;
      notifyListeners();
    }
  }

  bool filledData() {
    bool flag = true;
    for (int i = 0; i < assessmentAnswers.length; i++) {
      if (assessmentAnswers[i]['filled'] == false) {
        flag = false;
      }
    }
    return flag;
  }

  Future<void> getLocationInfo() async {
    locationInfo = await assessentRepository.getLocationInfo(cycleId);
    if (locationInfo['dataExists']) {
      locationDataLoading = false;
      locationData = true;
    } else {
      locationDataLoading = false;
      locationData = false;
    }
    notifyListeners();
  }

  Future<void> getQuestions() async {
    try {
      questionList = await assessentRepository.getAssessmentQuestions();
      type = 'assessment';
      print('getDone');
      setMap(type);
      print('mapSet');
      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      notifyListeners();
    }
  }

  void setMap(String typeI) {
    print(i);
    switch (typeI) {
      case 'assessment':
        {
          print('SetmapAssessmentCalled');
          for (int j = 0; j < questionList.length; j++) {
            if (questionList[j]['number'] == i) {
              print('QuestionSet');
              currentQuestion = questionList[j];
              break;
            }
          }
        }
        break;
    }
  }

  Map<String, dynamic> setAssessment(
      {@required double value,
      @required String comment,
      @required String suggestion,
      String fileurl,
      @required String level}) {
    print(i);
    //String downloadUrl =

    Map<String, dynamic> map = {
      'answer': value,
      'comment': comment,
      'level': level,
      'fileUrl': fileurl,
      'suggestion': suggestion,
    };
    if (assessmentAnswers.length < i) {
      assessmentAnswers.add(map);
    } else {
      assessmentAnswers.removeAt(i - 1);
      assessmentAnswers.insert(i - 1, map);
    }
    print(assessmentType);
    print(assessmentAnswers.toString());
    i++;
    setMap(type);
    notifyListeners();

    Map<String, dynamic> returnMap = {};
    if (assessmentAnswers.length > i - 1) {
      returnMap['value'] = assessmentAnswers[i - 1]['answer'];
      returnMap['level'] = assessmentAnswers[i - 1]['level'];
      returnMap['comment'] = assessmentAnswers[i - 1]['comment'];
      returnMap['suggestion'] = assessmentAnswers[i - 1]['suggestion'];
      returnMap['fileUrl'] = assessmentAnswers[i - 1]['fileUrl'];
    } else {
      print('return null map' +
          assessmentAnswers.length.toString() +
          i.toString());
      returnMap['value'] = 0.0;
      returnMap['level'] = '1';
      returnMap['comment'] = '';
      returnMap['suggestion'] = '';
      returnMap['fileUrl'] = null;
    }
    return returnMap;
  }

  Map<String, dynamic> previousPressed() {
    i--;
    setMap(type);
    notifyListeners();
    print('Previous Pressed: with $i');
    Map<String, dynamic> returnMap = {};
    returnMap['value'] = assessmentAnswers[i - 1]['answer'];
    returnMap['level'] = assessmentAnswers[i - 1]['level'];
    returnMap['comment'] = assessmentAnswers[i - 1]['comment'];
    returnMap['suggestion'] = assessmentAnswers[i - 1]['suggestion'];
    returnMap['fileUrl'] = assessmentAnswers[i - 1]['fileUrl'];
    return returnMap;
  }

  void submited(
      {double value,
      String comment,
      String fileUrl,
      String suggestion,
      bool filled,
      @required String level}) {
    Map<String, dynamic> map = {
      'answer': value,
      'comment': comment,
      'level': level,
      'fileUrl': fileUrl,
      'suggestion': suggestion,
      'filled': filled,
    };
    if (assessmentAnswers.length < i) {
      assessmentAnswers.add(map);
    } else {
      assessmentAnswers.removeAt(i - 1);
      assessmentAnswers.insert(i - 1, map);
    }
    assessmentTotal = 0;
    for (int x = 0; x < assessmentAnswers.length; x++) {
      assessmentTotal = assessmentTotal + assessmentAnswers[x]['answer'];
    }
    print(assessmentAnswers.toString());
  }

  Future<void> uploadSelfAssessment(String button) async {
    if (button == 'save') {
      buttonLoading = true;
    } else {
      saveLoading = true;
    }
    notifyListeners();
    await assessentRepository.uploadSelfAssessment(assessmentAnswers, cycleId);
    if (button == 'save') {
      buttonLoading = false;
    } else {
      saveLoading = false;
    }
    notifyListeners();
  }

  Future<void> uploadSiteAssessment(String button) async {
    if (button == 'save') {
      buttonLoading = true;
    } else {
      saveLoading = true;
    }
    notifyListeners();
    await assessentRepository.uploadSiteAssessment(assessmentAnswers, cycleId);
    if (button == 'save') {
      buttonLoading = false;
    } else {
      saveLoading = false;
    }
    notifyListeners();
  }

  void beforeSubmitTapped(int value, String type) {
    i = value;
    setMap(type);
  }

  Future<void> getFireQuestions() async {
    try {
      loading = true;
      notifyListeners();
      fireQuestions = await assessentRepository.getFireQuestions();
      i = 1;
      type = 'fire';
      setMap(type);
      loading = false;
      notifyListeners();
    } catch (e) {
      
      print('FireQuestion Error:: ' + e.toString() + '\n\n');
      loading = false;
      notifyListeners();
    }
  }

  Future<void> setFireAssessment(
      List<Map<String, dynamic>> answer, String fileUrl) async {
    try {
      buttonLoading = true;
      notifyListeners();
      fireanswers = answer;
      fireTotal = 0;
      fireanswers.forEach((question) {
        String marks = question['marks'].toString();
      
        double marksD = double.tryParse(marks) ?? 0.0;
        print(marksD);
      
        fireTotal = fireTotal + marksD;
      });
      if (assessmentType == 'site') {
        await assessentRepository.uploadSiteAssessmentFire(
            fireanswers, cycleId, fileUrl);
      } else {
        await assessentRepository.uploadSelfAssessmentFire(
            fireanswers, cycleId, fileUrl);
      }
      print(fireanswers.toString());
      buttonLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      errorString = errorString+e.toString();
      
      buttonLoading = false;
      notifyListeners();

          
    }
  }

  Future<void> getOfficeQuestions() async {
    try {
      loading = true;
      notifyListeners();
      officeQuestions = await assessentRepository.getOfficeQuestions();
      i = 1;
      type = 'office';
      setMap(type);
      loading = false;
      notifyListeners();
    } catch (e) {
      print('officeQuestion Error:: ' + e.toString() + '\n\n');
      errorString = errorString + e.toString();
      loading = false;
      notifyListeners();
    }
  }

  Future<void> setOfficeAssessment(List<Map<String, dynamic>> answer) async {
    buttonLoading = true;
    notifyListeners();
    officeAnswers = answer;
    officeTotal = 0;
    officeAnswers.forEach((question) {
      String marks = question['marks'].toString();

      double marksD = double.tryParse(marks) ?? 0.0;
      print(marksD);
      officeTotal = officeTotal + marksD;
    });
    if (assessmentType == 'site') {
      await assessentRepository.uploadSiteAssessmentOffice(
          officeAnswers, cycleId);
    } else {
      await assessentRepository.uploadSelfAssessmentOffice(
          officeAnswers, cycleId);
    }
    print(officeAnswers.toString());
    buttonLoading = false;
    notifyListeners();
  }

  Future<void> setLocationData(
    final String documentId,
    final String siteName,
    final String occupierName,
    final String occupierEmail,
    final String headName,
    final String headEmail,
    final String safetyInchargeName,
    final String safetyInchargeEmail,
    final String fireInchargeName,
    final String fireInchargeEmail,
    final String officeSafetyInchargeName,
    final String officeSafetyInchargeEmail,
    final String utilitiesName,
    final String utilitiesEmail,
    final String rule,
    final String lpg,
    final String gasoline,
    final String cng,
    final String paintShop,
    final String foundry,
    final String press,
    final String desiel,
    final String thinner,
    final String toxic,
    final String heat,
    final String testBed,
    final String ibr,
    final String fatal,
    final String reportable,
    final String nonReportable,
    final String firstAid,
    final String fire,
    final String foundryUrl,
    final String pressUrl,
    final String thinnerUrl,
    final String toxicUrl,
    final String heatUrl,
    final String boilerUrl,
    final bool ruleValue,
    final bool lpgValue,
    final bool gasolineValue,
    final bool cngValue,
    final bool paintShopValue,
    final bool foundryValue,
    final bool pressValue,
    final bool desielValue,
    final bool thinnerValue,
    final bool toxicValue,
    final bool heatValue,
    final bool testBedValue,
    final bool ibrValue,
  ) async {
    locationDataUploading = true;
    notifyListeners();
    await FirebaseFirestore.instance
        .collection('locations')
        .doc(documentId)
        .collection('info')
        .doc('info')
        .set({
      'siteName': siteName,
      'occupierName': occupierName,
      'occupierEmail': occupierEmail,
      'headName': headName,
      'headEmail': headEmail,
      'safetyInchargeName': safetyInchargeName,
      'safetyInchargeEmail': safetyInchargeEmail,
      'fireInchargeName': fireInchargeName,
      'fireInchargeEmail': fireInchargeEmail,
      'officeSafetyInchargeName': officeSafetyInchargeName,
      'officeSafetyInchargeEmail': officeSafetyInchargeEmail,
      'utilitiesName': utilitiesName,
      'utilitiesEmail': utilitiesEmail,
      'foundryUrl': foundryUrl,
      'pressUrl': pressUrl,
      'thinnerUrl': thinnerUrl,
      'toxicUrl': toxicUrl,
      'heatUrl': heatUrl,
      'boilerUrl': boilerUrl,
      'rule': rule,
      'ruleValue': ruleValue,
      'lpg': lpg,
      'lpgValue': lpgValue,
      'gasoline': gasoline,
      'gasolineValue': gasolineValue,
      'cng': cng,
      'cngValue': cngValue,
      'paintShop': paintShop,
      'paintShopValue': paintShopValue,
      'foundry': foundry,
      'foundryValue': foundryValue,
      'press': press,
      'pressValue': pressValue,
      'diesel': desiel,
      'dieselValue': desielValue,
      'thinner': thinner,
      'thinnerValue': thinnerValue,
      'toxic': toxic,
      'toxicValue': toxicValue,
      'heat': heat,
      'heatValue': heatValue,
      'testBed': testBed,
      'testBedValue': testBedValue,
      'ibr': ibr,
      'ibrValue': ibrValue,
      'fatal': fatal,
      'reportable': reportable,
      'nonReportable': nonReportable,
      'firstAid': firstAid,
      'fire': fire,
    });
    locationDataUploading = false;
    notifyListeners();
  }
}
