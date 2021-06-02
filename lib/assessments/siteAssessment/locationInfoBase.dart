import 'package:flutter/material.dart';
import 'package:mahindraCSC/assessments/siteAssessment/locationInfo.dart';
import 'package:mahindraCSC/assessments/siteAssessment/siteAssessmentProvider.dart';
import 'package:provider/provider.dart';

class LocationInfoBase extends StatefulWidget {
  @override
  _LocationInfoBaseState createState() => _LocationInfoBaseState();
}

class _LocationInfoBaseState extends State<LocationInfoBase> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SiteAssessmentProvider>(context);
    return provider.locationDataLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : (provider.locationData
            ? ChangeNotifierProvider.value(
                value: provider,
                child: LocationInfo(
                  siteName: provider.locationInfo['siteName'],
                  occupierName: provider.locationInfo['occupierName'],
                  occupierEmail: provider.locationInfo['occupierEmail'],
                  headName: provider.locationInfo['headName'],
                  headEmail: provider.locationInfo['headEmail'],
                  safetyInchargeName:
                      provider.locationInfo['safetyInchargeName'],
                  safetyInchargeEmail:
                      provider.locationInfo['safetyInchargeEmail'],
                  fireInchargeName: provider.locationInfo['fireInchargeName'],
                  fireInchargeEmail: provider.locationInfo['fireInchargeEmail'],
                  dataExists: provider.locationInfo['dataExists'],
                  officeSafetyInchargeName:
                      provider.locationInfo['officeSafetyInchargeName'],
                  officeSafetyInchargeEmail:
                      provider.locationInfo['officeSafetyInchargeEmail'],
                  utilitiesName: provider.locationInfo['utilitiesName'],
                  utilitiesEmail: provider.locationInfo['utilitiesEmail'],
                  rule: provider.locationInfo['rule'],
                  ruleValue: provider.locationInfo['ruleValue'],
                  lpg: provider.locationInfo['lpg'],
                  lpgValue: provider.locationInfo['lpgValue'],
                  gasoline: provider.locationInfo['gasoline'],
                  gasolineValue: provider.locationInfo['gasolineValue'],
                  cng: provider.locationInfo['cng'],
                  cngValue: provider.locationInfo['cngValue'],
                  paintShop: provider.locationInfo['paintShop'],
                  paintShopValue: provider.locationInfo['paintShopValue'],
                  foundry: provider.locationInfo['foundry'],
                  foundryValue: provider.locationInfo['foundryValue'],
                  press: provider.locationInfo['press'],
                  pressValue: provider.locationInfo['pressValue'],
                  desiel: provider.locationInfo['diesel'],
                  desielValue: provider.locationInfo['dieselValue'],
                  thinner: provider.locationInfo['thinner'],
                  thinnerValue: provider.locationInfo['thinnerValue'],
                  toxic: provider.locationInfo['toxic'],
                  toxicValue: provider.locationInfo['toxicValue'],
                  heat: provider.locationInfo['heat'],
                  heatValue: provider.locationInfo['heatValue'],
                  testBed: provider.locationInfo['testBed'],
                  testBedValue: provider.locationInfo['testBedValue'],
                  ibr: provider.locationInfo['ibr'],
                  ibrValue: provider.locationInfo['ibrValue'],
                  fatal: provider.locationInfo['fatal'],
                  reportable: provider.locationInfo['reportable'],
                  nonReportable: provider.locationInfo['nonReportable'],
                  firstAid: provider.locationInfo['firstAid'],
                  fire: provider.locationInfo['fire'],
                  documentId: provider.locationInfo['documentId'],
                  foundryUrl: provider.locationInfo['foundryUrl'],
                  pressUrl: provider.locationInfo['pressUrl'],
                  thinnerUrl: provider.locationInfo['thinnerUrl'],
                  heatUrl: provider.locationInfo['heatUrl'],
                  boilerUrl: provider.locationInfo['boilerUrl'],
                  toxicUrl: provider.locationInfo['toxicUrl'],
                ),
              )
            : ChangeNotifierProvider.value(
                value: provider,
                child: LocationInfo(
                  dataExists: false,
                  documentId: provider.locationInfo['documentId'],
                )));
  }
}
