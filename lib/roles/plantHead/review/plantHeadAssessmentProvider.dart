import 'package:flutter/cupertino.dart';
import 'package:mahindraCSC/roles/plantHead/review/assessmentRepository.dart';

class PlantProvider extends ChangeNotifier {
  final PlantHeadAssessmentRepository assessmentRepository =
      PlantHeadAssessmentRepository();
  List<Map<String, dynamic>> selfAssessmentList = [];
  List<Map<String, dynamic>> selfAssessmentFireList = [];
  List<Map<String, dynamic>> selfAssessmentOfficeList = [];
  List<Map<String, String>> listOfStatement = [];
  List<Map<String, String>> listOfStatementFire = [];
  List<Map<String, String>> listOfStatementOffice = [];
  bool loading = true;
  bool dataExists = false;
  String name = '';
  String location = '';
  String errorString = 'noError';
  String list = 'empty';
  String cycleId = '';
  PlantProvider() {
    getData();
  }

  Future<void> getData() async {
    try {
      list = list + 'initialized';
      cycleId = await assessmentRepository.getCycleId();
      list = list + cycleId;
      if (cycleId != 'no') {
        List<List<Map<String, dynamic>>> assessmentData =
            await assessmentRepository.getData(cycleId);
        list = list + assessmentData.toString();
        if (assessmentData.length != 0) {
          dataExists = true;

          selfAssessmentList = assessmentData[0];
          selfAssessmentFireList = assessmentData[1];
          selfAssessmentOfficeList = assessmentData[2];
          name = assessmentData[3][0]['name'];
          location = assessmentData[3][0]['location'];
          listOfStatement =
              await assessmentRepository.getsiteAssessmentStatement();
          listOfStatementFire =
              await assessmentRepository.getsiteAssessmentStatementFire();
          listOfStatementOffice =
              await assessmentRepository.getsiteAssessmentStatementOffice();
        }
      }

      loading = false;
      notifyListeners();
    } catch (e) {
      errorString = errorString + e.toString();
      loading = false;
      notifyListeners();
    }
  }

  Future<void> approveAssessment() async {
    await assessmentRepository.approveAssessment(cycleId);
  }
}
