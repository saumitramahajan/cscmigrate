import 'package:flutter/material.dart';
import 'scheduleAssessmentForm.dart';
import 'scheduleAssessmentProvider.dart';
import 'package:provider/provider.dart';

class ScheduleAssessment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScheduleAssessmentProvider>(
      create: (_) => ScheduleAssessmentProvider(),
      child: ScheduleAssessmentForm(),
    );
  }
}
