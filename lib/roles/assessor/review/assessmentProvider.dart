import 'package:shared_preferences/shared_preferences.dart';

import 'assessmentRepository.dart';
import 'package:flutter/cupertino.dart';

class AssessmentProvider extends ChangeNotifier {
  bool loading = true;
  bool uploadLoading = false;
  bool success = false;
  bool dataLoading = true;
  String assessmentType = '';

  double overAllTotal = 0;
  double processTotal = 0;
  double resultTotal = 0;
  double fireTotal = 0;
  double officeTotal = 0;

  String role = '';
  bool userExists = true;
  bool singleRole =false;

  List<Map<String, dynamic>> listOfAssessment = [];

  List<Map<String, dynamic>> listOfFireAssessment = [];

  List<dynamic> listOfOfficeAssessment = [];
  List<Map<String, String>> listOfStatement = [];
  List<Map<String, String>> listOfStatementFire = [];
  List<Map<String, String>> listOfStatementOffice = [];
  List<Map<String, dynamic>> listOfFireRiskProfile = [];
  List<Map<String, dynamic>> listOfOfficeRiskProfile = [];
  List<Map<String, dynamic>> listOfSiteRiskProfile = [];
  List<Map<String, dynamic>> listOfSummaryRiskProfile = [];
  String uid;

  List<Map<String, String>> listOfLocations = [];
  final AssessmentRepository assessmentRepository = AssessmentRepository();

  AssessmentProvider(String type) {
    assessmentType = type;

    check();
  }

  Future<void> check() async {
    try {
      listOfLocations = await assessmentRepository.getLocation(assessmentType);


      loading = false;
      success = true;
      notifyListeners();
    } catch (e) {
      print('check error::' + e.toString() + '\n\n');
      loading = false;
      success = false;
      notifyListeners();
    }
  }

 
  Future<void> locations(String documentId) async {
    dataLoading = true;
    notifyListeners();
    try {
      if (assessmentType == 'self') {
        listOfAssessment =
            await assessmentRepository.getSelfAssessmentData(documentId);
        listOfFireAssessment =
            await assessmentRepository.getFireAssessmentData(documentId);
        listOfOfficeAssessment =
            await assessmentRepository.getOfficeAssessmentData(documentId);
      } else {
        //call function to get siteAssessmentData
        listOfAssessment =
            await assessmentRepository.getSiteAssessmentData(documentId);
        listOfFireAssessment =
            await assessmentRepository.getSiteFireAssessmentData(documentId);
        listOfOfficeAssessment =
            await assessmentRepository.getSiteOfficeAssessmentData(documentId);
        listOfFireRiskProfile =
            await assessmentRepository.getFireRiskProfile(documentId);
        listOfOfficeRiskProfile =
            await assessmentRepository.getOfficeRiskProfile(documentId);
        listOfSiteRiskProfile =
            await assessmentRepository.getSiteRiskProfile(documentId);
        listOfSummaryRiskProfile =
            await assessmentRepository.getSummaryRiskProfile(documentId);
      }
      listOfStatement = await assessmentRepository.getsiteAssessmentStatement();
      listOfStatementFire =
          await assessmentRepository.getsiteAssessmentStatementFire();
      listOfStatementOffice =
          await assessmentRepository.getsiteAssessmentStatementOffice();

      getTotals(listOfAssessment, listOfFireAssessment, listOfOfficeAssessment);

      dataLoading = false;
      success = true;
      notifyListeners();
    } catch (e) {
      print('location error::' + e.toString() + '\n\n');
      dataLoading = false;
      success = false;
      notifyListeners();
    }
  }

  Future<void> approveAssessment(String documentId) async {
    await assessmentRepository.approveAssessment(documentId);
    await assessmentRepository.editSiteUpload(listOfAssessment,
        listOfFireAssessment, listOfOfficeAssessment, documentId);
  }

  void getTotals(List<Map<String, dynamic>> assessment,
      List<Map<String, dynamic>> fire, List<dynamic> office) {
    for (int i = 0; i < assessment.length; i++) {
      overAllTotal = overAllTotal + assessment[i]['answer'];
      if (i < 25) {
        processTotal = processTotal + assessment[i]['answer'];
      } else {
        resultTotal = resultTotal + assessment[i]['answer'];
      }
    }
    for (int j = 1; j < listOfFireAssessment.length; j++) {
      Map<String, dynamic> fireMarks = fire[j];
      double marks = double.parse(fireMarks['marks'].toString());
      fireTotal = fireTotal + marks;
    }

    for (int k = 0; k < office.length; k++) {
      Map<String, dynamic> offi = office[k];
      double marks = double.parse(offi['marks'].toString());
      officeTotal = officeTotal + marks;
    }
  }

  Future<void> editSelfUploadData(
    String documentID,
  ) async {
    uploadLoading = true;
    notifyListeners();
    try {
      await assessmentRepository.editSelfUpload(listOfAssessment,
          listOfFireAssessment, listOfOfficeAssessment, documentID);

      uploadLoading = false;

      notifyListeners();
    } catch (e) {
      print('check error::' + e.toString() + '\n\n');
      uploadLoading = false;

      notifyListeners();
    }
  }

  Future<void> editSiteUploadData(
    String documentID,
  ) async {
    uploadLoading = true;
    notifyListeners();
    try {
      await assessmentRepository.editSiteUpload(listOfAssessment,
          listOfFireAssessment, listOfOfficeAssessment, documentID);

      uploadLoading = false;

      notifyListeners();
    } catch (e) {
      print('check error::' + e.toString() + '\n\n');
      uploadLoading = false;

      notifyListeners();
    }
  }
}
