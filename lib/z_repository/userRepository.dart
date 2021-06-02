import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  Future<String> getUid() async {
    User user = await FirebaseAuth.instance.currentUser;
    return user.uid;
  }

  Future<bool> login(String email, String password) async {
    try {
      UserCredential result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print(result.user.toString());
      if (result.user == null) {
        return false;
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('loggedIn', true);
        return true;
      }
    } catch (e) {
      print('singin error::' + e.toString() + '\n\n');
      return false;
    }
  }

  Future<List<dynamic>> getRoles() async {
    String uid = await getUid();
    DocumentSnapshot value =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    List<dynamic> role = value.data()['role'];
    return role;
  }

  Future<void> sendLink(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
