import 'assessorLocationListRepository.dart';
import 'package:flutter/cupertino.dart';

class AssessorLocationListInfoProvider extends ChangeNotifier {
  bool loading = true;
  bool success = false;

  List<Map<String, dynamic>> listOfAssessorLocation = [];

  final AssessorLocationListInfoRepository assessorRepository =
      AssessorLocationListInfoRepository();

  AssessorLocationListInfoProvider() {
    assessorInfo();
  }

  Future<void> assessorInfo() async {
    try {
      listOfAssessorLocation =
          await assessorRepository.getAssessorLocationInfo();

      loading = false;
      success = true;
      notifyListeners();
    } catch (e) {
      print('assessorInfo error::' + e.toString() + '\n\n');
      loading = false;
      success = false;
      notifyListeners();
    }
  }
}
