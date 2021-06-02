import 'package:csv/csv.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;
import '../../../utilities.dart';
import 'selfassessment.dart';
import 'assessmentProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Locations extends StatefulWidget {
  @override
  _LocationsState createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  Utilities utilities = Utilities();
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssessmentProvider>(context);
    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              backgroundColor: utilities.mainColor,
              titleSpacing: 0.0,
              automaticallyImplyLeading: false,
            ),
            body: Center(
                child: provider.loading
                    ? CircularProgressIndicator()
                    : Container(
                        child: Column(children: [
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                 SizedBox(
                              width: 600,
                            ),
                                Text(
                                  'Sites:',
                                  style: TextStyle(fontSize: 25),
                                ),
                                SizedBox(width:500),
                                Text(
                                  provider.assessmentType == 'self'
                                      ? provider.self.toString()
                                      : provider.site.toString(),
                                  style: TextStyle(
                                      fontSize: 60, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: DraggableScrollbar.rrect(
                              alwaysVisibleScrollThumb: true,
                              backgroundColor: utilities.mainColor,
                              controller: _controller,
                              child: ListView.builder(
                                  controller: _controller,
                                  itemCount: provider.listOfLocations.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      child: Card(
                                        elevation: 5.0,
                                        color: (provider.assessmentType ==
                                                        'self' &&
                                                    provider.listOfLocations[
                                                                index]
                                                            ['currentStatus'] ==
                                                        'Self Assessment Uploaded') ||
                                                (provider.assessmentType ==
                                                        'site' &&
                                                    provider.listOfLocations[
                                                                index]
                                                            ['currentStatus'] !=
                                                        'Closed')
                                            ? Colors.red[50]
                                            : Colors.green[50],
                                        margin: EdgeInsets.fromLTRB(
                                            8.0, 8.0, 8.0, 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    /*  */
                                                    10,
                                                    10,
                                                    10,
                                                    10),
                                                child: Column(children: [
                                                  Text(provider.listOfLocations[
                                                              index]['name']
                                                          .toString() +
                                                      ', ' +
                                                      provider.listOfLocations[
                                                          index]['location']),
                                                ])),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        provider.locations(
                                            provider.listOfLocations[index]
                                                ['documentId']);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return ChangeNotifierProvider.value(
                                              value: provider,
                                              child: SelfAssessment(
                                                documentId: provider
                                                        .listOfLocations[index]
                                                    ['documentId'],
                                                nameofSite: provider
                                                        .listOfLocations[index]
                                                    ['name'],
                                                location: provider
                                                        .listOfLocations[index]
                                                    ['location'],
                                              ),
                                            );
                                          }),
                                        );
                                      },
                                    );
                                  }),
                            ),
                          ),
                        ]),
                      ))),
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
