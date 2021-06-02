import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mahindraCSC/roles/assessor/review/closedAssessmentProvider.dart';
import 'package:mahindraCSC/utilities.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:url_launcher/url_launcher.dart';

class Closed extends StatefulWidget {
  @override
  _ClosedState createState() => _ClosedState();
}

class _ClosedState extends State<Closed> {
  String groupValue;
  String monthValue;
  String query;

  bool loading = false;
  Utilities utilities = Utilities();
  ScrollController _controller = ScrollController();
  TextEditingController point1 = TextEditingController();
  TextEditingController point2 = TextEditingController();
  TextEditingController point3 = TextEditingController();
  TextEditingController point4 = TextEditingController();
  TextEditingController point5 = TextEditingController();
  TextEditingController wayForward1 = TextEditingController();
  TextEditingController wayForward2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ClosedAssessmentProvider>(context);
    final pdf = pw.Document();
    Uint8List pic1;
    Uint8List pic2;
    Uint8List pic3;
    Uint8List pic4;
    Uint8List appbar;

    Uint8List safety;
    Uint8List impact;
    Uint8List likelihood;
    Uint8List heatMap;

    writeOnPdf(
      String nameOfSite,
      String location,
      String scheduledDate,
      String assessorName,
      String coAssessorName,
      List<Map<String, dynamic>> listOfLevels,
    ) async {
      final imagepic1 = pw.MemoryImage(pic1);
      final imagepic2 = pw.MemoryImage(pic2);
      final imagepic3 = pw.MemoryImage(pic3);
      final imagepic4 = pw.MemoryImage(pic4);
      final appBarImage = pw.MemoryImage(appbar);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.copyWith(
              marginBottom: 0, marginLeft: 0, marginRight: 0, marginTop: 0),
          build: (pw.Context context) {
            return pw.Column(children: [
              pw.Row(children: [
                pw.Image(appBarImage,
                    height: 50, width: 200, fit: pw.BoxFit.fitHeight),
                pw.SizedBox(width: 80),
                pw.Image(imagepic1,
                    height: 250, width: 350, fit: pw.BoxFit.fitHeight),
              ]),
              pw.SizedBox(height: 20),
              pw.Image(imagepic2, height: 80, fit: pw.BoxFit.fitHeight),
              pw.SizedBox(height: 15),
              pw.Text('Cycle<3> Assessment',
                  style: pw.TextStyle(
                      color: PdfColor.fromHex('3c1758'),
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 50),
              pw.Container(
                  width: 1000,
                  height: 60,
                  color: PdfColor.fromHex('3c1758'),
                  child: pw.Padding(
                      padding: pw.EdgeInsets.fromLTRB(180, 20, 10, 10),
                      child: pw.Text(
                          'Site: $nameOfSite - $location'.toUpperCase(),
                          style: pw.TextStyle(
                              color: PdfColors.white,
                              fontSize: 15,
                              fontWeight: pw.FontWeight.bold)))),
              pw.SizedBox(height: 147.5),
              pw.Row(children: [
                pw.Image(imagepic3,
                    height: 200, width: 290, fit: pw.BoxFit.fitHeight),
                pw.SizedBox(width: 160),
                pw.Column(children: [
                  pw.SizedBox(height: 50),
                  pw.Image(imagepic4,
                      height: 150, width: 150, fit: pw.BoxFit.fitHeight)
                ]),
              ]),
            ]);
          },
        ),
      );

      // pdf.addPage(
      //   pw.MultiPage(
      //     pageFormat: PdfPageFormat.a4,
      //     margin: pw.EdgeInsets.all(32),
      //     build: (pw.Context context) {
      //       return <pw.Widget>[
      //         pw.Header(
      //             level: 0,
      //             child: pw.Row(
      //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   pw.Text('TMSW Cycle <3> Assessment Report'),
      //                   pw.Container(
      //                       color: PdfColors.red700,
      //                       child: pw.Padding(
      //                           padding: pw.EdgeInsets.all(10),
      //                           child: pw.Text('$scheduledDate',
      //                               style:
      //                                   pw.TextStyle(color: PdfColors.white))))
      //                 ])),
      //         pw.Column(
      //           crossAxisAlignment: pw.CrossAxisAlignment.start,
      //           children: [
      //             pw.Padding(
      //                 padding: pw.EdgeInsets.fromLTRB(10, 10, 10, 10),
      //                 child: pw.Text('Contents',
      //                     style: pw.TextStyle(
      //                         fontSize: 18, fontWeight: pw.FontWeight.bold))),
      //             pw.Padding(
      //                 padding: pw.EdgeInsets.fromLTRB(30, 10, 10, 10),
      //                 child: pw.Text('1. Summary of Assessment',
      //                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
      //             pw.Padding(
      //                 padding: pw.EdgeInsets.fromLTRB(30, 10, 10, 10),
      //                 child: pw.Text(
      //                     '2. Site Risk Profile-Based on Hazardous process and Chemicals',
      //                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
      //             pw.Padding(
      //                 padding: pw.EdgeInsets.fromLTRB(30, 10, 10, 10),
      //                 child: pw.Text('3. Heat Map',
      //                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
      //             pw.Padding(
      //                 padding: pw.EdgeInsets.fromLTRB(30, 10, 10, 10),
      //                 child: pw.Text('4. TMSW Process and Result levels',
      //                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
      //             pw.Padding(
      //                 padding: pw.EdgeInsets.fromLTRB(30, 10, 10, 10),
      //                 child: pw.Text('5. Fire Safety Management Status',
      //                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
      //             pw.Padding(
      //                 padding: pw.EdgeInsets.fromLTRB(30, 10, 10, 10),
      //                 child: pw.Text('6. Office Safety Management Status',
      //                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
      //             pw.Padding(
      //                 padding: pw.EdgeInsets.fromLTRB(30, 10, 10, 10),
      //                 child: pw.Text('7. Way Forward',
      //                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
      //           ],
      //         )
      //       ];
      //     },
      //   ),
      // );

