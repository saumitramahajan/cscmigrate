import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahindraCSC/z_repository/adminRepository.dart';

class ScheduledAssessmentInfoProvider extends ChangeNotifier {
  AdminRepository adminRepository = AdminRepository();

  bool loading = false;
  int selectedIndex;
  List<Map<String, String>> assessmentList = [];
  List<Map<String, String>> mainList = [];

  bool initialLoading = true;
  bool listLoading = true;

  int pending=0;
  int closed=0;
  int count=0;

  bool requesting = false;
  List<Map<String, String>> locationList = [];

  List<DropdownMenuItem> dropDownList = [];
  List<DropdownMenuItem> assessorList = [];

  ScheduledAssessmentInfoProvider() {
    getScheduleAssessmentInfo();
  }

  Future<void> getScheduleAssessmentInfo() async {
    loading = true;
    notifyListeners();
    try {
      mainList = await adminRepository.scheduledAssessmentList();
      assessmentList = mainList;

       
      count = assessmentList.length;
      for (int i = 0; i < count; i++) {
        if (assessmentList[i]['currentStatus'] == 'Closed') {
          closed++;
         
        }else{
          pending++;
        }
      }
     
      loading = false;

      notifyListeners();
    } catch (e) {
      print('check error::' + e.toString() + '\n\n');

      loading = false;

      notifyListeners();
    }
  }

  Future<void> deleteScheduledAssessment(String documentID, int index) async {
    loading = true;
    notifyListeners();
    try {
      await adminRepository.deleteScheduledAssessment(documentID);
      assessmentList.removeAt(index);
      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      notifyListeners();
    }
  }

  void setIndex(int index) {
    selectedIndex = index;
    print(selectedIndex);
  }

  Future<void> filter(
      String groupValue, String query, String monthValue) async {
    loading = true;
    notifyListeners();
    assessmentList = [];
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
              assessmentList.add(mainList[i]);
            }
          }
        }
        break;
      case 'month':
        {
          for (int i = 0; i < mainList.length; i++) {
            if (mainList[i]['scheduledDate'].substring(3, 5) == monthValue) {
              assessmentList.add(mainList[i]);
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
              assessmentList.add(mainList[i]);
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
              assessmentList.add(mainList[i]);
            }
          }
        }
        break;
    }
    loading = false;
    notifyListeners();
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

  Future<void> scheduleAssessment(
    String assessorUid,
    String coAssessorUid,
    DateTime scheduledDate,
    String documentId,
  ) async {
    requesting = true;
    notifyListeners();
    await adminRepository.editScheduledAssessment(
        assessorUid, coAssessorUid, scheduledDate, documentId);
    requesting = false;
    notifyListeners();
  }
}
