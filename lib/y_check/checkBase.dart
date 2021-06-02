import 'package:flutter/material.dart';
import 'package:mahindraCSC/y_check/check.dart';
import 'package:mahindraCSC/y_check/checkProvider.dart';
import 'package:provider/provider.dart';

class CheckBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CheckProvider(),
      child: Check(),
    );
  }
}
