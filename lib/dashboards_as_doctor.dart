import 'package:my_app/services/auth.dart';
import 'package:my_app/ui_view/BMI_chart.dart';
import 'package:my_app/my_diary/area_list_view.dart';
import 'package:my_app/ui_view/calorie_intake.dart';
import 'package:my_app/ui_view/cholesterol_chart.dart';
import 'package:my_app/ui_view/diet_view.dart';
import 'package:my_app/ui_view/glucose_levels_chart.dart';
import 'package:my_app/ui_view/heartrate.dart';
import 'package:my_app/ui_view/running_view.dart';
import 'package:my_app/ui_view/title_view.dart';
import 'package:my_app/ui_view/workout_view.dart';
import 'package:my_app/ui_view/bp_chart.dart';
import 'package:flutter/material.dart';

import '../fitness_app_theme.dart';
import '../main.dart';
import '../notifications.dart';

class dashboards_as_doctor extends StatefulWidget {
  @override
  _dashboards_as_doctorState createState() => _dashboards_as_doctorState();
}

class _dashboards_as_doctorState extends State<dashboards_as_doctor>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();

  final AuthService _auth = AuthService();

  double topBarOpacity = 0.0;

  @override
  void initState() {

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
    super.initState();
  }

  void addAllListData() {
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

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
          appBar: AppBar(
            iconTheme: IconThemeData(
                color: Colors.black
            ),
            title: Text("Patient's Dashboard", style: TextStyle(
                color: Colors.black
            )),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: Stack(
            children: <Widget>[
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 24, top: 16, bottom: 18),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          FitnessAppTheme.nearlyDarkBlue,
                          HexColor("#6F56E8")
                        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                            topRight: Radius.circular(8.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: FitnessAppTheme.grey.withOpacity(0.6),
                              offset: Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Heart Rate',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: FitnessAppTheme.fontName,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                letterSpacing: 0.0,
                                color: FitnessAppTheme.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: const Text(
                                '80 BPM',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                  letterSpacing: 0.0,
                                  color: FitnessAppTheme.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Icon(
                                      Icons.timer,
                                      color: FitnessAppTheme.white,
                                      size: 16,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: const Text(
                                      '68 min',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        letterSpacing: 0.0,
                                        color: FitnessAppTheme.white,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: FitnessAppTheme.nearlyWhite,
                                      shape: BoxShape.circle,
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: FitnessAppTheme.nearlyBlack
                                                .withOpacity(0.4),
                                            offset: Offset(8.0, 8.0),
                                            blurRadius: 8.0),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Icon(
                                        Icons.arrow_right,
                                        color: HexColor("#6F56E8"),
                                        size: 44,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 24, top: 16, bottom: 18),
                    child: Container(
                      decoration: BoxDecoration(
                        color: FitnessAppTheme.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                            topRight: Radius.circular(68.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: FitnessAppTheme.grey.withOpacity(0.2),
                              offset: Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding:
                            const EdgeInsets.only(top: 16, left: 16, right: 16),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8, top: 4),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              height: 48,
                                              width: 2,
                                              decoration: BoxDecoration(
                                                color: HexColor('#87A0E5')
                                                    .withOpacity(0.5),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4.0)),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 4, bottom: 2),
                                                    child: Text(
                                                      'Eaten',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily:
                                                        FitnessAppTheme.fontName,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 16,
                                                        letterSpacing: -0.1,
                                                        color: FitnessAppTheme.grey
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 28,
                                                        height: 28,
                                                        child: Image.asset(
                                                            "assets/fitness_app/eaten.png"),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            left: 4, bottom: 3),
                                                        child: Text(
                                                          "1127 kcal",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily:
                                                            FitnessAppTheme
                                                                .fontName,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                            fontSize: 16,
                                                            color: FitnessAppTheme
                                                                .darkerText,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            left: 4, bottom: 3),
                                                        child: Text(
                                                          'Kcal',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily:
                                                            FitnessAppTheme
                                                                .fontName,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                            fontSize: 12,
                                                            letterSpacing: -0.2,
                                                            color: FitnessAppTheme
                                                                .grey
                                                                .withOpacity(0.5),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              height: 48,
                                              width: 2,
                                              decoration: BoxDecoration(
                                                color: HexColor('#F56E98')
                                                    .withOpacity(0.5),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4.0)),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 4, bottom: 2),
                                                    child: Text(
                                                      'Burned',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily:
                                                        FitnessAppTheme.fontName,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 16,
                                                        letterSpacing: -0.1,
                                                        color: FitnessAppTheme.grey
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 28,
                                                        height: 28,
                                                        child: Image.asset(
                                                            "assets/fitness_app/burned.png"),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            left: 4, bottom: 3),
                                                        child: Text(
                                                          "102",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily:
                                                            FitnessAppTheme
                                                                .fontName,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                            fontSize: 16,
                                                            color: FitnessAppTheme
                                                                .darkerText,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            left: 8, bottom: 3),
                                                        child: Text(
                                                          'Kcal',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily:
                                                            FitnessAppTheme
                                                                .fontName,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                            fontSize: 12,
                                                            letterSpacing: -0.2,
                                                            color: FitnessAppTheme
                                                                .grey
                                                                .withOpacity(0.5),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Center(
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: FitnessAppTheme.white,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(100.0),
                                              ),
                                              border: new Border.all(
                                                  width: 4,
                                                  color: FitnessAppTheme
                                                      .nearlyDarkBlue
                                                      .withOpacity(0.2)),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  "1503",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily:
                                                    FitnessAppTheme.fontName,
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 24,
                                                    letterSpacing: 0.0,
                                                    color: FitnessAppTheme
                                                        .nearlyDarkBlue,
                                                  ),
                                                ),
                                                Text(
                                                  'Kcal left',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily:
                                                    FitnessAppTheme.fontName,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    letterSpacing: 0.0,
                                                    color: FitnessAppTheme.grey
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: CustomPaint(
                                            painter: CurvePainter(
                                                colors: [
                                                  FitnessAppTheme.nearlyDarkBlue,
                                                  HexColor("#8A98E8"),
                                                  HexColor("#8A98E8")
                                                ],
                                                angle: 140 +
                                                    (360 - 140) *
                                                        (1.0 - 1)),
                                            child: SizedBox(
                                              width: 108,
                                              height: 108,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 24, right: 24, top: 8, bottom: 8),
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                color: FitnessAppTheme.background,
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 24, right: 24, top: 8, bottom: 16),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Carbs',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          letterSpacing: -0.2,
                                          color: FitnessAppTheme.darkText,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Container(
                                          height: 4,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            color:
                                            HexColor('#87A0E5').withOpacity(0.2),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4.0)),
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                width: ((70 / 1.2) * 1),
                                                height: 4,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(colors: [
                                                    HexColor('#87A0E5'),
                                                    HexColor('#87A0E5')
                                                        .withOpacity(0.5),
                                                  ]),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(4.0)),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          '12g left',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color:
                                            FitnessAppTheme.grey.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Protein',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: FitnessAppTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              letterSpacing: -0.2,
                                              color: FitnessAppTheme.darkText,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: Container(
                                              height: 4,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                color: HexColor('#F56E98')
                                                    .withOpacity(0.2),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4.0)),
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: ((70 / 2) *
                                                        1),
                                                    height: 4,
                                                    decoration: BoxDecoration(
                                                      gradient:
                                                      LinearGradient(colors: [
                                                        HexColor('#F56E98')
                                                            .withOpacity(0.1),
                                                        HexColor('#F56E98'),
                                                      ]),
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(4.0)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 6),
                                            child: Text(
                                              '30g left',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: FitnessAppTheme.fontName,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: FitnessAppTheme.grey
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Fat',
                                            style: TextStyle(
                                              fontFamily: FitnessAppTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              letterSpacing: -0.2,
                                              color: FitnessAppTheme.darkText,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 0, top: 4),
                                            child: Container(
                                              height: 4,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                color: HexColor('#F1B440')
                                                    .withOpacity(0.2),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4.0)),
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: ((70 / 2.5) *
                                                        1),
                                                    height: 4,
                                                    decoration: BoxDecoration(
                                                      gradient:
                                                      LinearGradient(colors: [
                                                        HexColor('#F1B440')
                                                            .withOpacity(0.1),
                                                        HexColor('#F1B440'),
                                                      ]),
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(4.0)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 6),
                                            child: Text(
                                              '10g left',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: FitnessAppTheme.fontName,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: FitnessAppTheme.grey
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        )
    );
  }

}
