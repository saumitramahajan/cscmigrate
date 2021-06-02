import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:url_launcher/url_launcher.dart';

class PdfTrial extends StatefulWidget {
  @override
  _PdfTrialState createState() => _PdfTrialState();
}

class _PdfTrialState extends State<PdfTrial> {
  final pdf = pw.Document();
  void generatePdf() async {
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Text('Testing');
      },
    ));
    final bytes = await pdf.save();
    final blob = html.Blob([bytes], 'report/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'finalReport.pdf';
    html.document.body.children.add(anchor);
    anchor.click();
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
    if (await canLaunch(url)) await launch(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Trial'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Download'),
          onPressed: () {
            generatePdf();
          },
        ),
      ),
    );
  }
}