      // pdf.addPage(
      //   pw.MultiPage(
      //     pageFormat: PdfPageFormat.a4,
      //     margin: pw.EdgeInsets.all(32),
      //     build: (pw.Context context) {
      //       return <pw.Widget>[
      //         pw.Header(
      //             level: 0,
      //             child: pw.Row(
      //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   pw.Text('TMSW Cycle <3> Assessment Report'),
      //                   pw.Container(
      //                       color: PdfColors.red700,
      //                       child: pw.Padding(
      //                           padding: pw.EdgeInsets.all(10),
      //                           child: pw.Text('$scheduledDate',
      //                               style:
      //                                   pw.TextStyle(color: PdfColors.white))))
      //                 ])),
      //         pw.Column(children: [
      //           pw.Padding(
      //               padding: pw.EdgeInsets.fromLTRB(10, 10, 10, 10),
      //               child: pw.Text('Summary of Reports',
      //                   style: pw.TextStyle(
      //                       fontSize: 18, fontWeight: pw.FontWeight.bold))),
      //         ]),
      //         pw.Table(
      //
      //             columnWidths: {
      //               0: pw.FixedColumnWidth(20.0)
      //             },
      //             children: [
      //               pw.TableRow(children: [
      //                 pw.SizedBox(
      //                     child: pw.Container(
      //                         color: PdfColors.indigo200,
      //                         child: pw.Padding(
      //                             padding: pw.EdgeInsets.all(10),
      //                             child: pw.Text('Name of Site',
      //                                 style: pw.TextStyle(fontSize: 12))))),
      //                 pw.SizedBox(
      //                     child: pw.SizedBox(
      //                         child: pw.Container(
      //                             child: pw.Padding(
      //                                 padding: pw.EdgeInsets.all(10),
      //                                 child: pw.Text('$nameOfSite',
      //                                     style:
      //                                         pw.TextStyle(fontSize: 12)))))),
      //               ]),
      //               pw.TableRow(children: [
      //                 pw.SizedBox(
      //                     child: pw.SizedBox(
      //                         child: pw.Container(
      //                             color: PdfColors.indigo200,
      //                             child: pw.Padding(
      //                                 padding: pw.EdgeInsets.all(10),
      //                                 child: pw.Text('Date of Assessment',
      //                                     style:
      //                                         pw.TextStyle(fontSize: 12)))))),
      //                 pw.SizedBox(
      //                     child: pw.SizedBox(
      //                         child: pw.Container(
      //                             child: pw.Padding(
      //                                 padding: pw.EdgeInsets.all(10),
      //                                 child: pw.Text('$scheduledDate',
      //                                     style:
      //                                         pw.TextStyle(fontSize: 12)))))),
      //               ]),
      //               pw.TableRow(children: [
      //                 pw.SizedBox(
      //                     child: pw.Container(
      //                         color: PdfColors.indigo200,
      //                         child: pw.Padding(
      //                             padding: pw.EdgeInsets.all(10),
      //                             child: pw.Text('Assessor 1',
      //                                 style: pw.TextStyle(fontSize: 12))))),
      //                 pw.Container(
      //                     child: pw.Padding(
      //                         padding: pw.EdgeInsets.all(10),
      //                         child: pw.Text('$assessorName'))),
      //               ]),
      //               pw.TableRow(children: [
      //                 pw.SizedBox(
      //                     child: pw.Container(
      //                         color: PdfColors.indigo200,
      //                         child: pw.Padding(
      //                             padding: pw.EdgeInsets.all(10),
      //                             child: pw.Text('Assessor 2',
      //                                 style: pw.TextStyle(fontSize: 12))))),
      //                 pw.Container(
      //                     child: pw.Padding(
      //                         padding: pw.EdgeInsets.all(10),
      //                         child: pw.Text('$coAssessorName')))
      //               ]),
      //               pw.TableRow(children: [
      //                 pw.SizedBox(
      //                     child: pw.Container(
      //                         color: PdfColors.indigo200,
      //                         child: pw.Padding(
      //                             padding: pw.EdgeInsets.all(10),
      //                             child: pw.Text('Process Level',
      //                                 style: pw.TextStyle(fontSize: 12))))),
      //                 pw.Container(
      //                     child: pw.Padding(
      //                         padding: pw.EdgeInsets.all(10),
      //                         child: pw.Text('$processLevel'))),
      //               ]),
      //               pw.TableRow(children: [
      //                 pw.SizedBox(
      //                     child: pw.Container(
      //                         color: PdfColors.indigo200,
      //                         child: pw.Padding(
      //                             padding: pw.EdgeInsets.all(10),
      //                             child: pw.Text('Result Level',
      //                                 style: pw.TextStyle(fontSize: 12))))),
      //                 pw.Container(
      //                     child: pw.Padding(
      //                         padding: pw.EdgeInsets.all(10),
      //                         child: pw.Text('$resultLevel'))),
      //               ]),
      //               pw.TableRow(children: [
      //                 pw.SizedBox(
      //                     child: pw.Container(
      //                         width: 40,
      //                         color: PdfColors.indigo200,
      //                         child: pw.Padding(
      //                             padding: pw.EdgeInsets.all(10),
      //                             child: pw.Text('TMSW Stage',
      //                                 style: pw.TextStyle(fontSize: 12))))),
      //                 pw.Container(
      //                     child: pw.Padding(
      //                         padding: pw.EdgeInsets.all(10),
      //                         child: pw.Text('$lastAssessmentStage'))),
      //               ]),
      //             ]),
      //         pw.SizedBox(height: 10),
      //         pw.Text('Positive Observations',
      //             style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      //         pw.SizedBox(height: 10),
      //         pw.Paragraph(
      //             text: '1.$summaryOfRiskProfile1',
      //             style: pw.TextStyle(fontSize: 10)),
      //         pw.Paragraph(
      //             text: '2.$summaryOfRiskProfile2',
      //             style: pw.TextStyle(fontSize: 10)),
      //         //pw.Paragraph(text: '3.$summaryOfRiskProfile3'),
      //         pw.Text('Major Observations',
      //             style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      //         pw.SizedBox(height: 10),
      //         pw.Paragraph(
      //             text: '1.$summaryOfRiskProfile11',
      //             style: pw.TextStyle(fontSize: 10)),
      //         pw.Paragraph(
      //             text: '2.$summaryOfRiskProfile22',
      //             style: pw.TextStyle(fontSize: 10)),
      //         //pw.Paragraph(text: '3.$summaryOfRiskProfile33'),
      //         pw.Text('Suggestion for improvement',
      //             style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      //         pw.SizedBox(height: 10),
      //         pw.Paragraph(
      //             text: '1.$summaryOfRiskProfile111',
      //             style: pw.TextStyle(fontSize: 10)),
      //         pw.Paragraph(
      //             text: '2.$summaryOfRiskProfile222',
      //             style: pw.TextStyle(fontSize: 10)),
      //         // pw.Paragraph(text: '3.$summaryOfRiskProfile333'),
      //       ];
      //     },
      //   ),
      // );

