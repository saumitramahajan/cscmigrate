import 'package:flutter/material.dart';
import 'package:mahindraCSC/roles/admin/annualData/annualDataProvider.dart';
import 'package:provider/provider.dart';

class AssessmentAnnualData extends StatefulWidget {
  @override
  _AssessmentAnnualDataState createState() => _AssessmentAnnualDataState();
}

class _AssessmentAnnualDataState extends State<AssessmentAnnualData> {
  @override
  Widget build(BuildContext context) {
    final adprovider = Provider.of<AnnualDataProvider>(context);
    List<bool> opens = List.generate(
        adprovider.assessmentAnnualDataList.length, (index) => false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff4001c),
        title: SizedBox(
          height: AppBar().preferredSize.height,
          child: Image.asset(
            'assets/mahindraAppBar.png',
            fit: BoxFit.contain,
          ),
        ),
        titleSpacing: 0.0,
        automaticallyImplyLeading: false,
      ),
      body: adprovider.loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ListView.builder(
                    itemCount: adprovider.assessmentAnnualDataList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (opens[index]) {
                              opens[index] = false;
                            } else {
                              opens[index] = true;
                            }
                            print(opens.toString() + index.toString());
                          });
                        },
                        child: Card(
                            child: ExpansionTile(
                          title: Text('Location: ' +
                              adprovider.assessmentAnnualDataList[index]
                                  ['location']),
                          children: [
                            (adprovider.assessmentAnnualDataList[index]
                                        ['category'] ==
                                    'category1')
                                ? category1View(
                                    adprovider.assessmentAnnualDataList[index])
                                : category2View(
                                    adprovider.assessmentAnnualDataList[index]),
                          ],
                        )),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget category1View(Map<String, String> map) {
    return Column(
      children: [
        Text('Manpower: ' + map['manPower']),
        Text('Fatal(A): ' + map['fatal']),
        Text('Reportable Accidents(B): ' + map['reportableAccidents']),
        Text(
            'Man-days lost due to Reportable Accidents: ' + map['manDaysLost']),
        Text('Non-Reportabel Accidents(C): ' + map['nonReportableAccidents']),
        Text('Man-days lost due to Non-Reportable Accidents: ' +
            map['manDaysLostNra']),
        Text('First Aid Accidents: ' + map['firstaidAccidents']),
        Text('Total Accidents: ' + map['totalAccidents']),
        Text('On Duty Road Accidents(Fatal): ' + map['fatalAccidents']),
        Text('On Duty Road Accidents(Serious): ' + map['manPower']),
        Text('Fire Incident(Major): ' + map['fireIncidents']),
        Text('Fire Incidents(Minor): ' + map['fireIncidentMinor']),
        Text('Kiazen/Poka-Yoke: ' + map['kaizen']),
        Text('Identified UA/UC: ' + map['identified']),
        Text('Safety Activity Rate: ' + map['safetyActivityRate']),
        Text('Closure of UA/UC: ' + map['closureOf']),
        Text('Theme Based Inspection: ' + map['themeBasedInspections']),
        Text('Near Miss Incidents: ' + map['nearMissIncidents']),
      ],
    );
  }

  Widget category2View(Map<String, String> map) {
    return Column(
      children: [
        Text('Manpower: ' + map['manPower']),
        Text('Fatal: ' + map['fatal']),
        Text('On Duty Road Accidents: ' + map['onDutyFatal']),
        Text('Reportable Accidents: ' + map['reportableAccidents']),
        Text('Fire Incident(Major): ' + map['fireIncidentsMajor']),
        Text('Fire Incidents(Minor): ' + map['fireIncidentMinor']),
      ],
    );
  }
}
