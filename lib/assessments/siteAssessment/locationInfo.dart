// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mahindraCSC/assessments/siteAssessment/beforeSubmit.dart';
import 'package:mahindraCSC/assessments/siteAssessment/siteAssessmentProvider.dart';
import 'package:provider/provider.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:url_launcher/url_launcher.dart';
import '../../utilities.dart';

class LocationInfo extends StatefulWidget {
  final bool dataExists;
  final String documentId;
  final String siteName;
  final String occupierName;
  final String occupierEmail;
  final String headName;
  final String headEmail;
  final String safetyInchargeName;
  final String safetyInchargeEmail;
  final String fireInchargeName;
  final String fireInchargeEmail;
  final String officeSafetyInchargeName;
  final String officeSafetyInchargeEmail;
  final String utilitiesName;
  final String utilitiesEmail;
  final String rule;
  final String lpg;
  final String gasoline;
  final String cng;
  final String paintShop;
  final String foundry;
  final String press;
  final String desiel;
  final String thinner;
  final String toxic;
  final String heat;
  final String testBed;
  final String ibr;
  final String fatal;
  final String reportable;
  final String nonReportable;
  final String firstAid;
  final String fire;
  final String foundryUrl;
  final String pressUrl;
  final String thinnerUrl;
  final String heatUrl;
  final String toxicUrl;
  final String boilerUrl;
  final bool ruleValue;
  final bool lpgValue;
  final bool gasolineValue;
  final bool cngValue;
  final bool paintShopValue;
  final bool foundryValue;
  final bool pressValue;
  final bool desielValue;
  final bool thinnerValue;
  final bool toxicValue;
  final bool heatValue;
  final bool testBedValue;
  final bool ibrValue;

  LocationInfo(
      {Key key,
      this.dataExists,
      this.documentId,
      this.siteName,
      this.occupierName,
      this.occupierEmail,
      this.headName,
      this.headEmail,
      this.safetyInchargeName,
      this.safetyInchargeEmail,
      this.fireInchargeName,
      this.fireInchargeEmail,
      this.officeSafetyInchargeName,
      this.officeSafetyInchargeEmail,
      this.utilitiesName,
      this.utilitiesEmail,
      this.rule,
      this.lpg,
      this.gasoline,
      this.cng,
      this.paintShop,
      this.foundry,
      this.press,
      this.desiel,
      this.thinner,
      this.toxic,
      this.heat,
      this.testBed,
      this.ibr,
      this.fatal,
      this.reportable,
      this.nonReportable,
      this.firstAid,
      this.fire,
      this.foundryUrl,
      this.pressUrl,
      this.thinnerUrl,
      this.toxicUrl,
      this.heatUrl,
      this.boilerUrl,
      this.ruleValue,
      this.lpgValue,
      this.gasolineValue,
      this.cngValue,
      this.paintShopValue,
      this.foundryValue,
      this.pressValue,
      this.desielValue,
      this.thinnerValue,
      this.toxicValue,
      this.heatValue,
      this.testBedValue,
      this.ibrValue})
      : super(key: key);
  @override
  _LocationInfoState createState() => _LocationInfoState();
}

class _LocationInfoState extends State<LocationInfo> {
  fb.UploadTask _foundryUploadTask;
  fb.UploadTask _pressUploadTask;
  fb.UploadTask _thinnerUploadTask;
  fb.UploadTask _heatUploadTask;
  fb.UploadTask _boilerUploadTask;
  fb.UploadTask _toxicUploadTask;
  bool pressLoading = false;
  bool thinnerLoading = false;
  bool heatLoading = false;
  bool boilerLoading = false;
  bool toxicLoading = false;
  String foundryUrl;
  String toxicUrl;
  String pressUrl;
  String thinnerUrl;
  String heatUrl;
  String boilerUrl;

  String error = '';
  bool foundryLoading = false;
  String documentId;
  TextEditingController _siteName = TextEditingController();
  TextEditingController _occupierName = TextEditingController();
  TextEditingController _occupierEmail = TextEditingController();
  TextEditingController _headName = TextEditingController();
  TextEditingController _headEmail = TextEditingController();
  TextEditingController _safetyInchargeName = TextEditingController();
  TextEditingController _safetyInchargeEmail = TextEditingController();
  TextEditingController _fireInchargeName = TextEditingController();
  TextEditingController _fireInchargeEmail = TextEditingController();
  TextEditingController _officeSafetyInchargeName = TextEditingController();
  TextEditingController _officeSafetyInchargeEmail = TextEditingController();
  TextEditingController _utilitiesName = TextEditingController();
  TextEditingController _utilitiesEmail = TextEditingController();
  TextEditingController _rule = TextEditingController();
  TextEditingController _lpg = TextEditingController();
  TextEditingController _gasoline = TextEditingController();
  TextEditingController _cng = TextEditingController();
  TextEditingController _paintShop = TextEditingController();
  TextEditingController _foundry = TextEditingController();
  TextEditingController _press = TextEditingController();
  TextEditingController _desiel = TextEditingController();
  TextEditingController _thinner = TextEditingController();
  TextEditingController _toxic = TextEditingController();
  TextEditingController _heat = TextEditingController();
  TextEditingController _testBed = TextEditingController();
  TextEditingController _ibr = TextEditingController();
  TextEditingController _fatal = TextEditingController();
  TextEditingController _reportable = TextEditingController();
  TextEditingController _nonReportable = TextEditingController();
  TextEditingController _firstAid = TextEditingController();
  TextEditingController _fire = TextEditingController();
  bool _ruleValue = false;
  bool _lpgValue = false;
  bool _gasolineValue = false;
  bool _cngValue = false;
  bool _paintShopValue = false;
  bool _foundryValue = false;
  bool _pressValue = false;
  bool _desielValue = false;
  bool _thinnerValue = false;
  bool _toxicValue = false;
  bool _heatValue = false;
  bool _testBedValue = false;
  bool _ibrValue = false;

