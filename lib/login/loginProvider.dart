import 'package:flutter/widgets.dart';
import 'package:mahindraCSC/z_repository/userRepository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  final UserRepository userRepository = UserRepository();
  bool loading = false;
  bool userExists = false;
  List<dynamic> role = [];
  bool singleRole = true;
  String roleString = '';
  bool linkSent = false;

  Future<void> loginProvider(String email, String password) async {
    loading = true;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userExists = await userRepository.login(email, password);
    if (userExists) {
      role = await userRepository.getRoles();
      if (role.length == 1) {
        prefs.setBool('singleRole', true);
        singleRole = true;
        roleString = role[0];
        prefs.setString('role', role[0]);
      } else {
        prefs.setBool('singleRole', false);
        singleRole = false;
      }
    }
    loading = false;
    notifyListeners();
  }

  Future<void> passwordReset(String email) async {
    try {
      loading = true;
      notifyListeners();
      userRepository.sendLink(email);
      linkSent = true;
      notifyListeners();
    } catch (e) {
      linkSent = false;
      loading = false;
      notifyListeners();
    }
  }
}
