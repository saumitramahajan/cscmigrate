import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:mahindraCSC/assessments/siteAssessment/siteAssessment.dart';
import 'package:mahindraCSC/utilities.dart';
import 'package:url_launcher/url_launcher.dart';

import 'assessorLocationInfoprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AssessorLocationInfo extends StatefulWidget {
  @override
  _AssessorLocationInfoState createState() => _AssessorLocationInfoState();
}

class _AssessorLocationInfoState extends State<AssessorLocationInfo> {
  Utilities utilities = Utilities();
  ScrollController _controller = ScrollController();
  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssessmentLocationInfoProvider>(context);

    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              backgroundColor: utilities.mainColor,
              titleSpacing: 0.0,
              automaticallyImplyLeading: false,
              actions: [
                FlatButton(
                    child: Text('Next',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) =>
                              SiteAssessment('site', provider.locationId)));
                    })
              ],
            ),
            body: (provider.loading)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: DraggableScrollbar.rrect(
                          alwaysVisibleScrollThumb: true,
                          backgroundColor: utilities.mainColor,
                          controller: _controller,
                          child: ListView.builder(
                            controller: _controller,
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 40, 10, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(20),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Name Of the Site:',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      ((provider.infoMap[
                                                                  'siteName'] ==
                                                              '')
                                                          ? ''
                                                          : provider.infoMap[
                                                                  'siteName']
                                                              .toString()),
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                                decoration: new BoxDecoration(
                                                  borderRadius: new BorderRadius
                                                          .only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20)),
                                                  color: Colors.red[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.95,
                                      child: Card(
                                          child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Row(
                                          children: [
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text('Occupier:',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey)),
                                                          SizedBox(height: 40),
                                                          Text('Site Head:',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey)),
                                                          SizedBox(height: 40),
                                                          Text(
                                                              'Safety Incharge:',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey)),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 40,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                              child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                Text(
                                                                  ((provider.infoMap[
                                                                              'occupierName'] ==
                                                                          '')
                                                                      ? ''
                                                                      : provider
                                                                              .infoMap[
                                                                          'occupierName']),
                                                                ),
                                                                Text(
                                                                  ((provider.infoMap[
                                                                              'occupierEmail'] ==
                                                                          '')
                                                                      ? ''
                                                                      : provider
                                                                              .infoMap[
                                                                          'occupierEmail']),
                                                                ),
                                                              ])),
                                                          SizedBox(height: 20),
                                                          SizedBox(
                                                              child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                Text(
                                                                  ((provider.infoMap[
                                                                              'headName'] ==
                                                                          '')
                                                                      ? ''
                                                                      : provider
                                                                              .infoMap[
                                                                          'headName']),
                                                                ),
                                                                Text(
                                                                  ((provider.infoMap[
                                                                              'headEmail'] ==
                                                                          '')
                                                                      ? ''
                                                                      : provider
                                                                              .infoMap[
                                                                          'headEmail']),
                                                                ),
                                                              ])),
                                                          SizedBox(height: 20),
                                                          SizedBox(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  ((provider.infoMap[
                                                                              'safetyInchargeName'] ==
                                                                          '')
                                                                      ? ''
                                                                      : provider
                                                                              .infoMap[
                                                                          'safetyInchargeName']),
                                                                ),
                                                                Text(
                                                                  ((provider.infoMap[
                                                                              'safetyInchargeEmail'] ==
                                                                          '')
                                                                      ? ''
                                                                      : provider
                                                                              .infoMap[
                                                                          'safetyInchargeEmail']),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ]),
                                            SizedBox(width: 200),
                                            Column(
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text('Fire Incharge:',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey)),
                                                        SizedBox(height: 40),
                                                        Text(
                                                            'Office Safety Incharge:',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey)),
                                                        SizedBox(height: 40),
                                                        Text(
                                                            'Utilities Incharge:',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey)),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 40,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                ((provider.infoMap[
                                                                            'fireInchargeName'] ==
                                                                        '')
                                                                    ? ''
                                                                    : provider
                                                                            .infoMap[
                                                                        'fireInchargeName']),
                                                              ),
                                                              Text(
                                                                ((provider.infoMap[
                                                                            'fireInchargeEmail'] ==
                                                                        '')
                                                                    ? ''
                                                                    : provider
                                                                            .infoMap[
                                                                        'fireInchargeEmail']),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 20),
                                                        SizedBox(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                ((provider.infoMap[
                                                                            'officeSafetyInchargeName'] ==
                                                                        '')
                                                                    ? ''
                                                                    : provider
                                                                            .infoMap[
                                                                        'officeSafetyInchargeName']),
                                                              ),
                                                              Text(
                                                                ((provider.infoMap[
                                                                            'officeSafetyInchargeEmail'] ==
                                                                        '')
                                                                    ? ''
                                                                    : provider
                                                                            .infoMap[
                                                                        'officeSafetyInchargeEmail']),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 20),
                                                        SizedBox(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                ((provider.infoMap[
                                                                            'utilitiesName'] ==
                                                                        '')
                                                                    ? ''
                                                                    : provider
                                                                            .infoMap[
                                                                        'utilitiesName']),
                                                              ),
                                                              Text(
                                                                ((provider.infoMap[
                                                                            'utilitiesEmail'] ==
                                                                        '')
                                                                    ? ''
                                                                    : provider
                                                                            .infoMap[
                                                                        'utilitiesEmail']),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ))),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
                                    child: Card(
                                      child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Last Assessment Stage',
                                                    style: TextStyle(
                                                        color: Colors.grey)),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text('Process Level',
                                                    style: TextStyle(
                                                        color: Colors.grey)),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text('Result Level',
                                                    style: TextStyle(
                                                        color: Colors.grey))
                                              ],
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(provider.infoMap[
                                                    'lastAssessmentStage']),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(provider
                                                    .infoMap['processLevel']),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(provider
                                                    .infoMap['resultLevel']),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.95,
                                      child: Card(
                                        child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Does your site covered under " The Manufacture, Storage, and Import of Hazardous Chemical Rules 1989"?',
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                    ((provider.infoMap[
                                                                'ruleValue'] ==
                                                            true)
                                                        ? 'Yes'
                                                        : 'No'),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  (provider
                                                          .infoMap['ruleValue'])
                                                      ? SizedBox(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Mention the Reason For Applicability:',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                              Text(
                                                                ((provider.infoMap[
                                                                            'rule'] ==
                                                                        '')
                                                                    ? ''
                                                                    : provider
                                                                        .infoMap[
                                                                            'rule']
                                                                        .toString()),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    'Does your site has LPG/Propane?',
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                    ((provider.infoMap[
                                                                'lpgValue'] ==
                                                            true)
                                                        ? 'Yes'
                                                        : 'No'),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  (provider.infoMap['lpgValue'])
                                                      ? SizedBox(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Quantitiy in Tonnes:',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                              Text(
                                                                ((provider.infoMap[
                                                                            'lpg'] ==
                                                                        '')
                                                                    ? ''
                                                                    : provider
                                                                        .infoMap[
                                                                            'lpg']
                                                                        .toString()),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    'Does your site has Gasoline?',
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                    ((provider.infoMap[
                                                                'gasolineValue'] ==
                                                            true)
                                                        ? 'Yes'
                                                        : 'No'),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  (provider.infoMap[
                                                          'gasolineValue'])
                                                      ? SizedBox(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Quantitiy in kl:',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                              Text(
                                                                ((provider.infoMap[
                                                                            'gasoline'] ==
                                                                        '')
                                                                    ? ''
                                                                    : provider
                                                                        .infoMap[
                                                                            'gasoline']
                                                                        .toString()),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    'Does your site has CNG/PNG?',
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                    ((provider.infoMap[
                                                                'cngValue'] ==
                                                            true)
                                                        ? 'Yes'
                                                        : 'No'),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  (provider.infoMap['cngValue'])
                                                      ? SizedBox(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Quantitiy in kg:',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                              Text(
                                                                ((provider.infoMap[
                                                                            'cng'] ==
                                                                        '')
                                                                    ? ''
                                                                    : provider
                                                                        .infoMap[
                                                                            'cng']
                                                                        .toString()),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    'Does your site has Paint Shop?',
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                    ((provider.infoMap[
                                                                'paintShopValue'] ==
                                                            true)
                                                        ? 'Yes'
                                                        : 'No'),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  (provider.infoMap[
                                                          'paintShopValue'])
                                                      ? SizedBox(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Capacity:',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                              Text(
                                                                ((provider.infoMap[
                                                                            'paintShop'] ==
                                                                        '')
                                                                    ? ''
                                                                    : provider
                                                                        .infoMap[
                                                                            'paintShop']
                                                                        .toString()),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    'Does your site has Melting/Foundry?',
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                    ((provider.infoMap[
                                                                'foundryValue'] ==
                                                            true)
                                                        ? 'Yes'
                                                        : 'No'),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  (provider.infoMap[
                                                          'foundryValue'])
                                                      ? SizedBox(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Capacity:',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                              Text(
                                                                ((provider.infoMap[
                                                                            'foundry'] ==
                                                                        '')
                                                                    ? ''
                                                                    : provider
                                                                        .infoMap[
                                                                            'foundry']
                                                                        .toString()),
                                                              ),
                                                              provider.infoMap[
                                                                          'foundryUrl'] !=
                                                                      null
                                                                  ? RaisedButton(
                                                                      onPressed:
                                                                          () {
                                                                        launchURL(
                                                                            provider.infoMap['foundryUrl']);
                                                                      },
                                                                      child: Text(
                                                                          'View File'),
                                                                    )
                                                                  : SizedBox()
                                                            ],
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    'Does your site has Press Machine?',
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                    ((provider.infoMap[
                                                                'pressValue'] ==
                                                            true)
                                                        ? 'Yes'
                                                        : 'No'),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  (provider.infoMap[
                                                          'pressValue'])
                                                      ? SizedBox(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Capacity:',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                              Text(
                                                                ((provider.infoMap[
                                                                            'press'] ==
                                                                        '')
                                                                    ? ''
                                                                    : provider
                                                                        .infoMap[
                                                                            'press']
                                                                        .toString()),
                                                              ),
                                                              provider.infoMap[
                                                                          'pressUrl'] !=
                                                                      null
                                                                  ? RaisedButton(
                                                                      onPressed:
                                                                          () {
                                                                        launchURL(
                                                                            provider.infoMap['pressUrl']);
                                                                      },
                                                                      child: Text(
                                                                          'View File'),
                                                                    )
                                                                  : SizedBox()
                                                            ],
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    'Does your site has diesel Storage?',
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                    ((provider.infoMap[
                                                                'dieselValue'] ==
                                                            true)
                                                        ? 'Yes'
                                                        : 'No'),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  (provider.infoMap[
                                                          'dieselValue'])
                                                      ? SizedBox(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Quantitiy in kl:',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                              Text(
                                                                ((provider.infoMap[
                                                                            'diesel'] ==
                                                                        '')
                                                                    ? ''
                                                                    : provider
                                                                        .infoMap[
                                                                            'diesel']
                                                                        .toString()),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    'Does your site has thinner/Other Class A storage?',
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                    ((provider.infoMap[
                                                                'thinnerValue'] ==
                                                            true)
                                                        ? 'Yes'
                                                        : 'No'),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  (provider.infoMap[
                                                          'thinnerValue'])
                                                      ? SizedBox(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Quantitiy in kl:',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                              Text(
                                                                ((provider.infoMap[
                                                                            'thinner'] ==
                                                                        '')
                                                                    ? ''
                                                                    : provider
                                                                        .infoMap[
                                                                            'thinner']
                                                                        .toString()),
                                                              ),
                                                              provider.infoMap[
                                                                          'thinnerUrl'] !=
                                                                      null
                                                                  ? RaisedButton(
                                                                      onPressed:
                                                                          () {
                                                                        launchURL(
                                                                            provider.infoMap['thinnerUrl']);
                                                                      },
                                                                      child: Text(
                                                                          'View File'),
                                                                    )
                                                                  : SizedBox()
                                                            ],
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    'Does your site has Toxic Chemicals?',
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                    ((provider.infoMap[
                                                                'toxicValue'] ==
                                                            true)
                                                        ? 'Yes'
                                                        : 'No'),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  (provider.infoMap[
                                                          'toxicValue'])
                                                      ? SizedBox(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Quantitiy and Name:',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                              Text(
                                                                ((provider.infoMap[
                                                                            'toxic'] ==
                                                                        '')
                                                                    ? ''
                                                                    : provider
                                                                        .infoMap[
                                                                            'toxic']
                                                                        .toString()),
                                                              ),
                                                              provider.infoMap[
                                                                          'toxicUrl'] !=
                                                                      null
                                                                  ? RaisedButton(
                                                                      onPressed:
                                                                          () {
                                                                        launchURL(
                                                                            provider.infoMap['toxicUrl']);
                                                                      },
                                                                      child: Text(
                                                                          'View File'),
                                                                    )
                                                                  : SizedBox()
                                                            ],
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    'Does your site has Heat Treatment?',
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                    ((provider.infoMap[
                                                                'heatValue'] ==
                                                            true)
                                                        ? 'Yes'
                                                        : 'No'),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  (provider
                                                          .infoMap['heatValue'])
                                                      ? SizedBox(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Quantitiy and Name:',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                              Text(
                                                                ((provider.infoMap[
                                                                            'heat'] ==
                                                                        '')
                                                                    ? ''
                                                                    : provider
                                                                        .infoMap[
                                                                            'heat']
                                                                        .toString()),
                                                              ),
                                                              provider.infoMap[
                                                                          'heatUrl'] !=
                                                                      null
                                                                  ? RaisedButton(
                                                                      onPressed:
                                                                          () {
                                                                        launchURL(
                                                                            provider.infoMap['heatUrl']);
                                                                      },
                                                                      child: Text(
                                                                          'View File'),
                                                                    )
                                                                  : SizedBox()
                                                            ],
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    'Does your site has Test Bed?',
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                    ((provider.infoMap[
                                                                'testBedValue'] ==
                                                            true)
                                                        ? 'Yes'
                                                        : 'No'),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  (provider.infoMap[
                                                          'testBedValue'])
                                                      ? SizedBox(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Nos:',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                              Text(
                                                                ((provider.infoMap[
                                                                            'testBed'] ==
                                                                        '')
                                                                    ? ''
                                                                    : provider
                                                                        .infoMap[
                                                                            'testBed']
                                                                        .toString()),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    'Does your site has Boiler?Does it covered under IBR(Indian Boiler Regulation)?',
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                    ((provider.infoMap[
                                                                'ibrValue'] ==
                                                            true)
                                                        ? 'Yes'
                                                        : 'No'),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  (provider.infoMap['ibrValue'])
                                                      ? SizedBox(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Number and their capacity:',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                              Text(
                                                                ((provider.infoMap[
                                                                            'ibr'] ==
                                                                        '')
                                                                    ? ''
                                                                    : provider
                                                                        .infoMap[
                                                                            'ibr']
                                                                        .toString()),
                                                              ),
                                                              provider.infoMap[
                                                                          'ibrUrl'] !=
                                                                      null
                                                                  ? RaisedButton(
                                                                      onPressed:
                                                                          () {
                                                                        launchURL(
                                                                            provider.infoMap['ibrUrl']);
                                                                      },
                                                                      child: Text(
                                                                          'View File'),
                                                                    )
                                                                  : SizedBox()
                                                            ],
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                ])),
                                      )),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Incident Statistics',
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                )),
                                            SizedBox(height: 20),
                                            Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Fatal(Nos):',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.grey)),
                                                    SizedBox(height: 10),
                                                    Text('Reportable(Nos):',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.grey)),
                                                    SizedBox(height: 10),
                                                    Text('Non-Reportable(Nos):',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.grey)),
                                                    SizedBox(height: 10),
                                                    Text(
                                                        'First Aid Cases(Nos):',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.grey)),
                                                    SizedBox(height: 10),
                                                    Text('Fire Incident(Nos):',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.grey)),
                                                  ],
                                                ),
                                                SizedBox(width: 20),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      ((provider.infoMap[
                                                                  'fatal'] ==
                                                              '')
                                                          ? ''
                                                          : provider
                                                              .infoMap['fatal']
                                                              .toString()),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      ((provider.infoMap[
                                                                  'reportable'] ==
                                                              '')
                                                          ? ''
                                                          : provider.infoMap[
                                                                  'reportable']
                                                              .toString()),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      ((provider.infoMap[
                                                                  'nonReportable'] ==
                                                              '')
                                                          ? ''
                                                          : provider.infoMap[
                                                                  'nonReportable']
                                                              .toString()),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      ((provider.infoMap[
                                                                  'firstAid'] ==
                                                              '')
                                                          ? ''
                                                          : provider.infoMap[
                                                                  'firstAid']
                                                              .toString()),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      ((provider.infoMap[
                                                                  'fire'] ==
                                                              '')
                                                          ? ''
                                                          : provider
                                                              .infoMap['fire']
                                                              .toString()),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        )),
                  ])),
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