  @override
  void initState() {
    super.initState();
    print(widget.dataExists);
    if (widget.dataExists) {
      _siteName.text = widget.siteName;
      documentId = widget.documentId;
      _occupierName.text = widget.occupierName;
      _occupierEmail.text = widget.occupierEmail;
      _headName.text = widget.headName;
      _headEmail.text = widget.headEmail;
      _safetyInchargeEmail.text = widget.safetyInchargeEmail;
      _safetyInchargeName.text = widget.safetyInchargeName;
      _fireInchargeName.text = widget.fireInchargeName;
      _fireInchargeEmail.text = widget.fireInchargeEmail;
      _officeSafetyInchargeName.text = widget.officeSafetyInchargeName;
      _officeSafetyInchargeEmail.text = widget.officeSafetyInchargeEmail;
      _utilitiesName.text = widget.utilitiesName;
      _utilitiesEmail.text = widget.utilitiesEmail;
      _rule.text = widget.rule;
      _lpg.text = widget.lpg;
      _gasoline.text = widget.gasoline;
      _cng.text = widget.cng;
      _paintShop.text = widget.paintShop;
      _foundry.text = widget.foundry;
      _press.text = widget.press;
      _desiel.text = widget.desiel;
      _thinner.text = widget.thinner;
      _toxic.text = widget.toxic;
      _heat.text = widget.heat;
      _testBed.text = widget.testBed;
      _ibr.text = widget.ibr;
      _fatal.text = widget.fatal;
      _reportable.text = widget.reportable;
      _nonReportable.text = widget.nonReportable;
      _firstAid.text = widget.firstAid;
      _fire.text = widget.fire;
      _ruleValue = widget.ruleValue;
      _lpgValue = widget.lpgValue;
      _gasolineValue = widget.gasolineValue;
      _cngValue = widget.cngValue;
      _paintShopValue = widget.paintShopValue;
      _foundryValue = widget.foundryValue;
      _pressValue = widget.pressValue;
      _desielValue = widget.desielValue;
      _thinnerValue = widget.thinnerValue;
      _toxicValue = widget.toxicValue;
      _heatValue = widget.heatValue;
      _testBedValue = widget.testBedValue;
      _ibrValue = widget.ibrValue;
      foundryLoading = (widget.foundryUrl != null);
      foundryUrl = widget.foundryUrl;
      pressUrl = widget.pressUrl;
      thinnerUrl = widget.thinnerUrl;
      heatUrl = widget.heatUrl;
      toxicUrl = widget.toxicUrl;
      boilerUrl = widget.boilerUrl;
      pressLoading = (widget.pressUrl != null);
      thinnerLoading = (widget.thinnerUrl != null);
      toxicLoading = (widget.toxicUrl != null);
      heatLoading = (widget.heatUrl != null);
      boilerLoading = (widget.boilerUrl != null);
      print('Data setup finished' +
          _pressValue.toString() +
          _desielValue.toString());
    } else {
      documentId = widget.documentId;
    }
  }

