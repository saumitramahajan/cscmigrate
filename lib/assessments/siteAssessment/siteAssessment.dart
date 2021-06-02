import 'package:flutter/material.dart';
import 'package:mahindraCSC/assessments/siteAssessment/siteAssessmentProvider.dart';
import 'package:mahindraCSC/assessments/siteAssessment/siteRiskProfileBase.dart';
import 'package:provider/provider.dart';

import 'locationInfoBase.dart';

class SiteAssessment extends StatelessWidget {
  final String type;
  final String cycleId;
  List<Map<String, dynamic>> trial = List.generate(
      3,
      (index) => {
            'point1': 'a',
            'point2': 'b',
            'point3': 'c',
          });
  SiteAssessment(this.type, this.cycleId);

  @override
  Widget build(BuildContext context) {
    return (type == 'site')
        ? ChangeNotifierProvider(
            create: (_) => SiteAssessmentProvider(type, cycleId),
            child: SiteRiskProfileBase(),
          )
        : ChangeNotifierProvider(
            create: (_) => SiteAssessmentProvider(type, cycleId),
            child: LocationInfoBase(),
          );
  }
}
