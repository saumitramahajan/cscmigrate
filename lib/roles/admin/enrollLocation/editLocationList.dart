import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:mahindraCSC/roles/admin/enrollLocation/editLoactionInfo.dart';

import '../../../utilities.dart';

import 'package:flutter/material.dart';

class EditLocationList extends StatefulWidget {
  @override
  _EditLocationListState createState() => _EditLocationListState();
}

class _EditLocationListState extends State<EditLocationList> {
  bool loading = false;
  int selectedIndex;
  String groupValue;
  String query;
  Utilities utilities = Utilities();
  ScrollController _controller = ScrollController();
  List<Map<String, dynamic>> locationList = [];
  List<Map<String, dynamic>> mainList = [];
  List<Map<String, String>> assesseeList = [];

  Future<List<Map<String, dynamic>>> getLocationMap() async {
    locationList = mainList;
    await FirebaseFirestore.instance
        .collection('locations')
        .get()
        .then((QuerySnapshot location) {
      location.docs.forEach((element) {
        Map<String, dynamic> locationMap = {};

        locationMap = element.data();
        locationMap['documentId'] = element.id;

        mainList.add(locationMap);
      });
    });

    return locationList;
  }

  void setIndex(int index) {
    selectedIndex = index;
    print(selectedIndex);
  }

  void getLocation() async {
    setState(() {
      loading = true;
    });

    await getLocationMap();
    setState(() {
      loading = false;
    });
  }

  Future<void> filter() async {
    setState(() {
      loading = true;
    });
    

    locationList = [];

    for (int i = 0; i < mainList.length; i++) {
      if (mainList[i]['nameOfSector']
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          mainList[i]['location']
              .toLowerCase()
              .contains(query.toLowerCase())) {
        locationList.add(mainList[i]);
      }
    }
setState(() {
  loading = false;
});
    
  }

  @override
  void initState() {
    getLocation();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    SizedBox(height:20),
                    Text(
                      'Sector and Location',
                      style: TextStyle(
                          color: Colors.white,fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        cursorColor: Colors.white,
                        style: TextStyle(
                          color: Colors.white,
                        ),
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
                    ),
                    RaisedButton(
                        child: Text('Filter'),
                        onPressed: () {
                          filter();
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
                  loading == false
                      ? Builder(
                          builder: (context) => IconButton(
                              icon: Icon(Icons.filter_list),
                              onPressed: () =>
                                  Scaffold.of(context).openEndDrawer(),
                              tooltip: 'Filter'),
                        )
                      : SizedBox(),
                ]),
            body: Center(
                child: loading == true
                    ? CircularProgressIndicator()
                    : Container(
                        child: Column(children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'List Of Location:',
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
                                    itemCount: locationList.length,
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
                                                    Text(
                                                      locationList[index]
                                                              ['nameOfSector'] +
                                                          ', ' +
                                                          locationList[index]
                                                              ['location'],
                                                    ),
                                                  ])),
                                            ],
                                          ),
                                        ),
                                        onTap: () async {
                                          await Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return EditLocationInfo(
                                                locationMap:
                                                    locationList[index]);
                                          }));
                                        },
                                      );
                                    })),
                          )
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
