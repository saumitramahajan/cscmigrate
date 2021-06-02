import 'package:flutter/material.dart';
import 'package:mahindraCSC/roles/admin/review/assessmentProvider.dart';
import 'package:mahindraCSC/roles/admin/review/locations.dart';
import 'package:provider/provider.dart';

class RouteBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AssessmentProvider>(
      create: (_) => AssessmentProvider('self'),
      child: Locations(),
    );
  }
}
