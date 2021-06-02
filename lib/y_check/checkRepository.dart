import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckRepository {
  Future<bool> userExists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool user = prefs.getBool('loggedIn') ?? false;
    if (user) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> getUid() async {
    User user = await FirebaseAuth.instance.currentUser;
    return user.uid;
  }

  Future<List<dynamic>> getRoles() async {
    String uid = await getUid();
    DocumentSnapshot value =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    List<dynamic> role = value.data()['role'];
    return role;
  }
}
