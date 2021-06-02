import 'package:flutter/material.dart';
import 'package:mahindraCSC/login/choice.dart';
import 'package:mahindraCSC/login/login.dart';
import 'package:mahindraCSC/roles/admin/dashboard/adminDashboard.dart';
import 'package:mahindraCSC/roles/admin/dashboard/adminProvider.dart';
import 'package:mahindraCSC/roles/assessee/assesseeDashboard.dart';
import 'package:mahindraCSC/roles/assessee/assesseeProvider.dart';
import 'package:mahindraCSC/roles/assessor/assessorDashboard.dart';
import 'package:mahindraCSC/roles/assessor/assessorProvider.dart';
import 'package:mahindraCSC/roles/plantHead/plantHeadDashboard.dart';
import 'package:mahindraCSC/roles/plantHead/plantHeadProvider.dart';
import 'package:mahindraCSC/y_check/checkProvider.dart';
import 'package:provider/provider.dart';

class Check extends StatefulWidget {
  @override
  _CheckState createState() => _CheckState();
}

class _CheckState extends State<Check> {
  @override
  Widget build(BuildContext context) {
    final checkProvider = Provider.of<CheckProvider>(context);
    return Scaffold(
      body: Center(child: getWidget(checkProvider)),
    );
  }

  Widget getWidget(CheckProvider checkProvider) {
    if (checkProvider.loading) {
      return CircularProgressIndicator();
    } else {
      if (checkProvider.error) {
        return Text('Error');
      } else {
        if (checkProvider.userExistsBool) {
          if (checkProvider.singleRole) {
            switch (checkProvider.role) {
              case 'admin':
                {
                  return ChangeNotifierProvider<AdminProvider>(
                    create: (_) => AdminProvider(),
                    child: AdminDashboard(),
                  );
                }
                break;
              case 'assessee':
                {
                  return ChangeNotifierProvider<AssesseeProvider>(
                    create: (_) => AssesseeProvider(),
                    child: AssesseeDashboard(),
                  );
                }
                break;
              case 'assessor':
                {
                  return ChangeNotifierProvider<AssessorProvider>(
                    create: (_) => AssessorProvider(),
                    child: AssessorDashboard(),
                  );
                }
                break;
              case 'plantHead':
                {
                  return ChangeNotifierProvider<PlantHeadProvider>(
                    create: (_) => PlantHeadProvider(),
                    child: PlantHeadDashboard(),
                  );
                }
                break;
            }
          } else {
            return Choice();
          }
        } else {
          return Login();
        }
      }
    }
  }
}