  void uploadFile(String type) {
    html.InputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      final file = files[0];
      final reader = new html.FileReader();
      reader.readAsDataUrl(file);

      reader.onLoadEnd.listen(
        (loadEndEvent) async {
          uploadToFirebase(file, type);
        },
      );
    });
  }

  uploadToFirebase(html.File imageFile, String type) async {
    final filePath = 'documents/${DateTime.now()}.pdf';

    switch (type) {
      case 'foundry':
        {
          setState(() {
            _foundryUploadTask = fb
                .storage()
                .refFromURL('gs://mahindracsc-e5468.appspot.com')
                .child(filePath)
                .put(imageFile);
          });
          setUrl('foundry', filePath);
        }
        break;
      case 'press':
        {
          setState(() {
            _pressUploadTask = fb
                .storage()
                .refFromURL('gs://mahindracsc-e5468.appspot.com')
                .child(filePath)
                .put(imageFile);
          });
          setUrl('press', filePath);
        }
        break;
      case 'thinner':
        {
          setState(() {
            _thinnerUploadTask = fb
                .storage()
                .refFromURL('gs://mahindracsc-e5468.appspot.com')
                .child(filePath)
                .put(imageFile);
          });
          setUrl('thinner', filePath);
        }
        break;
      case 'toxic':
        {
          setState(() {
            _toxicUploadTask = fb
                .storage()
                .refFromURL('gs://mahindracsc-e5468.appspot.com')
                .child(filePath)
                .put(imageFile);
          });
          setUrl('toxic', filePath);
        }
        break;
      case 'heat':
        {
          setState(() {
            _heatUploadTask = fb
                .storage()
                .refFromURL('gs://mahindracsc-e5468.appspot.com')
                .child(filePath)
                .put(imageFile);
          });
          setUrl('heat', filePath);
        }
        break;
      case 'boiler':
        {
          setState(() {
            _boilerUploadTask = fb
                .storage()
                .refFromURL('gs://mahindracsc-e5468.appspot.com')
                .child(filePath)
                .put(imageFile);
          });
          setUrl('boiler', filePath);
        }
        break;
    }
  }

  setUrl(String type, String filePath) async {
    switch (type) {
      case 'foundry':
        {
          await _foundryUploadTask.future;
          Uri uri = await fb
              .storage()
              .refFromURL('gs://mahindracsc-e5468.appspot.com')
              .child(filePath)
              .getDownloadURL();

          setState(() {
            foundryLoading = true;
            foundryUrl = uri.toString();
          });
        }
        break;
      case 'press':
        {
          await _pressUploadTask.future;
          Uri uri = await fb
              .storage()
              .refFromURL('gs://mahindracsc-e5468.appspot.com')
              .child(filePath)
              .getDownloadURL();

          setState(() {
            pressLoading = true;
            pressUrl = uri.toString();
          });
        }
        break;
      case 'thinner':
        {
          await _thinnerUploadTask.future;
          Uri uri = await fb
              .storage()
              .refFromURL('gs://mahindracsc-e5468.appspot.com')
              .child(filePath)
              .getDownloadURL();

          setState(() {
            thinnerLoading = true;
            thinnerUrl = uri.toString();
          });
        }
        break;
      case 'toxic':
        {
          await _toxicUploadTask.future;
          Uri uri = await fb
              .storage()
              .refFromURL('gs://mahindracsc-e5468.appspot.com')
              .child(filePath)
              .getDownloadURL();

          setState(() {
            toxicLoading = true;
            toxicUrl = uri.toString();
          });
        }
        break;
      case 'heat':
        {
          await _heatUploadTask.future;
          Uri uri = await fb
              .storage()
              .refFromURL('gs://mahindracsc-e5468.appspot.com')
              .child(filePath)
              .getDownloadURL();

          setState(() {
            heatLoading = true;
            heatUrl = uri.toString();
          });
        }
        break;
      case 'boiler':
        {
          await _boilerUploadTask.future;
          Uri uri = await fb
              .storage()
              .refFromURL('gs://mahindracsc-e5468.appspot.com')
              .child(filePath)
              .getDownloadURL();

          setState(() {
            boilerLoading = true;
            boilerUrl = uri.toString();
          });
        }
        break;
    }
  }

  Utilities utilities = Utilities();
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final assessmentProvider = Provider.of<SiteAssessmentProvider>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: utilities.mainColor,
            titleSpacing: 0.0,
            actions: [
              FlatButton(
                  onPressed: () async {
                    if (_siteName.text != '' &&
                        _occupierEmail.text != '' &&
                        _occupierName.text != '' &&
                        _headEmail.text != '' &&
                        _headName.text != '' &&
                        _safetyInchargeEmail.text != '' &&
                        _safetyInchargeName.text != '' &&
                        _fireInchargeName.text != '' &&
                        _fireInchargeEmail.text != '' &&
                        _officeSafetyInchargeEmail.text != '' &&
                        _officeSafetyInchargeName.text != '' &&
                        _utilitiesEmail.text != '' &&
                        _utilitiesName.text != '' &&
                        _fatal.text != '' &&
                        _reportable.text != '' &&
                        _nonReportable.text != '' &&
                        _firstAid.text != '' &&
                        _fire.text != '') {
                      await assessmentProvider.setLocationData(
                          documentId,
                          _siteName.text,
                          _occupierName.text,
                          _occupierEmail.text,
                          _headName.text,
                          _headEmail.text,
                          _safetyInchargeName.text,
                          _safetyInchargeEmail.text,
                          _fireInchargeName.text,
                          _fireInchargeEmail.text,
                          _officeSafetyInchargeName.text,
                          _officeSafetyInchargeEmail.text,
                          _utilitiesName.text,
                          _utilitiesEmail.text,
                          _rule.text,
                          _lpg.text,
                          _gasoline.text,
                          _cng.text,
                          _paintShop.text,
                          _foundry.text,
                          _press.text,
                          _desiel.text,
                          _thinner.text,
                          _toxic.text,
                          _heat.text,
                          _testBed.text,
                          _ibr.text,
                          _fatal.text,
                          _reportable.text,
                          _nonReportable.text,
                          _firstAid.text,
                          _fire.text,
                          foundryUrl,
                          pressUrl,
                          thinnerUrl,
                          toxicUrl,
                          heatUrl,
                          boilerUrl,
                          _ruleValue,
                          _lpgValue,
                          _gasolineValue,
                          _cngValue,
                          _paintShopValue,
                          _foundryValue,
                          _pressValue,
                          _desielValue,
                          _thinnerValue,
                          _toxicValue,
                          _heatValue,
                          _testBedValue,
                          _ibrValue);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return ChangeNotifierProvider.value(
                            value: assessmentProvider,
                            child: BeforeSubmit(),
                          );
                        },
                      ));
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Text('Form Incomplete'),
                              content: new Text(
                                  'Please fill all fields in the form.'),
                              actions: <Widget>[
                                new FlatButton(
                                  child: new Text('Close'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          });
                    }
                  },
                  child: Text('Next',
                      style: TextStyle(color: Colors.white, fontSize: 20)))
            ],
          ),
          body: Center(
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: DraggableScrollbar.rrect(
                    alwaysVisibleScrollThumb: true,
                    backgroundColor: utilities.mainColor,
                    controller: _controller,
                    child: ListView.builder(
                        controller: _controller,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Column(
                            children: <Widget>[
                              Text(
                                'Fill in the required feilds',
                                style:
                                    TextStyle(fontSize: 22, color: Colors.red),
                                textAlign: TextAlign.left,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          ' Site Name',
                                          style: TextStyle(fontSize: 22),
                                          textAlign: TextAlign.left,
                                        ),
                                        TextField(
                                          controller: _siteName,
                                          decoration: InputDecoration(
                                            labelText: 'Name',
                                            border: OutlineInputBorder(
                                              borderRadius: new BorderRadius
                                                      .all(
                                                  new Radius.circular(20.0)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          ' Occupier',
                                          style: TextStyle(fontSize: 22),
                                          textAlign: TextAlign.left,
                                        ),
                                        TextField(
                                          controller: _occupierName,
                                          decoration: InputDecoration(
                                            labelText: 'Name',
                                            border: OutlineInputBorder(
                                              borderRadius: new BorderRadius
                                                      .all(
                                                  new Radius.circular(20.0)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          ' Email (Occupier)',
                                          style: TextStyle(fontSize: 22),
                                          textAlign: TextAlign.left,
                                        ),
                                        TextField(
                                          controller: _occupierEmail,
                                          decoration: InputDecoration(
                                            labelText: 'Email',
                                            border: OutlineInputBorder(
                                              borderRadius: new BorderRadius
                                                      .all(
                                                  new Radius.circular(20.0)),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          ' Site Head',
                                          style: TextStyle(fontSize: 22),
                                          textAlign: TextAlign.left,
                                        ),
                                        TextField(
                                          controller: _headName,
                                          decoration: InputDecoration(
                                            labelText: 'Name',
                                            border: OutlineInputBorder(
                                              borderRadius: new BorderRadius
                                                      .all(
                                                  new Radius.circular(20.0)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          'Email  (Site Head)',
                                          style: TextStyle(fontSize: 22),
                                          textAlign: TextAlign.left,
                                        ),
                                        TextField(
                                          controller: _headEmail,
                                          decoration: InputDecoration(
                                            labelText: 'Email',
                                            border: OutlineInputBorder(
                                              borderRadius: new BorderRadius
                                                      .all(
                                                  new Radius.circular(20.0)),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Safety Incharge',
                                          style: TextStyle(fontSize: 22),
                                          textAlign: TextAlign.left,
                                        ),
                                        TextField(
                                          controller: _safetyInchargeName,
                                          decoration: InputDecoration(
                                            labelText: 'Name',
                                            border: OutlineInputBorder(
                                              borderRadius: new BorderRadius
                                                      .all(
                                                  new Radius.circular(20.0)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          'Email (Safety Incharge)',
                                          style: TextStyle(fontSize: 22),
                                          textAlign: TextAlign.left,
                                        ),
                                        TextField(
                                          controller: _safetyInchargeEmail,
                                          decoration: InputDecoration(
                                            labelText: 'Email',
                                            border: OutlineInputBorder(
                                              borderRadius: new BorderRadius
                                                      .all(
                                                  new Radius.circular(20.0)),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Fire Incharge',
                                          style: TextStyle(fontSize: 22),
                                          textAlign: TextAlign.left,
                                        ),
                                        TextField(
                                          controller: _fireInchargeName,
                                          decoration: InputDecoration(
                                            labelText: 'Name',
                                            border: OutlineInputBorder(
                                              borderRadius: new BorderRadius
                                                      .all(
                                                  new Radius.circular(20.0)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          'Email (Fire Incharge)',
                                          style: TextStyle(fontSize: 22),
                                          textAlign: TextAlign.left,
                                        ),
                                        TextField(
                                          controller: _fireInchargeEmail,
                                          decoration: InputDecoration(
                                            labelText: 'Email',
                                            border: OutlineInputBorder(
                                              borderRadius: new BorderRadius
                                                      .all(
                                                  new Radius.circular(20.0)),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Office Safety Inchage',
                                          style: TextStyle(fontSize: 22),
                                          textAlign: TextAlign.left,
                                        ),
                                        TextField(
                                          controller: _officeSafetyInchargeName,
                                          decoration: InputDecoration(
                                            labelText: 'Name',
                                            border: OutlineInputBorder(
                                              borderRadius: new BorderRadius
                                                      .all(
                                                  new Radius.circular(20.0)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          'Email (Office Safety Incharge)',
                                          style: TextStyle(fontSize: 22),
                                          textAlign: TextAlign.left,
                                        ),
                                        TextField(
                                          controller:
                                              _officeSafetyInchargeEmail,
                                          decoration: InputDecoration(
                                            labelText: 'Email',
                                            border: OutlineInputBorder(
                                              borderRadius: new BorderRadius
                                                      .all(
                                                  new Radius.circular(20.0)),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Utilities Incharge',
                                          style: TextStyle(fontSize: 22),
                                          textAlign: TextAlign.left,
                                        ),
                                        TextField(
                                          controller: _utilitiesName,
                                          decoration: InputDecoration(
                                            labelText: 'Name',
                                            border: OutlineInputBorder(
                                              borderRadius: new BorderRadius
                                                      .all(
                                                  new Radius.circular(20.0)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          'Email (Utitlities Incharge)',
                                          style: TextStyle(fontSize: 22),
                                          textAlign: TextAlign.left,
                                        ),
                                        TextField(
                                          controller: _utilitiesEmail,
                                          decoration: InputDecoration(
                                            labelText: 'Email',
                                            border: OutlineInputBorder(
                                              borderRadius: new BorderRadius
                                                      .all(
                                                  new Radius.circular(20.0)),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Is your site covered under " The Manufacture, Storage, and Import of Hazardous Chemical Rules 1989"',
                                          style: TextStyle(fontSize: 22),
                                          textAlign: TextAlign.left,
                                        ),
                                        RadioListTile(
                                            title: Text('Yes'),
                                            value: true,
                                            groupValue: _ruleValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _ruleValue = value;
                                              });
                                            }),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                        ),
                                        RadioListTile(
                                            title: Text('No'),
                                            value: false,
                                            groupValue: _ruleValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _ruleValue = value;
                                              });
                                            }),
                                        (_ruleValue)
                                            ? TextField(
                                                controller: _rule,
                                                decoration: InputDecoration(
                                                    labelText:
                                                        'Mention the Reason for Applicability'),
                                              )
                                            : SizedBox()
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          'Does your site has LPG / Propane',
                                          style: TextStyle(fontSize: 22),
                                          textAlign: TextAlign.left,
                                        ),
                                        RadioListTile(
                                            title: Text('Yes'),
                                            value: true,
                                            groupValue: _lpgValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _lpgValue = value;
                                              });
                                            }),
                                        RadioListTile(
                                            title: Text('No'),
                                            value: false,
                                            groupValue: _lpgValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _lpgValue = value;
                                              });
                                            }),
                                        (_lpgValue)
                                            ? TextField(
                                                controller: _lpg,
                                                decoration: InputDecoration(
                                                    labelText:
                                                        'Quantity in Tonnes'),
                                              )
                                            : SizedBox()
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Is your site has Gasoline',
                                          style: TextStyle(fontSize: 22),
                                          textAlign: TextAlign.left,
                                        ),
                                        RadioListTile(
                                            title: Text('Yes'),
                                            value: true,
                                            groupValue: _gasolineValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _gasolineValue = value;
                                              });
                                            }),
                                        RadioListTile(
                                            title: Text('No'),
                                            value: false,
                                            groupValue: _gasolineValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _gasolineValue = value;
                                              });
                                            }),
                                        (_gasolineValue)
                                            ? TextField(
                                                controller: _gasoline,
                                                decoration: InputDecoration(
                                                    labelText:
                                                        'Quantity in kl'),
                                              )
                                            : SizedBox()
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          'Is your site has CNG / PNG',
                                          style: TextStyle(fontSize: 22),
                                          textAlign: TextAlign.left,
                                        ),
                                        RadioListTile(
                                            title: Text('Yes'),
                                            value: true,
                                            groupValue: _cngValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _cngValue = value;
                                              });
                                            }),
                                        RadioListTile(
                                            title: Text('No'),
                                            value: false,
                                            groupValue: _cngValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _cngValue = value;
                                              });
                                            }),
                                        (_cngValue)
                                            ? TextField(
                                                controller: _cng,
                                                decoration: InputDecoration(
                                                    labelText:
                                                        'Quantity in KG'),
                                              )
                                            : SizedBox()
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Is your site has Paint shop',
                                          style: TextStyle(fontSize: 22),
                                          textAlign: TextAlign.left,
                                        ),
                                        RadioListTile(
                                            title: Text('Yes'),
                                            value: true,
                                            groupValue: _paintShopValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _paintShopValue = value;
                                              });
                                            }),
                                        RadioListTile(
                                            title: Text('No'),
                                            value: false,
                                            groupValue: _paintShopValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _paintShopValue = value;
                                              });
                                            }),
                                        (_paintShopValue)
                                            ? TextField(
                                                controller: _paintShop,
                                                decoration: InputDecoration(
                                                    labelText: 'Capacity'),
                                              )
                                            : SizedBox()
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          'Is your site has Steel Melting / Foundry',
                                          style: TextStyle(fontSize: 22),
                                          textAlign: TextAlign.left,
                                        ),
                                        RadioListTile(
                                            title: Text('Yes'),
                                            value: true,
                                            groupValue: _foundryValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _foundryValue = value;
                                              });
                                            }),
                                        RadioListTile(
                                            title: Text('No'),
                                            value: false,
                                            groupValue: _foundryValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _foundryValue = value;
                                              });
                                            }),
                                        (_foundryValue)
                                            ? TextField(
                                                controller: _foundry,
                                                decoration: InputDecoration(
                                                    labelText: 'Capacity'),
                                              )
                                            : SizedBox(),
                                        (_foundryValue)
                                            ? RaisedButton(
                                                child: foundryLoading
                                                    ? Text('File Uploaded')
                                                    : Text(
                                                        'Upload Supporting Documents'),
                                                onPressed: () async {
                                                 // uploadFile('foundry');
                                                })
                                            : SizedBox(),
                                        // StreamBuilder<fb.UploadTaskSnapshot>(
                                        //   stream: _foundryUploadTask
                                        //       ?.onStateChanged,
                                        //   builder: (context, snapshot) {
                                        //     final event = snapshot?.data;

                                        //     // Default as 0
                                        //     double progressPercent =
                                        //         event != null
                                        //             ? event.bytesTransferred /
                                        //                 event.totalBytes *
                                        //                 100
                                        //             : 0;

                                        //     if (progressPercent == 100) {
                                        //       return Text(
                                        //           'Successfully uploaded file');
                                        //     } else if (progressPercent == 0) {
                                        //       return SizedBox();
                                        //     } else {
                                        //       return CircularProgressIndicator();
                                        //     }
                                        //   },
                                        // ),
                                        GestureDetector(
                                          child: (foundryUrl != null)
                                              ? Text(foundryUrl,
                                                  style: TextStyle(
                                                      color: Colors.blue[700],
                                                      decoration: TextDecoration
                                                          .underline))
                                              : SizedBox(),
                                          onTap: () async {
                                            String url = foundryUrl;
                                            if (await canLaunch(url))
                                              await launch(url);
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Is your site has Press machine',
                                          style: TextStyle(fontSize: 22),
                                          textAlign: TextAlign.left,
                                        ),
                                        RadioListTile(
                                            title: Text('Yes'),
                                            value: true,
                                            groupValue: _pressValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _pressValue = value;
                                              });
                                            }),
                                        RadioListTile(
                                            title: Text('No'),
                                            value: false,
                                            groupValue: _pressValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _pressValue = value;
                                              });
                                            }),
                                        (_pressValue)
                                            ? TextField(
                                                controller: _press,
                                                decoration: InputDecoration(
                                                    labelText:
                                                        'Please upload Details of Press Machine'),
                                              )
                                            : SizedBox(),
                                        (_pressValue)
                                            ? RaisedButton(
                                                child: pressLoading
                                                    ? Text('File Uploaded')
                                                    : Text(
                                                        'Upload Supporting Documents'),
                                                onPressed: () async {
                                                  //uploadFile('press');
                                                })
                                            : SizedBox(),
                                        // StreamBuilder<fb.UploadTaskSnapshot>(
                                        //   stream:
                                        //       _pressUploadTask?.onStateChanged,
                                        //   builder: (context, snapshot) {
                                        //     final event = snapshot?.data;

                                        //     // Default as 0
                                        //     double progressPercent =
                                        //         event != null
                                        //             ? event.bytesTransferred /
                                        //                 event.totalBytes *
                                        //                 100
                                        //             : 0;

                                        //     if (progressPercent == 100) {
                                        //       return Text(
                                        //           'Successfully uploaded file');
                                        //     } else if (progressPercent == 0) {
                                        //       return SizedBox();
                                        //     } else {
                                        //       return CircularProgressIndicator();
                                        //     }
                                        //   },
                                        // ),
                                        GestureDetector(
                                          child: (pressUrl != null)
                                              ? Text(pressUrl,
                                                  style: TextStyle(
                                                      color: Colors.blue[700],
                                                      decoration: TextDecoration
                                                          .underline))
                                              : SizedBox(),
                                          onTap: () async {
                                            String url = pressUrl;
                                            if (await canLaunch(url))
                                              await launch(url);
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          'Is your site has diesel storage',
                                          style: TextStyle(fontSize: 22),
                                          textAlign: TextAlign.left,
                                        ),
                                        RadioListTile(
                                            title: Text('Yes'),
                                            value: true,
                                            groupValue: _desielValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _desielValue = value;
                                              });
                                            }),
                                        RadioListTile(
                                            title: Text('No'),
                                            value: false,
                                            groupValue: _desielValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _desielValue = value;
                                              });
                                            }),
                                        (_desielValue)
                                            ? TextField(
                                                controller: _desiel,
                                                decoration: InputDecoration(
                                                    labelText:
                                                        'Quantity in kl'),
                                              )
                                            : SizedBox()
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Is your site has Thinner / other Class A Storage',
                                          style: TextStyle(fontSize: 22),
                                          textAlign: TextAlign.left,
                                        ),
                                        RadioListTile(
                                            title: Text('Yes'),
                                            value: true,
                                            groupValue: _thinnerValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _thinnerValue = value;
                                              });
                                            }),
                                        RadioListTile(
                                            title: Text('No'),
                                            value: false,
                                            groupValue: _thinnerValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _thinnerValue = value;
                                              });
                                            }),
                                        (_thinnerValue)
                                            ? TextField(
                                                controller: _thinner,
                                                decoration: InputDecoration(
                                                    labelText:
                                                        'Quantity in kl'),
                                              )
                                            : SizedBox(),
                                        (_thinnerValue)
                                            ? RaisedButton(
                                                child: thinnerLoading
                                                    ? Text('File Uploaded')
                                                    : Text(
                                                        'Upload Supporting Documents'),
                                                onPressed: () async {
                                                  //uploadFile('thinner');
                                                })
                                            : SizedBox(),
                                        // StreamBuilder<fb.UploadTaskSnapshot>(
                                        //   stream: _thinnerUploadTask
                                        //       ?.onStateChanged,
                                        //   builder: (context, snapshot) {
                                        //     final event = snapshot?.data;

                                        //     // Default as 0
                                        //     double progressPercent =
                                        //         event != null
                                        //             ? event.bytesTransferred /
                                        //                 event.totalBytes *
                                        //                 100
                                        //             : 0;

                                        //     if (progressPercent == 100) {
                                        //       return Text(
                                        //           'Successfully uploaded file');
                                        //     } else if (progressPercent == 0) {
                                        //       return SizedBox();
                                        //     } else {
                                        //       return CircularProgressIndicator();
                                        //     }
                                        //   },
                                        // ),
                                        GestureDetector(
                                          child: (thinnerUrl != null)
                                              ? Text(thinnerUrl,
                                                  style: TextStyle(
                                                      color: Colors.blue[700],
                                                      decoration: TextDecoration
                                                          .underline))
                                              : SizedBox(),
                                          onTap: () async {
                                            String url = thinnerUrl;
                                            if (await canLaunch(url))
                                              await launch(url);
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          'Is your site has Toxic Chemicals',
                                          style: TextStyle(fontSize: 22),
                                          textAlign: TextAlign.left,
                                        ),
                                        RadioListTile(
                                            title: Text('Yes'),
                                            value: true,
                                            groupValue: _toxicValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _toxicValue = value;
                                              });
                                            }),
                                        RadioListTile(
                                            title: Text('No'),
                                            value: false,
                                            groupValue: _toxicValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _toxicValue = value;
                                              });
                                            }),
                                        (_toxicValue)
                                            ? TextField(
                                                controller: _toxic,
                                                decoration: InputDecoration(
                                                    labelText:
                                                        'Quantity and Name'),
                                              )
                                            : SizedBox(),
                                        (_toxicValue)
                                            ? RaisedButton(
                                                child: toxicLoading
                                                    ? Text('File Uploaded')
                                                    : Text(
                                                        'Upload Supporting Documents'),
                                                onPressed: () async {
                                                  //uploadFile('toxic');
                                                })
                                            : SizedBox(),
                                        // StreamBuilder<fb.UploadTaskSnapshot>(
                                        //   stream:
                                        //       _toxicUploadTask?.onStateChanged,
                                        //   builder: (context, snapshot) {
                                        //     final event = snapshot?.data;

                                        //     // Default as 0
                                        //     double progressPercent =
                                        //         event != null
                                        //             ? event.bytesTransferred /
                                        //                 event.totalBytes *
                                        //                 100
                                        //             : 0;

                                        //     if (progressPercent == 100) {
                                        //       return Text(
                                        //           'Successfully uploaded file');
                                        //     } else if (progressPercent == 0) {
                                        //       return SizedBox();
                                        //     } else {
                                        //       return CircularProgressIndicator();
                                        //     }
                                        //   },
                                        // ),
                                        GestureDetector(
                                          child: (toxicUrl != null)
                                              ? Text(toxicUrl,
                                                  style: TextStyle(
                                                      color: Colors.blue[700],
                                                      decoration: TextDecoration
                                                          .underline))
                                              : SizedBox(),
                                          onTap: () async {
                                            String url = toxicUrl;
                                            if (await canLaunch(url))
                                              await launch(url);
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Is your site has Heat treatment',
                                          style: TextStyle(fontSize: 22),
                                          textAlign: TextAlign.left,
                                        ),
                                        RadioListTile(
                                            title: Text('Yes'),
                                            value: true,
                                            groupValue: _heatValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _heatValue = value;
                                              });
                                            }),
                                        RadioListTile(
                                            title: Text('No'),
                                            value: false,
                                            groupValue: _heatValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _heatValue = value;
                                              });
                                            }),
                                        (_heatValue)
                                            ? TextField(
                                                controller: _heat,
                                                decoration: InputDecoration(
                                                    labelText: 'Capacity'),
                                              )
                                            : SizedBox(),
                                        (_heatValue)
                                            ? RaisedButton(
                                                child: heatLoading
                                                    ? Text('File Uploaded')
                                                    : Text(
                                                        'Upload Supporting Documents'),
                                                onPressed: () async {
                                                 // uploadFile('heat');
                                                })
                                            : SizedBox(),
                                        // StreamBuilder<fb.UploadTaskSnapshot>(
                                        //   stream:
                                        //       _heatUploadTask?.onStateChanged,
                                        //   builder: (context, snapshot) {
                                        //     final event = snapshot?.data;

                                        //     // Default as 0
                                        //     double progressPercent =
                                        //         event != null
                                        //             ? event.bytesTransferred /
                                        //                 event.totalBytes *
                                        //                 100
                                        //             : 0;

                                        //     if (progressPercent == 100) {
                                        //       return Text(
                                        //           'Successfully uploaded file');
                                        //     } else if (progressPercent == 0) {
                                        //       return SizedBox();
                                        //     } else {
                                        //       return CircularProgressIndicator();
                                        //     }
                                        //   },
                                        // ),
                                        GestureDetector(
                                          child: (heatUrl != null)
                                              ? Text(heatUrl,
                                                  style: TextStyle(
                                                      color: Colors.blue[700],
                                                      decoration: TextDecoration
                                                          .underline))
                                              : SizedBox(),
                                          onTap: () async {
                                            String url = heatUrl;
                                            if (await canLaunch(url))
                                              await launch(url);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          'Is your site has Engine Test Bed',
                                          style: TextStyle(fontSize: 22),
                                          textAlign: TextAlign.left,
                                        ),
                                        RadioListTile(
                                            title: Text('Yes'),
                                            value: true,
                                            groupValue: _testBedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _testBedValue = value;
                                              });
                                            }),
                                        RadioListTile(
                                            title: Text('No'),
                                            value: false,
                                            groupValue: _testBedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _testBedValue = value;
                                              });
                                            }),
                                        (_testBedValue)
                                            ? TextField(
                                                controller: _testBed,
                                                decoration: InputDecoration(
                                                    labelText: 'Nos'),
                                              )
                                            : SizedBox()
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Is your site has Boiler - is it covered under IBR ( Indian Boiler Regulation)',
                                          style: TextStyle(fontSize: 22),
                                          textAlign: TextAlign.left,
                                        ),
                                        RadioListTile(
                                            title: Text('Yes'),
                                            value: true,
                                            groupValue: _ibrValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _ibrValue = value;
                                              });
                                            }),
                                        RadioListTile(
                                            title: Text('No'),
                                            value: false,
                                            groupValue: _ibrValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _ibrValue = value;
                                              });
                                            }),
                                        (_ibrValue)
                                            ? TextField(
                                                controller: _ibr,
                                                decoration: InputDecoration(
                                                    labelText:
                                                        'Number and their Capacity'),
                                              )
                                            : SizedBox(),
                                        (_ibrValue)
                                            ? RaisedButton(
                                                child: boilerLoading
                                                    ? Text('File Uploaded')
                                                    : Text(
                                                        'Upload Supporting Documents'),
                                                onPressed: () async {
                                                 // uploadFile('boiler');
                                                })
                                            : SizedBox(),
                                        // StreamBuilder<fb.UploadTaskSnapshot>(
                                        //   stream:
                                        //       _boilerUploadTask?.onStateChanged,
                                        //   builder: (context, snapshot) {
                                        //     final event = snapshot?.data;

                                        //     // Default as 0
                                        //     double progressPercent =
                                        //         event != null
                                        //             ? event.bytesTransferred /
                                        //                 event.totalBytes *
                                        //                 100
                                        //             : 0;

                                        //     if (progressPercent == 100) {
                                        //       return Text(
                                        //           'Successfully uploaded file');
                                        //     } else if (progressPercent == 0) {
                                        //       return SizedBox();
                                        //     } else {
                                        //       return CircularProgressIndicator();
                                        //     }
                                        //   },
                                        // ),
                                        GestureDetector(
                                          child: (boilerUrl != null)
                                              ? Text(boilerUrl,
                                                  style: TextStyle(
                                                      color: Colors.blue[700],
                                                      decoration: TextDecoration
                                                          .underline))
                                              : SizedBox(),
                                          onTap: () async {
                                            String url = boilerUrl;
                                            if (await canLaunch(url))
                                              await launch(url);
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                  'Incident Statistics for April 2019- March 2020',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                              TextField(
                                controller: _fatal,
                                decoration:
                                    InputDecoration(labelText: 'Fatal(Nos)'),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              TextField(
                                controller: _reportable,
                                decoration: InputDecoration(
                                    labelText: 'Reportable(Nos)'),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              TextField(
                                controller: _nonReportable,
                                decoration: InputDecoration(
                                    labelText: 'Non-Reportable(Nos)'),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              TextField(
                                controller: _firstAid,
                                decoration: InputDecoration(
                                    labelText: 'First Aid Cases(Nos)'),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              TextField(
                                controller: _fire,
                                decoration: InputDecoration(
                                    labelText: 'Fire Incidents(Major)'),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                              SizedBox(
                                width: 15,
                              ),
                            ],
                          );
                        }))),
          ),
        ),
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
