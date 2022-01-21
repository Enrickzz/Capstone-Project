import 'package:my_app/ui_view/BloodGlucose_TimeChart.dart';
import 'package:my_app/ui_view/HeartRate_TimeChart.dart';
import 'package:my_app/ui_view/Oxygen_TimeChart.dart';
import 'package:my_app/ui_view/Sleep_StackedBarChart.dart';
import 'package:my_app/ui_view/StackedBar.dart';
import 'package:my_app/ui_view/TimeSeries.dart';
import 'package:my_app/ui_view/VerticalBC_Target.dart';
import 'package:my_app/ui_view/VerticalBarChart.dart';
import 'package:my_app/ui_view/water_view.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/ui_view/weight/BMI_chart.dart';
import 'package:my_app/ui_view/area_list_view.dart';
import 'package:my_app/ui_view/body_measurement.dart';
import 'package:my_app/ui_view/calorie_intake.dart';
import 'package:my_app/ui_view/cholesterol_chart.dart';
import 'package:my_app/ui_view/diet_view.dart';
import 'package:my_app/ui_view/fitbit_connect.dart';
import 'package:my_app/ui_view/glass_view.dart';
import 'package:my_app/ui_view/glucose_levels_chart.dart';
import 'package:my_app/ui_view/heartrate.dart';
import 'package:my_app/ui_view/ihealth_connect.dart';
import 'package:my_app/ui_view/running_view.dart';
import 'package:my_app/ui_view/spotify_connect.dart';
import 'package:my_app/ui_view/title_view.dart';
import 'package:my_app/ui_view/workout_view.dart';
import 'package:my_app/ui_view/bp_chart.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../fitness_app_theme.dart';
import '../main.dart';
import '../notifications/notifications._patients.dart';

class Dashboards extends StatefulWidget {
  const Dashboards({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;
  @override
  _DashboardsState createState() => _DashboardsState();
}

class _DashboardsState extends State<Dashboards>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();

  final AuthService _auth = AuthService();
  List<bool> expandableState=[];
  double topBarOpacity = 0.0;

  @override
  void initState() {

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
    expandableState = List.generate(listViews.length, (index) => false);
    super.initState();
  }

  void addAllListData() {
    const int count = 5;

    listViews.add(
      TitleView(
        titleTxt: 'Your program',
        subTxt: 'Details',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );
    // listViews.add(
    //     StackedBarChart( animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController,
    //         curve:
    //         Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
    //       animationController: widget.animationController,
    //     ));
    // listViews.add(
    //     SimpleTimeSeriesChart( animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController,
    //         curve:
    //         Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
    //       animationController: widget.animationController,
    //     ));
    listViews.add(
        BGTimeSeries( animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: widget.animationController,
        ));
    listViews.add(
        OxyTimeSeries( animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: widget.animationController,
        ));
    listViews.add(
        HRTimeSeries( animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: widget.animationController,
        ));
    listViews.add(
        Sleep_StackedBarChart( animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: widget.animationController,
        ));
    // listViews.add(
    //     VerticalBarLabelChart( animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController,
    //         curve:
    //         Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
    //       animationController: widget.animationController,
    //     ));
    // listViews.add(
    //     StackedBarTargetLineChart( animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController,
    //         curve:
    //         Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
    //       animationController: widget.animationController,
    //     ));
    // listViews.add(
    //   heartrate(
    //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController,
    //         curve:
    //         Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
    //     animationController: widget.animationController,
    //   ),
    // );
    // listViews.add(
    //   DietView(
    //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController,
    //         curve:
    //         Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
    //     animationController: widget.animationController,
    //   ),
    // );
    listViews.add(
      cholesterol_chart(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    listViews.add(
      bp_chart(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    // listViews.add(
    //   calorie_intake(
    //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController,
    //         curve:
    //         Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
    //     animationController: widget.animationController,
    //   ),
    // );
    listViews.add(
      glucose_levels(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    // listViews.add(
    //   WorkoutView(
    //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController,
    //         curve:
    //         Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
    //     animationController: widget.animationController,
    //   ),
    // );
    // listViews.add(
    //   RunningView(
    //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController,
    //         curve:
    //             Interval((1 / count) * 3, 1.0, curve: Curves.fastOutSlowIn))),
    //     animationController: widget.animationController,
    //   ),
    // );

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
      ihealth_connect(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );
    // listViews.add(
    //   spotify_connect(
    //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController,
    //         curve:
    //         Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
    //     animationController: widget.animationController,
    //   ),
    // );


    listViews.add(
      TitleView(
        titleTxt: 'Body measurement',
        subTxt: 'Today',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    listViews.add(
      BodyMeasurementView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 5, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );
    listViews.add(
      TitleView(
        titleTxt: 'Water',
        subTxt: 'Aqua SmartBottle',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 6, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    listViews.add(
      WaterView(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController,
                curve: Interval((1 / count) * 7, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );
    listViews.add(
      GlassView(
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: widget.animationController,
                  curve: Interval((1 / count) * 8, 1.0,
                      curve: Curves.fastOutSlowIn))),
          animationController: widget.animationController),
    );

    // listViews.add(
    //   TitleView(
    //     titleTxt: 'Area of focus',
    //     subTxt: 'more',
    //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController,
    //         curve:
    //             Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
    //     animationController: widget.animationController,
    //   ),
    // );

    // listViews.add(
    //   AreaListView(
    //     mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
    //         CurvedAnimation(
    //             parent: widget.animationController,
    //             curve: Interval((1 / count) * 5, 1.0,
    //                 curve: Curves.fastOutSlowIn))),
    //     mainScreenAnimationController: widget.animationController,
    //   ),
    // );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  Widget bloc (double width, int index) {
    bool isExpanded = expandableState[index];

    return GestureDetector(
      onTap: () {
        setState(() {
          //changing the current expandableState
          expandableState[index] = !isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: const EdgeInsets.all(20.0),
        width: !isExpanded ? width * 0.4 : width * 0.8,
        height: !isExpanded ? width * 0.4 : width * 0.8,
        child: Container(
          child: listViews[index],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   double width = MediaQuery.of(context).size.width;
  //
  //   return Scaffold(
  //     body: Align(
  //       child: SingleChildScrollView(
  //         child: Wrap(
  //           children: List.generate(listViews.length, (index) {
  //             return bloc(width, index);
  //           }),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(milliseconds: 5000), () {
    //   setState(() {
    //     print("FULL SET STATE");
    //   });
    // });
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
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
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
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
                                  'My Health',
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
                                    Icon(Icons.notifications, ),
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
}
