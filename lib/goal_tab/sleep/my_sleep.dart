import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/models/Sleep.dart';
import 'package:my_app/models/exrxTEST.dart';
import 'package:my_app/goal_tab/exercises/my_exercises.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/ui_view/weight/BMI_chart.dart';
import 'package:my_app/ui_view/Sleep_StackedBarChart.dart';
import 'package:my_app/ui_view/VerticalBC_Target.dart';
import 'package:my_app/ui_view/VerticalBarChart.dart';
import 'package:my_app/ui_view/area_list_view.dart';
import 'package:my_app/ui_view/body_measurement.dart';
import 'package:my_app/ui_view/calorie_intake.dart';
import 'package:my_app/ui_view/cholesterol_chart.dart';
import 'package:my_app/ui_view/diet_view.dart';
import 'package:my_app/ui_view/fitbit_connect.dart';
import 'package:my_app/ui_view/water/glass_view.dart';
import 'package:my_app/ui_view/glucose_levels_chart.dart';
import 'package:my_app/ui_view/heartrate.dart';
import 'package:my_app/ui_view/exercises/running_view.dart';
import 'package:my_app/ui_view/sleep_quality.dart';
import 'package:my_app/ui_view/sleep_score_bar_chart.dart';
import 'package:my_app/ui_view/sleep_stackedbar_sfchart.dart';
import 'package:my_app/ui_view/sleep_score_barchartsf.dart';
import 'package:my_app/ui_view/time_asleep.dart';
import 'package:my_app/ui_view/title_view.dart';
import 'package:my_app/ui_view/weight/weight_progress.dart';
import 'package:my_app/ui_view/workout_view.dart';
import 'package:my_app/ui_view/bp_chart.dart';
import 'package:flutter/material.dart';

import '../../fitness_app_theme.dart';
import '../../main.dart';
import '../../notifications/notifications._patients.dart';
import '../../ui_view/meals/meals_list_view.dart';
import '../../ui_view/water/water_view.dart';
import 'package:http/http.dart' as http;

class my_sleep extends StatefulWidget {
  const my_sleep({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;
  @override
  _my_sleepState createState() => _my_sleepState();
}

class _my_sleepState extends State<my_sleep>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  String fitbitToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyMzg0VzQiLCJzdWIiOiI4VFFGUEQiLCJpc3MiOiJGaXRiaXQiLCJ0eXAiOiJhY2Nlc3NfdG9rZW4iLCJzY29wZXMiOiJyc29jIHJzZXQgcmFjdCBybG9jIHJ3ZWkgcmhyIHJwcm8gcm51dCByc2xlIiwiZXhwIjoxNjQyNzg0MzgxLCJpYXQiOjE2NDI3NTU1ODF9.d3JfpNowesILgLa306QAyOJbAcPbbVZ9Aj9U-pPdCWs";


  List<Widget> listViews = <Widget>[];
  // List<Sleep> sleeptmp = [];
  Sleep latestSleep = new Sleep();
  DateTime now = DateTime.now();
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    final readFitbit = databaseReference.child('fitbitToken/');
    readFitbit.once().then((DataSnapshot snapshot) {
      print("FITBIT TOKEN");
      print(snapshot.value);
      if(snapshot.value != null || snapshot.value != ""){
        fitbitToken = snapshot.value.toString();
      }
      getLatestSleep();
    });
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    Future.delayed(const Duration(milliseconds: 1200), (){

    });

    super.initState();
  }

  void addAllListData() {
    const int count = 9;
    listViews.add(
      fitbit_connect(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    listViews.add(
      TitleView(
          titleTxt: 'Last Sleep',
          subTxt: 'Sleep Log',
          redirect: 6,
          userType: "Patient",
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: widget.animationController,
              curve:
              Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: widget.animationController,
          fitbitToken: fitbitToken
      ),
    );

    listViews.add(
      time_asleep(
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: widget.animationController,
              curve:
              Interval((1 / count) * 5, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: widget.animationController,
          fitbitToken: fitbitToken
      ),
    );
    listViews.add(
      stacked_sleep_chart(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
        fitbittoken: fitbitToken
      ),
    );
    // listViews.add(
    //   Sleep_StackedBarChart(
    //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController,
    //         curve:
    //         Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
    //     animationController: widget.animationController,
    //     fitbitToken: fitbitToken
    //   ),
    // );

    listViews.add(
      TitleView(
        titleTxt: 'Sleep Quality',
        subTxt: 'Sleep Score?',
        redirect: 9,
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    // listViews.add(
    //   SleepScoreVerticalBarLabelChart(
    //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController,
    //         curve:
    //         Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
    //     animationController: widget.animationController,
    //   ),
    // );

    listViews.add(
      sleep_barchart_sf(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
        fitbitToken: fitbitToken
      ),
    );
    //







  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            // getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              // top: AppBar().preferredSize.height +
              //     MediaQuery.of(context).padding.top +
              //     24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController?.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: FitnessAppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: FitnessAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'My Meals',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: FitnessAppTheme.darkerText,
                                  ),
                                ),
                              ),

                            ),
                            Container(
                              margin: EdgeInsets.only( top: 0, right: 16,),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => notifications()),
                                  );
                                },
                                child: Stack(
                                  children: <Widget>[
                                    Icon(Icons.notifications,),
                                    Positioned(
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(1),
                                        decoration: BoxDecoration( color: Colors.red, borderRadius: BorderRadius.circular(6),),
                                        constraints: BoxConstraints( minWidth: 12, minHeight: 12, ),
                                        child: Text( '5', style: TextStyle(color: Colors.white, fontSize: 8,), textAlign: TextAlign.center,),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
  void getLatestSleep() async {
    var response = await http.get(Uri.parse("https://api.fitbit.com/1.2/user/-/sleep/list.json?beforeDate=2022-03-27&sort=desc&offset=0&limit=1"),
        headers: {
          'Authorization': "Bearer " + fitbitToken
        });
    List<Sleep> sleep=[];
    sleep = SleepMe.fromJson(jsonDecode(response.body)).sleep;

    print("Date of Sleep");
    print(sleep[0].dateOfSleep);
    if(sleep[0].dateOfSleep == "${now.year}-${now.month.toString().padLeft(2,"0")}-${now.day.toString().padLeft(2,"0")}"){
      latestSleep = sleep[0];
    }
    // print(response.body);
    // print("FITBIT ^ Length = " + sleep.length.toString());
  }
}
