import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AssessorLocationListInfoRepository {
  Future<String> getUid() async {
    User user = await FirebaseAuth.instance.currentUser;
    return user.uid;
  }

  // Future<List<Map<String, String>>> getAssessorLocationInfo() async {
  //   String uid = await getUid();
  //   List<Map<String, String>> locationList = [];

  //   QuerySnapshot cycles = await Firestore.instance
  //       .collection('cycles')
  //       .where('currentStatus', isEqualTo: 'Approved by PlantHead')

  //       .where('assessorUid', isEqualTo: uid)
  //       .getDocuments();
  //   for (int i = 0; i < cycles.documents.length; i++) {
  //     Map<String, String> locationMap = {
  //       'location': cycles.documents[i].data['location'],
  //       'name': cycles.documents[i].data['name'],
  //       'locationId': cycles.documents[i].documentID
  //     };
  //     locationList.add(locationMap);
  //   }

  //   return locationList;
  // }

  Future<List<Map<String, String>>> getAssessorLocationInfo() async {
    String uid = await getUid();
    List<Map<String, String>> locationList = [];

    QuerySnapshot cycles =
        await FirebaseFirestore.instance.collection('cycles').get();
    for (int i = 0; i < cycles.docs.length; i++) {
      if ((cycles.docs[i].data()['currentStatus'] =='Approved by PlantHead'||
             cycles.docs[i].data()['currentStatus'] =='Site Assessment Uploaded'||cycles.docs[i].data()['currentStatus'] ==
                'Approved by CoAssessor'||cycles.docs[i].data()['currentStatus'] =='Closed') &&
         ( cycles.docs[i].data()['assessorUid'] == uid||cycles.docs[i].data()['coAssessorUid'] == uid)) {
        Map<String, String> locationMap = {
          'location': cycles.docs[i].data()['location'],
          'name': cycles.docs[i].data()['name'],
          'locationId': cycles.docs[i].id
        };
        locationList.add(locationMap);
      }
    }

    return locationList;
  }
}
