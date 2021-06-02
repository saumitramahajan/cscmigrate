import 'package:flutter/cupertino.dart';
import 'package:mahindraCSC/z_repository/adminRepository.dart';

class ClosedProvider extends ChangeNotifier {
  bool infoloading = true;
  bool infosuccess = false;
  String locationId = '';

  List<Map<String, dynamic>> infoMap = [];
  bool dataLoading = true;

  bool success = false;
  AdminRepository adminRepository = AdminRepository();
  bool loading = false;
  bool uploadSuccess=false;
  List<Map<String, String>> closedAssessmentList = [];
  List<Map<String, String>> infolist = [];
  List<Map<String, dynamic>> listOfFireRiskProfile = [];
  List<Map<String, dynamic>> listOfOfficeRiskProfile = [];
  List<Map<String, dynamic>> listOfSiteRiskProfile = [];
  List<Map<String, dynamic>> listOfSummaryRiskProfile = [];
  List<Map<String, dynamic>> listOfAssessment = [];
  List<Map<String, dynamic>> listOfClosedAssessmentData = [];
  Map<String, dynamic> listOfValues = {};

  List<Map<String, String>> mainList = [];
  ClosedProvider() {
    getClosedAssessment();
  }

  Future<void> getClosedAssessment() async {
    loading = true;
    notifyListeners();
    try {
      mainList = await adminRepository.getClosedAssessment();
      closedAssessmentList = mainList;

      loading = false;

      notifyListeners();
    } catch (e) {
      print('check error::' + e.toString() + '\n\n');

      loading = false;

      notifyListeners();
    }
  }

  Future<void> filter(
      String groupValue, String query, String monthValue) async {
    loading = true;
    notifyListeners();
    closedAssessmentList = [];
    switch (groupValue) {
      case 'site':
        {
          for (int i = 0; i < mainList.length; i++) {
            if (mainList[i]['name']
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                mainList[i]['location']
                    .toLowerCase()
                    .contains(query.toLowerCase())) {
              closedAssessmentList.add(mainList[i]);
            }
          }
        }
        break;
      case 'month':
        {
          for (int i = 0; i < mainList.length; i++) {
            if (mainList[i]['scheduledDate'].substring(3, 5) == monthValue) {
              closedAssessmentList.add(mainList[i]);
            }
          }
        }
        break;
      case 'assessor':
        {
          for (int i = 0; i < mainList.length; i++) {
            if (mainList[i]['assessorName']
                .toLowerCase()
                .contains(query.toLowerCase())) {
              closedAssessmentList.add(mainList[i]);
            }
          }
        }
        break;
      case 'coAssessor':
        {
          for (int i = 0; i < mainList.length; i++) {
            if (mainList[i]['coAssessorName']
                .toLowerCase()
                .contains(query.toLowerCase())) {
              closedAssessmentList.add(mainList[i]);
            }
          }
        }
        break;
      case 'assessee':
        {
          for (int i = 0; i < mainList.length; i++) {
            if (mainList[i]['assesseeName']
                .toLowerCase()
                .contains(query.toLowerCase())) {
              closedAssessmentList.add(mainList[i]);
            }
          }
        }
        break;
    }
    loading = false;
    notifyListeners();
  }

  Future<void> riskProfiles(String documentId) async {
    dataLoading = true;
    notifyListeners();
    try {
      listOfFireRiskProfile =
          await adminRepository.getFireRiskProfile(documentId);
      listOfOfficeRiskProfile =
          await adminRepository.getOfficeRiskProfile(documentId);
      listOfSiteRiskProfile =
          await adminRepository.getSiteRiskProfile(documentId);
      listOfSummaryRiskProfile =
          await adminRepository.getSummaryRiskProfile(documentId);
      listOfAssessment =
          await adminRepository.getSiteAssessmentData(documentId);

      listOfValues = await adminRepository.getValues(documentId);

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

  
  Future<void> upload(  String point1,
      String point2,
      String point3,
      String point4,
      String point5,
      String wayForward1,
      String wayForwward2,
      String documentId) async {
    try {
      await adminRepository.upload(point1,point2,point3,point4,point5,wayForward1,wayForwward2,documentId);
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
