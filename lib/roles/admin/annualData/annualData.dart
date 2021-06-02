import 'package:flutter/material.dart';
import 'package:mahindraCSC/roles/admin/annualData/annualDataPage.dart';
import 'package:mahindraCSC/roles/admin/annualData/annualDataProvider.dart';
import 'package:provider/provider.dart';

class AnnualData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AnnualDataProvider(),
      child: AnnualDataForm(),
    );
  }
}
