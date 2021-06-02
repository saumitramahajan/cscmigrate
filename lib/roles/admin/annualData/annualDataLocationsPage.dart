import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:mahindraCSC/roles/admin/annualData/annualDataProvider.dart';
import 'package:mahindraCSC/roles/admin/annualData/reviewAnnualData.dart';

import 'package:provider/provider.dart';

import '../../../utilities.dart';

class AnnualDataLocations extends StatefulWidget {
  @override
  _AnnualDataLocations createState() => _AnnualDataLocations();
}

class _AnnualDataLocations extends State<AnnualDataLocations> {
  Utilities utilities = Utilities();
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AnnualDataProvider>(context);
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
                          Text(
                            'Sites:',
                            style: TextStyle(fontSize: 25),
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
                                        margin: EdgeInsets.fromLTRB(
                                            8.0, 8.0, 8.0, 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 10, 10, 10),
                                                child: Column(children: [
                                                  Text(provider.listOfLocations[
                                                              index]
                                                          ['nameOfSector'] +
                                                      ',' +
                                                      provider.listOfLocations[
                                                          index]['location']),
                                                ])),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        provider.getMonth(
                                            provider.listOfLocations[index]
                                                ['documentId'],
                                            provider.listOfLocations[index]
                                                ['nameOfSector'],
                                            provider.listOfLocations[index]
                                                ['location']);
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ChangeNotifierProvider.value(
                                            value: provider,
                                            child: ReviewAnnualData(),
                                          );
                                        }));
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