      // pdf.addPage(
      //   pw.MultiPage(
      //     pageFormat: PdfPageFormat.a4,
      //     margin: pw.EdgeInsets.all(32),
      //     build: (pw.Context context) {
      //       return <pw.Widget>[
      //         pw.Header(
      //             level: 0,
      //             child: pw.Row(
      //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   pw.Text('TMSW Cycle <3> Assessment Report'),
      //                   pw.Container(
      //                       color: PdfColors.red700,
      //                       child: pw.Padding(
      //                           padding: pw.EdgeInsets.all(10),
      //                           child: pw.Text('$scheduledDate',
      //                               style:
      //                                   pw.TextStyle(color: PdfColors.white)))),
      //                 ])),
      //         pw.Table(
      //
      //             columnWidths: {
      //               0: pw.FixedColumnWidth(20.0)
      //             },
      //             children: [
      //               pw.TableRow(children: [
      //                 pw.Row(
      //                     crossAxisAlignment: pw.CrossAxisAlignment.center,
      //                     mainAxisAlignment: pw.MainAxisAlignment.center,
      //                     children: [
      //                       pw.Container(
      //                           width: 600,
      //                           color: PdfColors.indigo200,
      //                           child: pw.Padding(
      //                               padding: pw.EdgeInsets.fromLTRB(
      //                                   200, 10, 200, 10),
      //                               child: pw.Text('Site Risk Profile',
      //                                   style: pw.TextStyle(
      //                                       fontSize: 12,
      //                                       fontWeight: pw.FontWeight.bold))))
      //                     ]),
      //               ]),
      //             ]),
      //         pw.Table(
      //
      //             children: [
      //               pw.TableRow(children: [
      //                 pw.SizedBox(
      //                     child: pw.Container(
      //                         width: 70,
      //                         height: 40,
      //                         color: PdfColors.indigo200,
      //                         child: pw.Padding(
      //                             padding: pw.EdgeInsets.all(10),
      //                             child: pw.Text('LPG/Propane Quantity',
      //                                 style: pw.TextStyle(fontSize: 12))))),
      //                 pw.Container(
      //                   child: pw.Padding(
      //                       padding: pw.EdgeInsets.all(10),
      //                       child: pw.Column(
      //                           crossAxisAlignment: pw.CrossAxisAlignment.start,
      //                           children: [
      //                             pw.Text('$lpg'),
      //                           ])),
      //                 ),
      //                 pw.SizedBox(
      //                     child: pw.Container(
      //                         width: 70,
      //                         height: 40,
      //                         color: PdfColors.indigo200,
      //                         child: pw.Padding(
      //                             padding: pw.EdgeInsets.all(10),
      //                             child: pw.Text('Diesel Quantity',
      //                                 style: pw.TextStyle(fontSize: 12))))),
      //                 pw.Container(
      //                   child: pw.Padding(
      //                       padding: pw.EdgeInsets.all(10),
      //                       child: pw.Column(
      //                           crossAxisAlignment: pw.CrossAxisAlignment.start,
      //                           children: [
      //                             pw.Text('$diesel'),
      //                           ])),
      //                 ),
      //               ]),
      //               pw.TableRow(children: [
      //                 pw.SizedBox(
      //                     child: pw.Container(
      //                         width: 70,
      //                         height: 40,
      //                         color: PdfColors.indigo200,
      //                         child: pw.Padding(
      //                             padding: pw.EdgeInsets.all(10),
      //                             child: pw.Text('Gasoline Quantity',
      //                                 style: pw.TextStyle(fontSize: 12))))),
      //                 pw.Container(
      //                   child: pw.Padding(
      //                       padding: pw.EdgeInsets.all(10),
      //                       child: pw.Column(
      //                           crossAxisAlignment: pw.CrossAxisAlignment.start,
      //                           children: [
      //                             pw.Text('$gasoline'),
      //                           ])),
      //                 ),
      //                 pw.SizedBox(
      //                     child: pw.Container(
      //                         width: 70,
      //                         height: 40,
      //                         color: PdfColors.indigo200,
      //                         child: pw.Padding(
      //                             padding: pw.EdgeInsets.all(10),
      //                             child: pw.Text(
      //                                 'Thinner/other A Class Quantity',
      //                                 style: pw.TextStyle(fontSize: 12))))),
      //                 pw.Container(
      //                   child: pw.Padding(
      //                       padding: pw.EdgeInsets.all(10),
      //                       child: pw.Column(
      //                           crossAxisAlignment: pw.CrossAxisAlignment.start,
      //                           children: [
      //                             pw.Text('$thinner'),
      //                           ])),
      //                 )
      //               ]),
      //               pw.TableRow(children: [
      //                 pw.SizedBox(
      //                     child: pw.Container(
      //                         width: 70,
      //                         color: PdfColors.indigo200,
      //                         child: pw.Padding(
      //                             padding: pw.EdgeInsets.all(10),
      //                             child: pw.Text('CNG/PNG Quantity',
      //                                 style: pw.TextStyle(fontSize: 12))))),
      //                 pw.Container(
      //                   child: pw.Padding(
      //                       padding: pw.EdgeInsets.all(10),
      //                       child: pw.Column(
      //                           crossAxisAlignment: pw.CrossAxisAlignment.start,
      //                           children: [
      //                             pw.Text('$cng'),
      //                           ])),
      //                 ),
      //                 pw.SizedBox(
      //                     child: pw.Container(
      //                         width: 70,
      //                         color: PdfColors.indigo200,
      //                         child: pw.Padding(
      //                             padding: pw.EdgeInsets.all(10),
      //                             child: pw.Text('Toxic Chemicals Quantity',
      //                                 style: pw.TextStyle(fontSize: 12))))),
      //                 pw.Container(
      //                   child: pw.Padding(
      //                       padding: pw.EdgeInsets.all(10),
      //                       child: pw.Column(
      //                           crossAxisAlignment: pw.CrossAxisAlignment.start,
      //                           children: [
      //                             pw.Text('$toxic'),
      //                           ])),
      //                 )
      //               ]),
      //               pw.TableRow(children: [
      //                 pw.SizedBox(
      //                     child: pw.Container(
      //                         width: 70,
      //                         color: PdfColors.indigo200,
      //                         child: pw.Padding(
      //                             padding: pw.EdgeInsets.all(10),
      //                             child: pw.Text('Paint Shop Capacity',
      //                                 style: pw.TextStyle(fontSize: 12))))),
      //                 pw.Container(
      //                   child: pw.Padding(
      //                       padding: pw.EdgeInsets.all(10),
      //                       child: pw.Column(
      //                           crossAxisAlignment: pw.CrossAxisAlignment.start,
      //                           children: [
      //                             pw.Text('$paintShop'),
      //                           ])),
      //                 ),
      //                 pw.SizedBox(
      //                     child: pw.Container(
      //                         width: 70,
      //                         color: PdfColors.indigo200,
      //                         child: pw.Padding(
      //                             padding: pw.EdgeInsets.all(10),
      //                             child: pw.Text('Heat treatment Capacity',
      //                                 style: pw.TextStyle(fontSize: 12))))),
      //                 pw.Container(
      //                   child: pw.Padding(
      //                       padding: pw.EdgeInsets.all(10),
      //                       child: pw.Column(
      //                           crossAxisAlignment: pw.CrossAxisAlignment.start,
      //                           children: [
      //                             pw.Text('$heat'),
      //                           ])),
      //                 )
      //               ]),
      //               pw.TableRow(children: [
      //                 pw.SizedBox(
      //                     child: pw.Container(
      //                         width: 70,
      //                         height: 45,
      //                         color: PdfColors.indigo200,
      //                         child: pw.Padding(
      //                             padding: pw.EdgeInsets.all(10),
      //                             child: pw.Text(
      //                                 'Steel Melting / Foundry Capacity',
      //                                 style: pw.TextStyle(fontSize: 12))))),
      //                 pw.Container(
      //                   child: pw.Padding(
      //                       padding: pw.EdgeInsets.all(10),
      //                       child: pw.Column(
      //                           crossAxisAlignment: pw.CrossAxisAlignment.start,
      //                           children: [
      //                             pw.Text('$foundry'),
      //                           ])),
      //                 ),
      //                 pw.SizedBox(
      //                     child: pw.Container(
      //                         width: 70,
      //                         height: 45,
      //                         color: PdfColors.indigo200,
      //                         child: pw.Padding(
      //                             padding: pw.EdgeInsets.all(10),
      //                             child: pw.Text('Press Shop Capacity',
      //                                 style: pw.TextStyle(fontSize: 12))))),
      //                 pw.Container(
      //                   child: pw.Padding(
      //                       padding: pw.EdgeInsets.all(10),
      //                       child: pw.Column(
      //                           crossAxisAlignment: pw.CrossAxisAlignment.start,
      //                           children: [
      //                             pw.Text('$press'),
      //                           ])),
      //                 )
      //               ]),
      //               pw.TableRow(children: [
      //                 pw.SizedBox(
      //                     child: pw.Container(
      //                         width: 70,
      //                         color: PdfColors.indigo200,
      //                         child: pw.Padding(
      //                             padding: pw.EdgeInsets.all(10),
      //                             child: pw.Text('IBR Boiler Capacity',
      //                                 style: pw.TextStyle(fontSize: 12))))),
      //                 pw.Container(
      //                   child: pw.Padding(
      //                       padding: pw.EdgeInsets.all(10),
      //                       child: pw.Column(
      //                           crossAxisAlignment: pw.CrossAxisAlignment.start,
      //                           children: [
      //                             pw.Text('$ibr'),
      //                           ])),
      //                 ),
      //                 pw.SizedBox(
      //                     child: pw.Container(
      //                         width: 70,
      //                         color: PdfColors.indigo200,
      //                         child: pw.Padding(
      //                             padding: pw.EdgeInsets.all(10),
      //                             child: pw.Text('Number of Engine Test Beds',
      //                                 style: pw.TextStyle(fontSize: 12))))),
      //                 pw.Container(
      //                   child: pw.Padding(
      //                       padding: pw.EdgeInsets.all(10),
      //                       child: pw.Column(
      //                           crossAxisAlignment: pw.CrossAxisAlignment.start,
      //                           children: [
      //                             pw.Text('$testBed'),
      //                           ])),
      //                 )
      //               ]),
      //             ]),
      //         pw.SizedBox(height: 10),
      //         pw.Text('Positive Observations specific to above risk',
      //             style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      //         pw.SizedBox(height: 10),

