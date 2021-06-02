import 'package:flutter/material.dart';
import 'package:mahindraCSC/z_repository/adminRepository.dart';

class ChangeStatusProvider extends ChangeNotifier {
  AdminRepository adminRepository = AdminRepository();

  bool loading = false;
  bool uploadLoading = false;
  String currentStatus;
  String error = 'no Error';

  List<Map<String, String>> assessmentList = [];
  List<Map<String, String>> mainList = [];

  ChangeStatusProvider() {
    getScheduleAssessmentInfo();
  }

  Future<void> getScheduleAssessmentInfo() async {
    loading = true;
    notifyListeners();
    try {
      mainList = await adminRepository.scheduledAssessmentList();
      assessmentList = mainList;
      loading = false;

      notifyListeners();
    } catch (e) {
      print('check error::' + e.toString() + '\n\n');

      loading = false;

      notifyListeners();
    }
  }

  Future<void> uploadStatus(
    int index,
  ) async {
    uploadLoading = true;
    notifyListeners();
    try {
      await adminRepository.changeStatus(assessmentList[index]['documentId'],
          assessmentList[index]['currentStatus']);
      uploadLoading = false;
      notifyListeners();
    } catch (e) {
      error = error + e.toString();
      uploadLoading = false;
      notifyListeners();
    }
  }
}
