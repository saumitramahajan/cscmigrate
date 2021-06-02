import 'package:flutter/material.dart';
import 'package:mahindraCSC/assessments/siteAssessment/siteAssessmentProvider.dart';
import 'package:mahindraCSC/assessments/siteAssessment/siteRiskProfile.dart';
import 'package:provider/provider.dart';

class SiteRiskProfileBase extends StatefulWidget {
  @override
  _SiteRiskProfileBaseState createState() => _SiteRiskProfileBaseState();
}

class _SiteRiskProfileBaseState extends State<SiteRiskProfileBase> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SiteAssessmentProvider>(context);
    return provider.loadingSaveData
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ChangeNotifierProvider.value(
            value: provider,
            child: SiteRiskProfile(
                cycleId: provider.cycleId,
                preFilledData: provider.siteRiskProfile),
          );
  }
}
