
import 'package:flutter/material.dart';
import 'package:mahindraCSC/roles/assessee/assesseeClosedAssessment.dart';
import 'package:mahindraCSC/roles/assessee/assesseeClosedProvider.dart';
import 'package:provider/provider.dart';
class AssesseeClosedBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AssesseeClosedProvider>(
      create: (_) => AssesseeClosedProvider(),
      child: AssesseeClosedAssessment(),
    );
  }
}