      //         pw.Paragraph(
      //             text: '1.$siteRisProfile1',
      //             style: pw.TextStyle(fontSize: 10)),
      //         pw.Paragraph(
      //             text: '2.$siteRisProfile2',
      //             style: pw.TextStyle(fontSize: 10)),
      //         //pw.Paragraph(text: '3.$siteRisProfile3'),
      //         pw.Text('Major Observations specific to above risk',
      //             style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      //         pw.SizedBox(height: 10),
      //         pw.Paragraph(
      //             text: '1.$siteRisProfile11',
      //             style: pw.TextStyle(fontSize: 10)),
      //         pw.Paragraph(
      //             text: '2.$siteRisProfile22',
      //             style: pw.TextStyle(fontSize: 10)),
      //         //pw.Paragraph(text: '3.$siteRisProfile33'),
      //         pw.Text('Suggestion for improvement specific to above risk',
      //             style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      //         pw.SizedBox(height: 10),
      //         pw.Paragraph(
      //             text: '1.$siteRisProfile111',
      //             style: pw.TextStyle(fontSize: 10)),
      //         pw.Paragraph(
      //             text: '2.$siteRisProfile222',
      //             style: pw.TextStyle(fontSize: 10)),
      //         //pw.Paragraph(text: '3.$siteRisProfile333'),
      //       ];
      //     },
      //   ),
      // );
      // final imageimpact = PdfImage.file(
      //   pdf.document,
      //   bytes: impact,
      // );
      // final imagelikelihood = PdfImage.file(
      //   pdf.document,
      //   bytes: likelihood,
      // );
      // final heatMapImage = PdfImage.file(
      //   pdf.document,
      //   bytes: heatMap,
      // );
      // pdf.addPage(
      //   pw.MultiPage(
      //     pageFormat: PdfPageFormat.a4,
      //     margin: pw.EdgeInsets.all(32),
      //     build: (pw.Context context) {
      //       return <pw.Widget>[
      //         pw.Header(
      //             level: 0,
      //             child: pw.Row(
      //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   pw.Text('TMSW Cycle <3> Assessment Report'),
      //                   pw.Container(
      //                       color: PdfColors.red700,
      //                       child: pw.Padding(
      //                           padding: pw.EdgeInsets.all(10),
      //                           child: pw.Text('$scheduledDate',
      //                               style:
      //                                   pw.TextStyle(color: PdfColors.white))))
      //                 ])),
      //         pw.Column(
      //           crossAxisAlignment: pw.CrossAxisAlignment.start,
      //           children: [
      //             pw.Padding(
      //                 padding: pw.EdgeInsets.fromLTRB(10, 10, 10, 10),
      //                 child: pw.Text('Heat Map',
      //                     style: pw.TextStyle(
      //                         fontSize: 15, fontWeight: pw.FontWeight.bold))),
      //           ],
      //         ),
      //         pw.Table(
      //
      //             children: [
      //               pw.TableRow(children: [
      //                 pw.Row(
      //                     crossAxisAlignment: pw.CrossAxisAlignment.center,
      //                     mainAxisAlignment: pw.MainAxisAlignment.center,
      //                     children: [
      //                       pw.Container(
      //                           width: 600,
      //                           color: PdfColors.red700,
      //                           child: pw.Padding(
      //                               padding: pw.EdgeInsets.fromLTRB(
      //                                   200, 10, 200, 10),
      //                               child: pw.Text(
      //                                   'Top 5 Risks Identified of the site',
      //                                   style: pw.TextStyle(
      //                                       color: PdfColors.white,
      //                                       fontSize: 12,
      //                                       fontWeight: pw.FontWeight.bold))))
      //                     ]),
      //               ]),
      //             ]),
      //         pw.Table(
      //
      //             children: [
      //               pw.TableRow(children: [
      //                 pw.Row(
      //                     crossAxisAlignment: pw.CrossAxisAlignment.start,
      //                     mainAxisAlignment: pw.MainAxisAlignment.start,
      //                     children: [
      //                       pw.Container(
      //                         child: pw.Padding(
      //                             padding: pw.EdgeInsets.all(10),
      //                             child: pw.Column(
      //                                 crossAxisAlignment:
      //                                     pw.CrossAxisAlignment.start,
      //                                 children: [
      //                                   pw.Paragraph(
      //                                       text: '1.$sitepoint1',
      //                                       style: pw.TextStyle(
      //                                           fontWeight:
      //                                               pw.FontWeight.bold)),
      //                                   pw.SizedBox(height: 10),
      //                                   pw.Paragraph(
      //                                       text: '2.$sitepoint2',
      //                                       style: pw.TextStyle(
      //                                           fontWeight:
      //                                               pw.FontWeight.bold)),
      //                                   pw.SizedBox(height: 10),
      //                                   pw.Paragraph(
      //                                       text: '3.$sitepoint3',
      //                                       style: pw.TextStyle(
      //                                           fontWeight:
      //                                               pw.FontWeight.bold)),
      //                                   pw.SizedBox(height: 10),
      //                                   pw.Paragraph(
      //                                       text: '4.$sitepoint4',
      //                                       style: pw.TextStyle(
      //                                           fontWeight:
      //                                               pw.FontWeight.bold)),
      //                                   pw.SizedBox(height: 10),
      //                                   pw.Paragraph(
      //                                       text: '5.$sitepoint5',
      //                                       style: pw.TextStyle(
      //                                           fontWeight:
      //                                               pw.FontWeight.bold)),
      //                                 ])),
      //                       )
      //                     ])
      //               ])
      //             ]),
      //         pw.SizedBox(height: 30),
      //         pw.Row(
      //             crossAxisAlignment: pw.CrossAxisAlignment.start,
      //             mainAxisAlignment: pw.MainAxisAlignment.start,
      //             children: [
      //               pw.Image(imageimpact,
      //                   height: 80, width: 250, fit: pw.BoxFit.fitHeight),
      //               pw.SizedBox(width: 10),
      //               pw.Image(imagelikelihood,
      //                   height: 80, width: 250, fit: pw.BoxFit.fitHeight),
      //             ]),
      //         pw.SizedBox(height: 30),
      //         pw.Row(
      //             crossAxisAlignment: pw.CrossAxisAlignment.center,
      //             mainAxisAlignment: pw.MainAxisAlignment.center,
      //             children: [
      //               pw.Image(heatMapImage,
      //                   height: 200, width: 500, fit: pw.BoxFit.fitHeight)
      //             ]),
      //       ];
      //     },
      //   ),
      // );
      //New Report Pages
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return <pw.Widget>[
              pw.Header(
                  level: 0,
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('TMSW Cycle <3> Assessment Report'),
                        pw.Container(
                            color: PdfColors.red700,
                            child: pw.Padding(
                                padding: pw.EdgeInsets.all(10),
                                child: pw.Text('$scheduledDate',
                                    style:
                                        pw.TextStyle(color: PdfColors.white))))
                      ])),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Padding(
                      padding: pw.EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: pw.Text('Process and Result Summary',
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold))),
                ],
              ),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      height: 40,
                      color: PdfColors.red700,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: pw.Text('Sl.No.',
                              style: pw.TextStyle(
                                  color: PdfColors.white,
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold)))),
                  pw.Container(
                      width: 100,
                      height: 40,
                      color: PdfColors.red700,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(150, 10, 100, 10),
                          child: pw.Text('Process Parameters',
                              style: pw.TextStyle(
                                  color: PdfColors.white,
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold)))),
                  pw.Container(
                      width: 20,
                      height: 40,
                      color: PdfColors.red700,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: pw.Text('Individual Levels',
                              style: pw.TextStyle(
                                  color: PdfColors.white,
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold)))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '1',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Safety policy',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[0]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '2',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Safety organization and line management involvement',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[1]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      color: PdfColors.red100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '3',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      color: PdfColors.red100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Legal requirements*',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      color: PdfColors.red100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[2]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '4',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Employee involvement and competency development',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[3]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '5',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Incident investigation',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[4]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '6',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Safety Observation - BBS/SMARRT',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[5]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '7',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'OHSAS 18001 / ISO 45001',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[6]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '8',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Risk Assessment',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[7]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '9',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Contractor safety management',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[8]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '10',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Management of Change',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[9]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      color: PdfColors.red100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '11',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      color: PdfColors.red100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Permit To Work system*',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      color: PdfColors.red100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[10]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '12',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Work at Height',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[11]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '13',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Confined space entry',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[12]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      color: PdfColors.red100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '14',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      color: PdfColors.red100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Electrical safety management*',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      color: PdfColors.red100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[13]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '15',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Lock Out and Tag Out',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[14]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '16',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Machine Guarding',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[15]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      color: PdfColors.red100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '17',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      color: PdfColors.red100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Fire Safety Management*',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      color: PdfColors.red100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[16]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '18',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Chemical Safety ',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[17]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '19',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Material Handling',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[18]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '20',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Personal protective equipments',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[19]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '21',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Action Plan on last TMSW',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[20]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '22',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Visitor Safety and visual management',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[21]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '23',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Housekeeping',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[22]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '24',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Safe driving and traffic safety',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[23]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '25',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Occupational Health',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[24]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.SizedBox(height: 10),
              pw.Text('Note:*-Identified Critical process'),
              pw.SizedBox(height: 80),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      height: 40,
                      color: PdfColors.red700,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: pw.Text('Sl.No.',
                              style: pw.TextStyle(
                                  color: PdfColors.white,
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold)))),
                  pw.Container(
                      width: 100,
                      height: 40,
                      color: PdfColors.red700,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(150, 10, 100, 10),
                          child: pw.Text('Result Parameters',
                              style: pw.TextStyle(
                                  color: PdfColors.white,
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold)))),
                  pw.Container(
                      width: 20,
                      height: 40,
                      color: PdfColors.red700,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: pw.Text('Individual Levels',
                              style: pw.TextStyle(
                                  color: PdfColors.white,
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold)))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '1.',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Safety Kaizens and Pokayokes',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[25]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '2',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'SAR(nos.)',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[26]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '3',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Identification of UA/UCs',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[27]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '4',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Theme-based safety inspections(TBSI)(nos.)',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[28]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '5',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Closure of safety inspections/walk through survey/observations',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[29]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '6',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Near Misses',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[30]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '7',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Frequency Severity index for RAs (FSI)',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[31]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 15,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: pw.Text(
                            '8',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 100,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: pw.Text(
                            'Incident Rate(IR)',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                  pw.Container(
                      width: 20,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(35, 5, 5, 5),
                          child: pw.Text(
                            '${listOfLevels[32]['level']}',
                            style: pw.TextStyle(fontSize: 10),
                          ))),
                ]),
              ]),
            ];
          },
        ),
      );
      // pdf.addPage(
      //   pw.MultiPage(
      //     pageFormat: PdfPageFormat.a4,
      //     margin: pw.EdgeInsets.all(32),
      //     build: (pw.Context context) {
      //       return <pw.Widget>[
      //         pw.Header(
      //             level: 0,
      //             child: pw.Row(
      //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   pw.Text('TMSW Cycle <3> Assessment Report'),
      //                   pw.Container(
      //                       color: PdfColors.red700,
      //                       child: pw.Padding(
      //                           padding: pw.EdgeInsets.all(10),
      //                           child: pw.Text('$scheduledDate',
      //                               style:
      //                                   pw.TextStyle(color: PdfColors.white)))),
      //                 ])),
      //         pw.Padding(
      //             padding: pw.EdgeInsets.fromLTRB(200, 10, 10, 10),
      //             child: pw.Text('Fire Safety Management',
      //                 style: pw.TextStyle(
      //                     fontSize: 15, fontWeight: pw.FontWeight.bold))),
      //         pw.SizedBox(height: 10),
      //         pw.Text('Positive Observations specific to above risk',
      //             style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      //         pw.SizedBox(height: 10),
      //         pw.Paragraph(
      //             text: '1.$fireRiskProfile1',
      //             style: pw.TextStyle(fontSize: 10)),
      //         pw.Paragraph(
      //             text: '2.$fireRiskProfile2',
      //             style: pw.TextStyle(fontSize: 10)),
      //         // pw.Paragraph(text: '3.$fireRiskProfile3'),
      //         pw.Text('Serious non-Conformity specific to above risk',
      //             style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      //         pw.SizedBox(height: 10),
      //         pw.Paragraph(
      //             text: '1.$fireRiskProfile11',
      //             style: pw.TextStyle(fontSize: 10)),
      //         pw.Paragraph(
      //             text: '2.$fireRiskProfile22',
      //             style: pw.TextStyle(fontSize: 10)),
      //         //pw.Paragraph(text: '3.$fireRiskProfile33'),
      //         pw.Text('Suggestion for improvement specific to above risk',
      //             style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      //         pw.SizedBox(height: 10),
      //         pw.Paragraph(
      //             text: '1.$fireRiskProfile111',
      //             style: pw.TextStyle(fontSize: 10)),
      //         pw.Paragraph(
      //             text: '2.$fireRiskProfile222',
      //             style: pw.TextStyle(fontSize: 10)),
      //         // pw.Paragraph(text: '3.$fireRiskProfile333'),
      //         pw.Padding(
      //             padding: pw.EdgeInsets.fromLTRB(230, 10, 10, 10),
      //             child: pw.Text('Office Safety ',
      //                 style: pw.TextStyle(
      //                     fontSize: 15, fontWeight: pw.FontWeight.bold))),
      //         pw.SizedBox(height: 10),
      //         pw.Text('Positive Observations specific to above risk',
      //             style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      //         pw.SizedBox(height: 10),
      //         pw.Paragraph(
      //             text: '1.$officeRiskProfile1',
      //             style: pw.TextStyle(fontSize: 10)),
      //         pw.Paragraph(
      //             text: '2.$officeRiskProfile2',
      //             style: pw.TextStyle(fontSize: 10)),
      //         //pw.Paragraph(text: '3.$officeRiskProfile3'),
      //         pw.Text('Serious non-Conformity specific to above risk',
      //             style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      //         pw.SizedBox(height: 10),
      //         pw.Paragraph(
      //             text: '1.$officeRiskProfile11',
      //             style: pw.TextStyle(fontSize: 10)),
      //         pw.Paragraph(
      //             text: '2.$officeRiskProfile22',
      //             style: pw.TextStyle(fontSize: 10)),
      //         //pw.Paragraph(text: '3.$officeRiskProfile33'),
      //         pw.Text('Suggestion for improvement specific to above risk',
      //             style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      //         pw.SizedBox(height: 10),
      //         pw.Paragraph(
      //             text: '1.$officeRiskProfile111',
      //             style: pw.TextStyle(fontSize: 10)),
      //         pw.Paragraph(
      //             text: '2.$officeRiskProfile222',
      //             style: pw.TextStyle(fontSize: 10)),
      //         //pw.Paragraph(text: '3.$officeRiskProfile333'),
      //       ];
      //     },
      //   ),
      // );
      // pdf.addPage(
      //   pw.MultiPage(
      //     pageFormat: PdfPageFormat.a4,
      //     margin: pw.EdgeInsets.all(32),
      //     build: (pw.Context context) {
      //       return <pw.Widget>[
      //         pw.Header(
      //             level: 0,
      //             child: pw.Row(
      //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   pw.Text('TMSW Cycle <3> Assessment Report'),
      //                   pw.Container(
      //                       color: PdfColors.red700,
      //                       child: pw.Padding(
      //                           padding: pw.EdgeInsets.all(10),
      //                           child: pw.Text('$scheduledDate',
      //                               style:
      //                                   pw.TextStyle(color: PdfColors.white))))
      //                 ])),
      //         pw.Column(
      //           crossAxisAlignment: pw.CrossAxisAlignment.start,
      //           children: [
      //             pw.Padding(
      //                 padding: pw.EdgeInsets.fromLTRB(10, 10, 10, 10),
      //                 child: pw.Column(
      //                     mainAxisAlignment: pw.MainAxisAlignment.start,
      //                     crossAxisAlignment: pw.CrossAxisAlignment.start,
      //                     children: [
      //                       pw.Paragraph(
      //                           text: 'Way Forward',
      //                           style: pw.TextStyle(
      //                               fontSize: 15,
      //                               fontWeight: pw.FontWeight.bold)),
      //                       pw.SizedBox(height: 10),
      //                       pw.Paragraph(
      //                           text: '1.$wayForwardone',
      //                           style: pw.TextStyle(
      //                               fontWeight: pw.FontWeight.bold)),
      //                       pw.SizedBox(height: 20),
      //                       pw.Paragraph(
      //                           text: '2.$wayForwardtwo',
      //                           style: pw.TextStyle(
      //                               fontWeight: pw.FontWeight.bold))
      //                     ])),
      //           ],
      //         ),
      //       ];
      //     },
      //   ),
      // );
      // final image = PdfImage.file(
      //   pdf.document,
      //   bytes: safety,
      // );

      // pdf.addPage(
      //   pw.MultiPage(
      //     pageFormat: PdfPageFormat.a4,
      //     margin: pw.EdgeInsets.all(32),
      //     build: (pw.Context context) {
      //       return <pw.Widget>[
      //         pw.Header(
      //             level: 0,
      //             child: pw.Row(
      //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   pw.Text('TMSW Cycle <3> Assessment Report'),
      //                   pw.Container(
      //                       color: PdfColors.red700,
      //                       child: pw.Padding(
      //                           padding: pw.EdgeInsets.all(10),
      //                           child: pw.Text('$scheduledDate',
      //                               style:
      //                                   pw.TextStyle(color: PdfColors.white))))
      //                 ])),
      //         pw.Center(
      //             child: pw.Column(
      //                 mainAxisAlignment: pw.MainAxisAlignment.center,
      //                 crossAxisAlignment: pw.CrossAxisAlignment.center,
      //                 children: [
      //               pw.SizedBox(height: 150),
      //               pw.Image(image, height: 100, fit: pw.BoxFit.fitHeight),
      //               pw.SizedBox(height: 10),
      //               pw.Text('A way of life',
      //                   style: pw.TextStyle(
      //                       fontSize: 22,
      //                       fontWeight: pw.FontWeight.bold,
      //                       fontStyle: pw.FontStyle.italic)),
      //               pw.SizedBox(height: 20),
      //               pw.Text('Central Safety Council',
      //                   style: pw.TextStyle(
      //                       fontSize: 12, fontWeight: pw.FontWeight.bold))
      //             ]))
      //       ];
      //     },
      //   ),
      // );

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
      //  html.window.open(url, "_blank");
      //  html.Url.revokeObjectUrl(url);
    }

    String point1string;
    String point2string;
    String point3string;
    String point4string;
    String point5string;
    Future<void> imageLoader() async {
      //pic1 = (await rootBundle.load('assets/bitmap.png')).buffer.asUint8List();
      safety = (await rootBundle.load('assets/101.png')).buffer.asUint8List();
      impact = (await rootBundle.load('assets/Pic 4.png')).buffer.asUint8List();
      likelihood =
          (await rootBundle.load('assets/Pic 5.png')).buffer.asUint8List();
      pic1 = (await rootBundle.load('assets/Pic 1.png')).buffer.asUint8List();
      pic2 = (await rootBundle.load('assets/TMSW.png')).buffer.asUint8List();
      pic3 = (await rootBundle.load('assets/Pic 2.png')).buffer.asUint8List();
      pic4 = (await rootBundle.load('assets/Pic 3.png')).buffer.asUint8List();
      appbar = (await rootBundle.load('assets/mahindraAppBarLogo.png'))
          .buffer
          .asUint8List();
    }

    return Stack(
      children: [
        Scaffold(
            endDrawer: Drawer(
              child: Container(
                color: utilities.mainColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Filter by:',
                      style: TextStyle(color: Colors.white),
                    ),
                    DropdownButton(
                        dropdownColor: utilities.mainColor,
                        iconEnabledColor: Colors.white,
                        underline: SizedBox(
                          height: 1,
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            child: Text(
                              'Site and Location',
                              style: TextStyle(color: Colors.white),
                            ),
                            value: 'site',
                          ),
                          DropdownMenuItem(
                              child: Text(
                                'Scheduled Month',
                                style: TextStyle(color: Colors.white),
                              ),
                              value: 'month'),
                          DropdownMenuItem(
                              child: Text(
                                'Assessor',
                                style: TextStyle(color: Colors.white),
                              ),
                              value: 'assessor'),
                          DropdownMenuItem(
                              child: Text(
                                'CoAssessor',
                                style: TextStyle(color: Colors.white),
                              ),
                              value: 'coAssessor'),
                          DropdownMenuItem(
                              child: Text(
                                'Assessee',
                                style: TextStyle(color: Colors.white),
                              ),
                              value: 'assessee')
                        ],
                        value: groupValue,
                        onChanged: (value) {
                          setState(() {
                            groupValue = value;
                          });
                        }),
                    (groupValue == 'site' ||
                            groupValue == 'assessor' ||
                            groupValue == 'coAssessor' ||
                            groupValue == 'assessee')
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  query = value;
                                });
                              },
                            ),
                          )
                        : (groupValue == 'month')
                            ? DropdownButton(
                                dropdownColor: utilities.mainColor,
                                iconEnabledColor: Colors.white,
                                underline: SizedBox(
                                  height: 1,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                                items: [
                                  DropdownMenuItem(
                                    child: Text('January',
                                        style: TextStyle(color: Colors.white)),
                                    value: '01',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('February',
                                        style: TextStyle(color: Colors.white)),
                                    value: '02',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('March',
                                        style: TextStyle(color: Colors.white)),
                                    value: '03',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('April',
                                        style: TextStyle(color: Colors.white)),
                                    value: '04',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('May',
                                        style: TextStyle(color: Colors.white)),
                                    value: '05',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('June',
                                        style: TextStyle(color: Colors.white)),
                                    value: '06',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('July',
                                        style: TextStyle(color: Colors.white)),
                                    value: '07',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('August',
                                        style: TextStyle(color: Colors.white)),
                                    value: '08',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('September',
                                        style: TextStyle(color: Colors.white)),
                                    value: '09',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('October',
                                        style: TextStyle(color: Colors.white)),
                                    value: '10',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('November',
                                        style: TextStyle(color: Colors.white)),
                                    value: '11',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('December',
                                        style: TextStyle(color: Colors.white)),
                                    value: '12',
                                  ),
                                ],
                                value: monthValue,
                                onChanged: (value) {
                                  setState(() {
                                    monthValue = value;
                                  });
                                })
                            : SizedBox(),
                    RaisedButton(
                        child: Text('Filter'),
                        onPressed: () {
                          provider.filter(groupValue, query, monthValue);
                          Navigator.of(context).pop();
                        })
                  ],
                ),
              ),
            ),
            appBar: AppBar(
              backgroundColor: utilities.mainColor,
              titleSpacing: 0.0,
              automaticallyImplyLeading: false,
              actions: [
                provider.loading == false && provider.siteExist == false
                    ? Builder(
                        builder: (context) => IconButton(
                            icon: Icon(Icons.filter_list),
                            onPressed: () =>
                                Scaffold.of(context).openEndDrawer(),
                            tooltip: 'Filter'),
                      )
                    : SizedBox(),
              ],
            ),
            body: (provider.loading)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : provider.siteExist
                    ? Container(
                        width: MediaQuery.of(context).size.width * .95,
                        child: Column(children: [
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Site',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15),
                                    )),
                              ),
                              SizedBox(width: 20),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 10, 20, 10),
                                    child: Text(
                                      'Scheduled Date',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15),
                                    )),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Assessor',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15),
                                    )),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Co-Assessor',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15),
                                    )),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Assessee',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15),
                                    )),
                              ),
                              SizedBox(
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Report',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15),
                                    )),
                              ),
                            ],
                          ),
                          Expanded(
                            child: DraggableScrollbar.rrect(
                              alwaysVisibleScrollThumb: true,
                              backgroundColor: utilities.mainColor,
                              controller: _controller,
                              child: ListView.builder(
                                  controller: _controller,
                                  itemCount:
                                      provider.closedAssessmentList.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      elevation: 5.0,
                                      margin: EdgeInsets.fromLTRB(
                                          8.0, 8.0, 8.0, 8.0),
                                      child: Row(children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                                provider.closedAssessmentList[
                                                        index]['name'] +
                                                    ', ' +
                                                    provider.closedAssessmentList[
                                                        index]['location'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color:
                                                        utilities.mainColor)),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Text(provider
                                                    .closedAssessmentList[index]
                                                ['scheduledDate']),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Text(provider
                                                .closedAssessmentList[index]
                                                    ['assessorName']
                                                .toString()),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Text(provider
                                                .closedAssessmentList[index]
                                                    ['coAssessorName']
                                                .toString()),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Text(provider
                                                .closedAssessmentList[index]
                                                    ['assesseeName']
                                                .toString()),
                                          ),
                                        ),
                                        RaisedButton(
                                          child: loading == true
                                              ? CircularProgressIndicator()
                                              : Text(
                                                  'Download',
                                                ),
                                          onPressed: () async {
                                            setState(() {
                                              loading = true;
                                            });

                                            await provider.riskProfiles(provider
                                                    .closedAssessmentList[index]
                                                ['documentId']);

                                            //images

                                            await imageLoader();

                                            writeOnPdf(
                                              provider.closedAssessmentList[
                                                  index]['name'],
                                              provider.closedAssessmentList[
                                                  index]['location'],
                                              provider.closedAssessmentList[
                                                  index]['scheduledDate'],
                                              provider.closedAssessmentList[
                                                  index]['assessorName'],
                                              provider.closedAssessmentList[
                                                  index]['coAssessorName'],
                                              provider.listOfAssessment,
                                            );
                                            setState(() {
                                              loading = false;
                                            });
                                          },
                                        )
                                      ]),
                                    );
                                  }),
                            ),
                          ),
                        ]),
                      )
                    : Center(
                        child: Container(
                          child: Text(
                            ' Site is yet to be Closed.',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
        SizedBox(
          height: AppBar().preferredSize.height * 2,
          child: Image.asset(
            'assets/mahindraAppBar.png',
            fit: BoxFit.contain,
          ),
        )
      ],
    );
  }
}
