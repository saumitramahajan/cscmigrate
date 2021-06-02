import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mahindraCSC/z_repository/adminRepository.dart';

class ViewLocationProvider extends ChangeNotifier {
  AdminRepository adminRepository = AdminRepository();
  bool loading = true;
  List<Map<String, String>> list = [];
  String error = 'start';
  
  List<Map<String, String>> infoList = [];

  bool enrolled = false;
  bool requesting = false;


  ViewLocationProvider() {
    getLocationList();
  }

  Future<void> getLocationList() async {
    try {
      list = await adminRepository.getLocationMap();
      // error = list.toString();
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
  }

  Future<void> enrollMahindraLocation(
      String category,
      String nameOfSector,
      String nameOfBusiness,
      String location,
      String lastAssessmentStage,
      String processLevel,
      String resultLevel,
      String assessee,
      String plantHead,
      String plantHeadName,
      String plantHeadEmail,
      String sectorBusinessSafetySpocName,
      String sectorBusinessSafetySpocEmail) async {
    try {
      loading = true;
      notifyListeners();
      adminRepository.mahindraLocationEnroll(
          category,
          nameOfSector,
          nameOfBusiness,
          location,
          lastAssessmentStage,
          processLevel,
          resultLevel,
          assessee,
          plantHead,
          plantHeadName,
          plantHeadEmail,
          sectorBusinessSafetySpocName,
          sectorBusinessSafetySpocEmail);
      enrolled = true;
      loading = false;
      notifyListeners();
    } catch (e) {
      enrolled = false;
      loading = false;
      notifyListeners();
    }
  }

  Future<void> enrollVendorLocation(
      String nameOfBusiness,
      String location,
      String assessee,
      String plantHeadName,
      String plantHeadEmail,
      String plantHeadPhoneNumber,
      String ssuPersonnelName,
      String ssuPersonnelEmail,
      String ssuPersonnelPhoneNUmber) async {
    try {
      loading = true;
      notifyListeners();
      adminRepository.vendorLocationEnroll(
          nameOfBusiness,
          location,
          assessee,
          plantHeadName,
          plantHeadEmail,
          plantHeadPhoneNumber,
          ssuPersonnelName,
          ssuPersonnelEmail,
          ssuPersonnelPhoneNUmber);
      enrolled = true;
      loading = false;
      notifyListeners();
    } catch (e) {
      enrolled = false;
      loading = false;
      notifyListeners();
    }
  }


}
