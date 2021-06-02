import 'package:flutter/material.dart';
import 'package:mahindraCSC/roles/admin/annualData/annualDataLocationsPage.dart';
import 'package:mahindraCSC/roles/admin/annualData/annualDataProvider.dart';

import 'package:provider/provider.dart';

class AnnualDataBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AnnualDataProvider(),
      child: AnnualDataLocations(),
    );
  }
}
