import 'assessorLocationInfo.dart';
import 'assessorLocationInfoprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AssessorInfo extends StatelessWidget {
  final String cycleId;
  AssessorInfo({Key key, this.cycleId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AssessmentLocationInfoProvider>(
      create: (_) => AssessmentLocationInfoProvider(cycleId),
      child: AssessorLocationInfo(),
    );
  }
}
