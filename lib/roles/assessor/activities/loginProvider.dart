import 'package:flutter/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'userRepository.dart';
import 'package:flutter/material.dart';

class ActivitiesProvider extends ChangeNotifier {
  final ActivitiesRepository userRepository = ActivitiesRepository();
  bool loading = false;
  bool userExists = false;
  List<dynamic> role = [];
  bool singleRole = true;
  String roleString = '';
  bool linkSent = false;
  final pdf = pw.Document();

  List<Map<String, dynamic>> listOfDetails = [];

  ActivitiesProvider() {
    loginProvider();
  }

  Future<void> loginProvider() async {
    print('Called');
    loading = true;
    notifyListeners();

    listOfDetails = await userRepository.getDetails();
    print(listOfDetails.toString());

    loading = false;
    notifyListeners();
  }
}
