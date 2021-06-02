import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ActivitiesRepository {
  File pdfFile;
  bool uploaded = false;
  Future<String> getUid() async {
    User user = await FirebaseAuth.instance.currentUser;
    return user.uid;
  }

  Future<List<Map<String, dynamic>>> getDetails() async {
    String uid = await getUid();
    print('$uid');

    QuerySnapshot activities =
        await FirebaseFirestore.instance.collection('activities').get();
    List<Map<String, dynamic>> activity = [];

    for (int i = 0; i < activities.docs.length; i++) {
      List<dynamic> showTo = activities.docs[i]['showTo'];
      for (int j = 0; j < showTo.length; j++) {
        Map<String, dynamic> map = {};
        if (showTo[j]['role'] == 'assessee' && showTo[j]['uid'] == uid) {
          map['content'] = activities.docs[i]['content'];
          Timestamp date = activities.docs[i]['date'];
          DateTime dateTime =
              DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch);

          map['date'] = DateFormat('dd-MM-yyyy hh:mm').format(dateTime);

          map['type'] = showTo[j]['type'];
          map['cycleDocumentID'] = activities.docs[i]['cycleDocumentID'];
          print(map.toString());
          activity.add(map);
        }
      }
    }
    return activity;
  }
}
