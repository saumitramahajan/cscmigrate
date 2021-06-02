import 'package:flutter/material.dart';
import 'package:mahindraCSC/roles/admin/scheduleAssessment/closed/closed.dart';
import 'package:mahindraCSC/roles/admin/scheduleAssessment/closed/closedProvider.dart';
import 'package:provider/provider.dart';

class ClosedBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ClosedProvider>(
      create: (_) => ClosedProvider(),
      child: ClosedAssessment(),
    );
  }
}
