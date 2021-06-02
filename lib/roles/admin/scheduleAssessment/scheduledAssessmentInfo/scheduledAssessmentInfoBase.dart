import 'package:flutter/material.dart';
import 'package:mahindraCSC/roles/admin/scheduleAssessment/scheduledAssessmentInfo/scheduleAssessmentInfo.dart';
import 'package:mahindraCSC/roles/admin/scheduleAssessment/scheduledAssessmentInfo/scheduledInfoProvider.dart';
import 'package:provider/provider.dart';

class ScheduleAssessmentInfoBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScheduledAssessmentInfoProvider>(
      create: (_) => ScheduledAssessmentInfoProvider(),
      child: ScheduleAssesmentInfo(),
    );
  }
}
