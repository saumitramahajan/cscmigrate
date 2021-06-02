import 'package:cloud_firestore/cloud_firestore.dart';

class AssessmentLocationInfoRepository {
  Future<Map<String, dynamic>> getassessorInfo(String cycleId) async {
    String locationId = '';
    await FirebaseFirestore.instance
        .collection('cycles')
        .doc(cycleId)
        .get()
        .then((cycle) async {
      locationId = cycle.data()['documentId'];
    });
    DocumentSnapshot info = await FirebaseFirestore.instance
        .collection('locations')
        .doc(locationId)
        .collection('info')
        .doc('info')
        .get();

    DocumentSnapshot previous = await FirebaseFirestore.instance
        .collection('locations')
        .doc(locationId)
        .get();

    Map<String, dynamic> keys = {
      'lastAssessmentStage': previous.data()['lastAssessmentStage'],
      'processLevel': previous.data()['processLevel'],
      'resultLevel': previous.data()['resultLevel'],
      'siteName': info.data()['siteName'],
      'occupierName': info.data()['occupierName'],
      'occupierEmail': info.data()['occupierEmail'],
      'headName': info.data()['headName'],
      'headEmail': info.data()['headEmail'],
      'safetyInchargeName': info.data()['safetyInchargeName'],
      'safetyInchargeEmail': info.data()['safetyInchargeEmail'],
      'fireInchargeName': info.data()['fireInchargeName'],
      'fireInchargeEmail': info.data()['fireInchargeEmail'],
      'officeSafetyInchargeName': info.data()['officeSafetyInchargeName'],
      'officeSafetyInchargeEmail': info.data()['officeSafetyInchargeEmail'],
      'utilitiesName': info.data()['utilitiesName'],
      'utilitiesEmail': info.data()['utilitiesEmail'],
      'rule': info.data()['rule'],
      'ruleValue': info.data()['ruleValue'],
      'lpg': info.data()['lpg'],
      'lpgValue': info.data()['lpgValue'],
      'gasoline': info.data()['gasoline'],
      'gasolineValue': info.data()['gasolineValue'],
      'cng': info.data()['cng'],
      'cngValue': info.data()['cngValue'],
      'paintShop': info.data()['paintShop'],
      'paintShopValue': info.data()['paintShopValue'],
      'foundry': info.data()['foundry'],
      'foundryValue': info.data()['foundryValue'],
      'press': info.data()['press'],
      'pressValue': info.data()['pressValue'],
      'diesel': info.data()['diesel'],
      'dieselValue': info.data()['dieselValue'],
      'thinner': info.data()['thinner'],
      'thinnerValue': info.data()['thinnerValue'],
      'toxic': info.data()['toxic'],
      'toxicValue': info.data()['toxicValue'],
      'heat': info.data()['heat'],
      'heatValue': info.data()['heatValue'],
      'testBed': info.data()['testBed'],
      'testBedValue': info.data()['testBedValue'],
      'ibr': info.data()['ibr'],
      'ibrValue': info.data()['ibrValue'],
      'fatal': info.data()['fatal'],
      'reportable': info.data()['reportable'],
      'nonReportable': info.data()['nonReportable'],
      'firstAid': info.data()['firstAid'],
      'fire': info.data()['fire'],
      'foundryUrl': info.data()['foundryUrl'],
      'pressUrl': info.data()['pressUrl'],
      'thinnerUrl': info.data()['thinnerUrl'],
      'toxicUrl': info.data()['toxicUrl'],
      'heatUrl': info.data()['heatUrl'],
      'ibrUrl': info.data()['ibrUrl'],
    };
    print('repository ' + keys.toString());
    return keys;
  }
}
