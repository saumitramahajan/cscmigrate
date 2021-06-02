import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mahindraCSC/z_repository/adminRepository.dart';

class EnrollLocationProvider extends ChangeNotifier {
  AdminRepository adminRepository = AdminRepository();
  List<DropdownMenuItem> assessee = [];
  List<DropdownMenuItem> plantHead = [];
  List<Map<String, String>> plantHeadList = [];
  List<Map<String, String>> assesseeList = [];
  bool loading = true;
  bool enrolled = false;

  EnrollLocationProvider() {
    getDropdownList();
    getPlantHeadDropdownList();
  }

  Future<void> getDropdownList() async {
    try {
      assesseeList = await adminRepository.getAssesseeMap();

      assessee = assesseeList.map((Map<String, String> value) {
        return DropdownMenuItem(
          child: Text(value['Name']),
          value: value['uid'],
        );
      }).toList();
    } catch (e) {}
  }

  Future<void> getPlantHeadDropdownList() async {
    try {
      plantHeadList = await adminRepository.getPlantHeadMap();

      plantHead = plantHeadList.map((Map<String, String> value) {
        return DropdownMenuItem(
          child: Text(value['Name']),
          value: value['uid'],
        );
      }).toList();
      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      notifyListeners();
    }
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
