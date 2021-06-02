import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:mahindraCSC/z_repository/userRepository.dart';

class AssesseeProvider extends ChangeNotifier {
  final UserRepository userRepository = UserRepository();

  Future<String> getLocationName() async {
    String cycleId = '';
    String uid = '';
   User user = FirebaseAuth.instance.currentUser;
    uid=user.uid;
    await FirebaseFirestore.instance
        .collection('cycles')
        .where('assesseeUid', isEqualTo: uid)
        .get()
        .then((value) => cycleId = value.docs[0].id);
    return cycleId;
  }
}
