import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:mahindraCSC/roles/admin/enrollUsers/editUserInfo.dart';
import 'package:mahindraCSC/roles/admin/enrollUsers/enrollUsersProvider.dart';

import '../../../utilities.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  String query;
  Utilities utilities = Utilities();
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EnrollUsersProvider>(context);
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
                            'Users:',
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    query = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          RaisedButton(
                              child: Text(
                                'Search',
                              ),
                              onPressed: () {
                                setState(() {
                                  provider.loading = true;
                                });
                                provider.filter(query);

                                setState(() {
                                  provider.loading = false;
                                });
                              }),
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                             child: DraggableScrollbar.rrect(
                                alwaysVisibleScrollThumb: true,
                                backgroundColor: utilities.mainColor,
                                controller: _controller,
                                child: ListView.builder(
                                itemCount: provider.listOfUsers.length,
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
                                                Text(provider.listOfUsers[index]
                                                        ['name']
                                                    .toString()),
                                              ])),
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
                                      provider.setIndex(index);
                                      provider.role(provider.listOfUsers[
                                          provider.selectedIndex]['role']);

                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return EditUserInfo(
                                            name: provider.listOfUsers[
                                                provider.selectedIndex]['name'],
                                            email: provider.listOfUsers[provider
                                                .selectedIndex]['email'],
                                            assessorVal: provider.roles[0],
                                            assesseeVal: provider.roles[1],
                                            plantheadVal: provider.roles[2],
                                            uid: provider.listOfUsers[provider
                                                .selectedIndex]['documentId'],
                                          );
                                        }),
                                      );
                                      Navigator.of(context).pop();
                                    },
                                  );
                                }),
                          )),
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
