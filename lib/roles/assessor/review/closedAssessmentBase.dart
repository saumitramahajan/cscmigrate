import 'package:flutter/material.dart';
import 'package:mahindraCSC/roles/assessor/review/closedAssessment.dart';
import 'package:mahindraCSC/roles/assessor/review/closedAssessmentProvider.dart';
import 'package:provider/provider.dart';

class ClosedAssessmentBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ClosedAssessmentProvider>(
      create: (_) => ClosedAssessmentProvider(),
      child: Closed(),
    );
  }
}
