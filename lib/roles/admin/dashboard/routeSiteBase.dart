import 'package:flutter/material.dart';
import 'package:mahindraCSC/roles/admin/review/assessmentProvider.dart';
import 'package:mahindraCSC/roles/admin/review/locations.dart';
import 'package:provider/provider.dart';

class RouteSiteBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AssessmentProvider>(
      create: (_) => AssessmentProvider('site'),
      child: Locations(),
    );
  }
}
