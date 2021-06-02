import 'package:flutter/widgets.dart';
import 'package:mahindraCSC/roles/admin/enrollUsers/editUserInfo.dart';
import 'package:mahindraCSC/z_repository/adminRepository.dart';

class EnrollUsersProvider extends ChangeNotifier {
  AdminRepository adminRepository = AdminRepository();
  bool loading = false;
  bool enrolled = false;
  bool userLoading = false;
  bool updateLoading = false;
  int selectedIndex;
  bool filterLoading = false;
  String errorString ='no error';
  List<bool> roles =[false,false,false];
  List<Map<String, dynamic>> listOfUsers = [];

   List<Map<String, dynamic>> mainList = [];

  Future<void> enrollUser(String email, String name, bool assessorVal,
      bool assesseeVal, bool plantHeadVal) async {
    try {
      loading = true;
      notifyListeners();
      String uid = await adminRepository.registerUser(email);
      await adminRepository.uploadUserInfo(
          email, uid, name, assessorVal, assesseeVal, plantHeadVal);
      enrolled = true;
      notifyListeners();
    } catch (e) {
      errorString=errorString+e.toString();
      loading = false;
      enrolled = false;
      notifyListeners();
    }
  }

  void setIndex(int index) {
    selectedIndex = index;
    print(selectedIndex);
  }

  Future<void> role(List<dynamic>role) async {
    userLoading = true;
    notifyListeners();
    
    try {
      
      roles[0]=role.contains('assessor');
      roles[1]=role.contains('assessee');
      roles[2]=role.contains('plantHead');
      userLoading = false;
      notifyListeners();
    } catch (e) {
      userLoading = false;
      notifyListeners();
    }
  }



  Future<void> userList() async {
    userLoading = true;
    notifyListeners();
    try {
      mainList = await adminRepository.userList();
      listOfUsers=mainList;
      userLoading = false;
      notifyListeners();
    } catch (e) {
      userLoading = false;
      notifyListeners();
    }
  }

    Future<void> filter(String query) async {
    filterLoading = true;

    listOfUsers = [];

    for (int i = 0; i < mainList.length; i++) {
      if (mainList[i]['name']
              .toLowerCase()
              .contains(query.toLowerCase())) {
        listOfUsers.add(mainList[i]);
      }
    }

    filterLoading = false;
  }



  
}
