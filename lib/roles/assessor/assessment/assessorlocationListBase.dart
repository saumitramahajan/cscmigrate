import 'assessorLocationList.dart';
import 'assessorLocationListProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AssessorLocationInfoBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AssessorLocationListInfoProvider>(
      create: (_) => AssessorLocationListInfoProvider(),
      child: AssessorLocationListInfo(),
    );
  }
}
