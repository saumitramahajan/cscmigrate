import 'assessmentRepository.dart';
import 'package:flutter/cupertino.dart';

class AssessmentProvider extends ChangeNotifier {
  bool loading = true;
  bool success = false;
  bool dataLoading = true;
  bool uploadLoading = false;

  bool uploadSuccess = false;
  String assessmentType = '';
  double overAllTotal = 0;
  double processTotal = 0;
  double resultTotal = 0;
  double fireTotal = 0;
  double officeTotal = 0;
  String role = '';

  int self = 0;
  int selfAssessment = 0;
  int site = 0;
  int siteAssessment = 0;

  List<Map<String, dynamic>> listOfAssessment = [];

  List<Map<String, dynamic>> listOfFireAssessment = [];
  List<Map<String, dynamic>> listOfSiteAssessment = [];
  List<dynamic> listOfOfficeAssessment = [];
  List<Map<String, String>> listOfStatement = [];
  List<Map<String, String>> listOfStatementFire = [];
  List<Map<String, String>> listOfStatementOffice = [];
  List<Map<String, dynamic>> listOfFireRiskProfile = [];
  List<Map<String, dynamic>> listOfOfficeRiskProfile = [];
  List<Map<String, dynamic>> listOfSiteRiskProfile = [];
  List<Map<String, dynamic>> listOfSummaryRiskProfile = [];
  List<Map<String, dynamic>> listOfLocation = [];
  List<Map<String, String>> listOfLocations = [];
  final AssessmentRepository assessmentRepository = AssessmentRepository();

  AssessmentProvider(String type) {
    assessmentType = type;
    check();
  }

  Future<void> check() async {
    try {
      self = 0;
      site = 0;
      listOfLocations = await assessmentRepository.getLocation(assessmentType);


      if(assessmentType=='self'){
      selfAssessment = listOfLocations.length;
      for (int i = 0; i < selfAssessment; i++) {
        if (listOfLocations[i]['currentStatus'] == 'Self Assessment Uploaded') {
          self++;
        }
      }
      }else{

      siteAssessment = listOfLocations.length;
      for (int j = 0; j < siteAssessment; j++) {
        if (listOfLocations[j]['currentStatus'] == 'Site Assessment Uploaded' &&
            listOfLocations[j]['currentStatus'] == 'Approved by CoAssessor') {
          site++;
        }
      }
      }

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

  Future<void> csv() async {
    try {
      listOfLocation = await assessmentRepository.locationCSV();

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

  Future<void> approve(String cycleId, String lastAssessmentStageValue,
      String processLevel, String resultLevel, String heatMapUrl) async {
    await assessmentRepository.approve(cycleId, lastAssessmentStageValue,
        processLevel, resultLevel, heatMapUrl);
  }

  void getTotals(List<Map<String, dynamic>> assessment,
      List<Map<String, dynamic>> fire, List<dynamic> office) {
    overAllTotal = 0;
    processTotal = 0;
    resultTotal = 0;
    fireTotal = 0;
    officeTotal = 0;
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

  Future<void> upload(
      String point1,
      String point2,
      String point3,
      String point4,
      String point5,
      String wayForward1,
      String wayForwward2,
      String documentId) async {
    try {
      await assessmentRepository.upload(point1, point2, point3, point4, point5,
          wayForward1, wayForwward2, documentId);
      loading = false;
      uploadSuccess = true;
      notifyListeners();
    } catch (e) {
      print('Checkin error::' + e.toString() + '\n\n');
      loading = false;
      uploadSuccess = false;
      notifyListeners();
    }
  }
}
