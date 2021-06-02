import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:mahindraCSC/z_repository/adminRepository.dart';

class ScheduleAssessmentProvider extends ChangeNotifier {
  AdminRepository adminRepository = AdminRepository();
  bool initialLoading = true;
  bool listLoading = true;
  bool loading = false;
  bool requesting = false;
  List<Map<String, String>> locationList = [];

  List<DropdownMenuItem> dropDownList = [];
  List<DropdownMenuItem> assessorList = [];
  List<Map<String, String>> list = [];

  ScheduleAssessmentProvider() {
    getLocationList();
  }

  Future<void> getLocationList() async {
    locationList = await adminRepository.getLocationList();
    print('Done');
    DropdownMenuItem initial = DropdownMenuItem(
      child: Text('Select Location'),
      value: 'select',
    );
    dropDownList.add(initial);
    for (int i = 0; i < locationList.length; i++) {
      DropdownMenuItem item = DropdownMenuItem(
        value: locationList[i]['documentID'],
        child: Row(
          children: [
            Text(locationList[i]['nameOfSector'] + ','),
            Text(locationList[i]['location']),
          ],
        ),
      );
      dropDownList.add(item);
    }
    await adminRepository.getAssessorList().then((value) {
      DropdownMenuItem initial = DropdownMenuItem(
        child: Text('Select Assessor'),
        value: 'select',
      );
      assessorList.add(initial);
      for (int i = 0; i < value.length; i++) {
        DropdownMenuItem item = DropdownMenuItem(
          child: Text(value[i]['name']),
          value: value[i]['uid'],
        );
        assessorList.add(item);
      }
    });
    listLoading = false;
    notifyListeners();
  }

  Future<void> scheduleAssessment(String documentID, String assessorUid,
      String coAssessorUid, DateTime scheduledDate) async {
    requesting = true;
    notifyListeners();
    await adminRepository.scheduleAssessment(
        documentID, assessorUid, coAssessorUid, scheduledDate);
    requesting = false;
    notifyListeners();
  }
}
