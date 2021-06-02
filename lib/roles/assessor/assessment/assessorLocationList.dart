import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:mahindraCSC/roles/assessor/assessment/assessorLocationInfoBase.dart';
import 'package:mahindraCSC/utilities.dart';

import 'assessorLocationListProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AssessorLocationListInfo extends StatefulWidget {
  @override
  _AssessorLocationListInfo createState() => _AssessorLocationListInfo();
}

class _AssessorLocationListInfo extends State<AssessorLocationListInfo> {
  Utilities utilities = Utilities();
  ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssessorLocationListInfoProvider>(context);
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
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Column(children: [
                          Text(
                            ' Assigned Assessment Sites',
                            style: TextStyle(fontSize: 25),
                          ),
                          Expanded(
                            child: DraggableScrollbar.rrect(
                              alwaysVisibleScrollThumb: true,
                              backgroundColor: utilities.mainColor,
                              controller: _controller,
                              child: ListView.builder(
                                  controller: _controller,
                                  itemCount:
                                      provider.listOfAssessorLocation.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      child: Card(
                                        elevation: 5.0,
                                        margin: EdgeInsets.fromLTRB(
                                            8.0, 8.0, 8.0, 8.0),
                                        child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 10, 10, 10),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    provider.listOfAssessorLocation[
                                                            index]['name'] +
                                                        ', ' +
                                                        provider.listOfAssessorLocation[
                                                            index]['location'],
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  Icon(Icons.arrow_forward)
                                                ])),
                                      ),
                                      onTap: () {
                                        print(provider
                                                .listOfAssessorLocation[index]
                                            ['locationId']);
                                        Navigator.of(context)
                                            .pushReplacement(MaterialPageRoute(
                                          builder: (context) => AssessorInfo(
                                            cycleId:
                                                provider.listOfAssessorLocation[
                                                    index]['locationId'],
                                          ),
                                        ));
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
