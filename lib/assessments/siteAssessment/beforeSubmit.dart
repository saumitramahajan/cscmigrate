import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:mahindraCSC/assessments/siteAssessment/FireAssessment.dart';
import 'package:mahindraCSC/assessments/siteAssessment/siteAssessmentProvider.dart';
import 'package:mahindraCSC/assessments/siteAssessment/siteAssessmentSingle.dart';
import 'package:mahindraCSC/utilities.dart';
import 'package:provider/provider.dart';

class BeforeSubmit extends StatefulWidget {
  @override
  _BeforeSubmitState createState() => _BeforeSubmitState();
}

class _BeforeSubmitState extends State<BeforeSubmit> {
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
                child: assessmentProvider.buttonLoading
                    ? CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text('Save',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                onPressed: () async {
                  assessmentProvider.assessmentType == 'self'
                      ? await assessmentProvider.uploadSelfAssessment('save')
                      : await assessmentProvider.uploadSiteAssessment('save');
                },
              ),
              SizedBox(
                width: 20,
              ),
              FlatButton(
                  child: assessmentProvider.saveLoading
                      ? CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text('Next',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                  onPressed: () async {
                    bool flag = assessmentProvider.filledData();

                    if (flag == true) {
                      if (assessmentProvider.assessmentType == 'site') {
                        await assessmentProvider.uploadSiteAssessment('submit');
                      } else {
                        assessmentProvider.uploadSelfAssessment('submit');
                      }
                      assessmentProvider.getFireQuestions();

                      await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return ChangeNotifierProvider.value(
                            value: assessmentProvider,
                            child: FireAssessment(
                              preFilledData: assessmentProvider.fireanswers,
                            ),
                          );
                        },
                      ));

                      Navigator.of(context).pop();
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: new Text(
                                  'Please complete all the parameters'),
                              actions: <Widget>[
                                new FlatButton(
                                  child: new Text('close'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          });
                    }
                  })
            ],
          ),
          body: assessmentProvider.loadingSaveData
              ? CircularProgressIndicator()
              : Container(
                  child: Column(
                  children: [
                    SizedBox(height: 25),
                    (assessmentProvider.assessmentType != 'site')
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 60),
                              Text('Assessment',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 25.0)),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 60),
                              Text(
                                  'Assessment Total: ' +
                                      assessmentProvider.assessmentTotal
                                          .toString() +
                                      '/800',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 25.0)),
                            ],
                          ),
                    SizedBox(height: 10),
                    Expanded(
                      child: DraggableScrollbar.rrect(
                        alwaysVisibleScrollThumb: true,
                        backgroundColor: utilities.mainColor,
                        controller: _controller,
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                          ),
                          controller: _controller,
                          padding: EdgeInsets.zero,
                          itemCount: 33,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                assessmentProvider.beforeSubmitTapped(
                                    index + 1, 'assessment');
                                print('From BeforeSubmit:: ' +
                                    index.toString() +
                                    '\n\n');
                                await Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (_) {
                                  return ChangeNotifierProvider.value(
                                    value: assessmentProvider,
                                    child: SiteAssessmentSingleForm(
                                      marks: assessmentProvider
                                          .assessmentAnswers[index]['answer'],
                                      comment: assessmentProvider
                                          .assessmentAnswers[index]['comment'],
                                      level: assessmentProvider
                                          .assessmentAnswers[index]['level'],
                                      fileUrl: assessmentProvider
                                          .assessmentAnswers[index]['fileUrl'],
                                      suggestion: assessmentProvider
                                              .assessmentAnswers[index]
                                          ['suggestion'],
                                    ),
                                  );
                                }));
                                setState(() {});
                              },
                              child: Card(
                                  elevation: 7.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: assessmentProvider
                                                        .assessmentAnswers[
                                                    index]['filled'] ==
                                                false
                                            ? BoxDecoration(
                                                color: utilities.mainColor)
                                            : BoxDecoration(
                                                color: Colors.green,
                                              ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.13,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      assessmentProvider
                                                              .questionList[
                                                          index]['statement'],
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 40),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.2,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: Image.asset(
                                              'assets/icon${index + 1}.png',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                )),
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
/*Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      title: (assessmentProvider.assessmentType != 'site')
                          ? Text('Assessment')
                          : Text('Assessment Total: ' +
                              assessmentProvider.assessmentTotal.toString() +
                              '/800'),
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.white,
                      textTheme: TextTheme(
                          headline6:
                              TextStyle(color: Colors.black, fontSize: 25.0)),
                    ),
                    SliverToBoxAdapter(
                      child: Scrollbar(
                        controller: _controller,
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                          ),
                          controller: _controller,
                          itemCount: 33,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                assessmentProvider.beforeSubmitTapped(
                                    index + 1, 'assessment');
                                print('From BeforeSubmit:: ' +
                                    index.toString() +
                                    '\n\n');
                                await Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (_) {
                                  return ChangeNotifierProvider.value(
                                    value: assessmentProvider,
                                    child: SiteAssessmentSingleForm(
                                      marks: assessmentProvider
                                          .assessmentAnswers[index]['answer'],
                                      comment: assessmentProvider
                                          .assessmentAnswers[index]['comment'],
                                      level: assessmentProvider
                                          .assessmentAnswers[index]['level'],
                                      fileUrl: assessmentProvider
                                          .assessmentAnswers[index]['fileUrl'],
                                      ),
                                    );
                                  }));
                                  setState(() {});
                                },
                                child: Card(
                                    child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(assessmentProvider.questionList[index]
                                        ['statement']),
                                    Text("Level: " +
                                        assessmentProvider
                                            .assessmentAnswers[index]['level']
                                            .toString()),
                                    (assessmentProvider.assessmentType == 'site')
                                        ? Text('Score: ' +
                                            assessmentProvider
                                                .assessmentAnswers[index]
                                                    ['answer']
                                                .toString())
                                        : SizedBox()
                                  ],
                                )),
                              );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),*/
