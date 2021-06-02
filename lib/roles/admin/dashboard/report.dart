import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:html'as html;

import 'package:mahindraCSC/roles/admin/annualData/annualDataProvider.dart';
import 'package:provider/provider.dart';
class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {

  getCsv(
  List<List<String>> rows
   ) async {
   
    String csv = const ListToCsvConverter().convert(rows);

    final bytes = csv;
    final blob = html.Blob([bytes], 'report/csv');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'finalReport.csv';
    html.document.body.children.add(anchor);
    anchor.click();
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
    // if (await canLaunch(url)) await launch(url);
    // html.window.open(url, "_blank");
    // html.Url.revokeObjectUrl(url);
  }
  @override
  Widget build(BuildContext context) {
     final provider = Provider.of<AnnualDataProvider>(context);
    return getCsv(provider.rows);
  }
}