import 'package:flutter/cupertino.dart';
import 'package:mahindraCSC/roles/assessor/review/closedassessmentAssessorRepository.dart';

class ClosedAssessmentProvider extends ChangeNotifier {
  ClosedAssessmentRepository assessmentRepository =
      ClosedAssessmentRepository();
  bool infoloading = true;
  bool infosuccess = false;
  String locationId = '';

  List<Map<String, dynamic>> infoMap = [];
  bool dataLoading = true;

  bool success = false;

  bool loading = false;
  bool siteExist = false;
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
  ClosedAssessmentProvider() {
    getClosedAssessment();
  }

  Future<void> getClosedAssessment() async {
    loading = true;
    notifyListeners();
    try {
      mainList = await assessmentRepository.getClosedAssessment();
      closedAssessmentList = mainList;

      if (closedAssessmentList.length != 0) {
        siteExist = true;
      }
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
      listOfAssessment =
          await assessmentRepository.getSiteAssessmentData(documentId);

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
}
