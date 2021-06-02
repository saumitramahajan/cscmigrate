import 'package:flutter/cupertino.dart';
import 'package:mahindraCSC/roles/assessee/review/assesseeRepository.dart';

class AssesseeNewProvider extends ChangeNotifier {
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
  int selectedIndex;

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

  List<Map<String, String>> listOfLocations = [];
  final AssesseeRepository assessmentRepository = AssesseeRepository();

  AssesseeNewProvider(String type) {
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
      listOfAssessment =
          await assessmentRepository.getSiteAssessmentData(documentId);
      listOfFireAssessment =
          await assessmentRepository.getSiteFireAssessmentData(documentId);
      listOfOfficeAssessment =
          await assessmentRepository.getSiteOfficeAssessmentData(documentId);

      listOfStatement = await assessmentRepository.getsiteAssessmentStatement();
      listOfStatementFire =
          await assessmentRepository.getsiteAssessmentStatementFire();
      listOfStatementOffice =
          await assessmentRepository.getsiteAssessmentStatementOffice();

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

   void setIndex(int index) {
    selectedIndex = index;
    print(selectedIndex);
  }


  Future<void> editSiteUploadData(
    String documentID,
  ) async {
    uploadLoading = true;
    notifyListeners();
    try {
      await assessmentRepository.editSiteUpload(listOfAssessment,
           documentID);

      uploadLoading = false;

      notifyListeners();
    } catch (e) {
      print('check error::' + e.toString() + '\n\n');
      uploadLoading = false;

      notifyListeners();
    }
  }
}
