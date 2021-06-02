import 'package:flutter/material.dart';
import 'package:mahindraCSC/roles/admin/annualData/annualDataProvider.dart';
import 'package:mahindraCSC/roles/admin/annualData/reviewAnnualData.dart';
import 'package:provider/provider.dart';

class ReviewAnnualDataBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AnnualDataProvider(),
      child: ReviewAnnualData(),
    );
  }
}
