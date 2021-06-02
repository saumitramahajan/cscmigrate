import 'package:flutter/material.dart';
import 'package:mahindraCSC/roles/admin/changeStatus/changeProvider.dart';
import 'package:mahindraCSC/roles/admin/changeStatus/changeStauts.dart';

import 'package:provider/provider.dart';

class ChangeStatusBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChangeStatusProvider>(
      create: (_) => ChangeStatusProvider(),
      child: ChangeStatus(),
    );
  }
}
