import 'package:flutter/material.dart';
import 'package:mahindraCSC/roles/admin/enrollUsers/enrollUsersForm.dart';
import 'package:mahindraCSC/roles/admin/enrollUsers/enrollUsersProvider.dart';
import 'package:provider/provider.dart';

class EnrollUsers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EnrollUsersProvider(),
      child: EnrollUsersForm(),
    );
  }
}
